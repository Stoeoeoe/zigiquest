import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:geolocator/geolocator.dart';

class RoutePoint {
  const RoutePoint(this.latitude, this.longitude);
  final double latitude;
  final double longitude;

  List<double> toJson() => [latitude, longitude];
}

class SessionLocationSnapshot {
  const SessionLocationSnapshot({
    required this.mode,
    this.approximateLatitude,
    this.approximateLongitude,
    required this.distanceMeters,
    required this.route,
  });

  final String mode;
  final double? approximateLatitude;
  final double? approximateLongitude;
  final double distanceMeters;
  final List<RoutePoint> route;

  String? get routeJson => route.isEmpty
      ? null
      : jsonEncode({
          'version': 1,
          'points': [for (final point in route) point.toJson()],
        });
}

class LocationService {
  Future<bool> requestWhenEnabled() async {
    if (!await Geolocator.isLocationServiceEnabled()) return false;
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;
  }

  Future<Position?> currentPosition() async {
    if (!await requestWhenEnabled()) return null;
    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.medium,
      ),
    );
  }

  Stream<Position> foregroundPositions() => Geolocator.getPositionStream(
    locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.medium,
      distanceFilter: 10,
    ),
  );

  double approximate(double coordinate, [int decimals = 3]) {
    final scale = pow(10, decimals);
    return (coordinate * scale).round() / scale;
  }

  List<RoutePoint> simplify(
    List<RoutePoint> points, {
    double tolerance = .00008,
    int cap = 500,
  }) {
    if (points.length <= 2) return points;
    final sampled = points.length > cap
        ? [
            for (
              var index = 0;
              index < points.length;
              index += (points.length / cap).ceil()
            )
              points[index],
          ]
        : [...points];
    if (sampled.last != points.last) sampled.add(points.last);
    final result = <RoutePoint>[sampled.first];
    for (final point in sampled.skip(1)) {
      final last = result.last;
      if ((point.latitude - last.latitude).abs() +
              (point.longitude - last.longitude).abs() >=
          tolerance) {
        result.add(point);
      }
    }
    if (result.last != sampled.last) result.add(sampled.last);
    return result;
  }
}

/// Tracks location only while the foreground cleanup session is active.
class SessionLocationTracker {
  SessionLocationTracker(this._service, this.mode, {this.onUpdate});

  final LocationService _service;
  final String mode;
  final void Function(SessionLocationSnapshot snapshot)? onUpdate;
  final List<RoutePoint> _rawRoute = [];
  StreamSubscription<Position>? _subscription;
  Position? _lastPosition;
  double _distanceMeters = 0;
  double? _approximateLatitude;
  double? _approximateLongitude;

  bool get isTracking => _subscription != null;

  Future<bool> start() async {
    if (mode == 'none') return true;
    final position = await _service.currentPosition();
    if (position == null) return false;
    _record(position);
    if (mode == 'route')
      _subscription = _service.foregroundPositions().listen(_record);
    return true;
  }

  Future<bool> resume() async {
    if (mode != 'route' || _subscription != null) return true;
    return start();
  }

  Future<void> pause() async {
    await _subscription?.cancel();
    _subscription = null;
  }

  Future<SessionLocationSnapshot> stop() async {
    await pause();
    return snapshot;
  }

  SessionLocationSnapshot get snapshot => SessionLocationSnapshot(
    mode: mode,
    approximateLatitude: _approximateLatitude,
    approximateLongitude: _approximateLongitude,
    distanceMeters: _distanceMeters,
    route: _service.simplify(_rawRoute),
  );

  void _record(Position position) {
    if (_lastPosition != null && mode == 'route') {
      final segment = Geolocator.distanceBetween(
        _lastPosition!.latitude,
        _lastPosition!.longitude,
        position.latitude,
        position.longitude,
      );
      if (segment <= 250) _distanceMeters += segment;
    }
    _lastPosition = position;
    _approximateLatitude = _service.approximate(position.latitude);
    _approximateLongitude = _service.approximate(position.longitude);
    if (mode == 'route')
      _rawRoute.add(RoutePoint(position.latitude, position.longitude));
    onUpdate?.call(snapshot);
  }
}
