import 'package:neom_maps_services/utils/neom_geohash.dart';
import 'package:test/test.dart';

void main() {
  group('NeomGeohash Tests', () {
    test('Should encode coordinate to standard geohash', () {
      // Coordinates of Guadalajara: 20.659698, -103.349609
      final hash = NeomGeohash.encode(20.659698, -103.349609, precision: 9);
      expect(hash.length, 9);
      expect(hash, startsWith('9ew')); // Guadalajara standard geohash starts with '9ew'
    });

    test('Should round-trip encode and decode coordinates within bounds', () {
      final lat = 37.7749; // San Francisco
      final lon = -122.4194;
      final precision = 9;

      final hash = NeomGeohash.encode(lat, lon, precision: precision);
      final decoded = NeomGeohash.decode(hash);

      expect(decoded['latitude']!, closeTo(lat, decoded['latitude_error']!));
      expect(decoded['longitude']!, closeTo(lon, decoded['longitude_error']!));
    });

    test('Should throw exception for invalid geohash character during decode', () {
      expect(() => NeomGeohash.decode('d5f#g8'), throwsFormatException);
    });
  });
}
