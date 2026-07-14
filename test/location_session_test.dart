import 'package:flutter_test/flutter_test.dart';
import 'package:zigi_quest/core/services/location_service.dart';

void main() {
  test(
    'session route snapshot rounds location and serializes private route compactly',
    () {
      const snapshot = SessionLocationSnapshot(
        mode: 'route',
        approximateLatitude: 47.377,
        approximateLongitude: 8.542,
        distanceMeters: 123.4,
        route: [RoutePoint(47.37688, 8.54169), RoutePoint(47.37702, 8.54188)],
      );
      expect(snapshot.routeJson, contains('"version":1'));
      expect(snapshot.routeJson, contains('47.37688'));
      expect(snapshot.approximateLatitude, 47.377);
    },
  );

  test('route simplification keeps endpoints and respects cap', () {
    final service = LocationService();
    final points = List.generate(
      800,
      (index) => RoutePoint(47 + index / 100000, 8 + index / 100000),
    );
    final simplified = service.simplify(points, cap: 100);
    expect(simplified.first.latitude, points.first.latitude);
    expect(simplified.last.latitude, points.last.latitude);
    expect(simplified.length, lessThanOrEqualTo(101));
  });
}
