import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class CleanupRouteMap extends StatelessWidget {
  const CleanupRouteMap({
    required this.routeJson,
    required this.approximateLatitude,
    required this.approximateLongitude,
    super.key,
  });

  final String? routeJson;
  final double? approximateLatitude;
  final double? approximateLongitude;

  List<LatLng> get _points {
    try {
      final decoded = jsonDecode(routeJson ?? '') as Map<String, dynamic>;
      final raw = decoded['points'] as List<dynamic>;
      return raw
          .whereType<List<dynamic>>()
          .where((point) => point.length >= 2)
          .map(
            (point) => LatLng(
              (point[0] as num).toDouble(),
              (point[1] as num).toDouble(),
            ),
          )
          .toList();
    } catch (_) {
      if (approximateLatitude != null && approximateLongitude != null) {
        return [LatLng(approximateLatitude!, approximateLongitude!)];
      }
      return const [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final points = _points;
    if (points.isEmpty) return const SizedBox.shrink();
    final colors = Theme.of(context).colorScheme;
    final bounds = LatLngBounds.fromPoints(points);
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: SizedBox(
        height: 205,
        child: FlutterMap(
          options: MapOptions(
            initialCenter: points.first,
            initialZoom: points.length == 1 ? 16 : 14,
            onMapReady: () {},
            initialCameraFit: points.length > 1
                ? CameraFit.bounds(
                    bounds: bounds,
                    padding: const EdgeInsets.all(30),
                  )
                : null,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.zigiquest.app',
            ),
            if (points.length > 1)
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: points,
                    strokeWidth: 4,
                    color: colors.primary,
                  ),
                ],
              ),
            MarkerLayer(
              markers: [
                Marker(
                  point: points.first,
                  width: 34,
                  height: 34,
                  child: Icon(Icons.play_circle_fill_rounded, color: colors.primary),
                ),
                if (points.length > 1)
                  Marker(
                    point: points.last,
                    width: 34,
                    height: 34,
                    child: Icon(Icons.flag_circle_rounded, color: colors.tertiary),
                  ),
              ],
            ),
            const SimpleAttributionWidget(
              source: Text('OpenStreetMap contributors'),
            ),
          ],
        ),
      ),
    );
  }
}
