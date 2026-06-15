import 'package:neom_codecs/neom_codecs.dart';

/// Standard Geohashing service built over NeomBaseCodecs GeoHash32 alphabet.
///
/// Encodes latitude/longitude coordinates into alphanumeric hashes for spatial queries,
/// proximity indexing, and obfuscated coordinate transport in P2P mesh logs.
class NeomGeohash {
  static const String _alphabet = "0123456789bcdefghjkmnpqrstuvwxyz";

  /// Encodes latitude and longitude into a standard geohash string.
  static String encode(double latitude, double longitude, {int precision = 9}) {
    double latMin = -90.0, latMax = 90.0;
    double lonMin = -180.0, lonMax = 180.0;

    final StringBuffer hash = StringBuffer();
    bool isEven = true;
    int bit = 0;
    int ch = 0;

    while (hash.length < precision) {
      if (isEven) {
        final double mid = (lonMin + lonMax) / 2;
        if (longitude >= mid) {
          ch |= (1 << (4 - bit));
          lonMin = mid;
        } else {
          lonMax = mid;
        }
      } else {
        final double mid = (latMin + latMax) / 2;
        if (latitude >= mid) {
          ch |= (1 << (4 - bit));
          latMin = mid;
        } else {
          latMax = mid;
        }
      }

      isEven = !isEven;
      if (bit < 4) {
        bit++;
      } else {
        hash.write(_alphabet[ch]);
        bit = 0;
        ch = 0;
      }
    }
    return hash.toString();
  }

  /// Decodes a geohash string back into exact coordinate bounds.
  static Map<String, double> decode(String geohash) {
    double latMin = -90.0, latMax = 90.0;
    double lonMin = -180.0, lonMax = 180.0;

    bool isEven = true;

    for (int i = 0; i < geohash.length; i++) {
      final int c = _alphabet.indexOf(geohash[i]);
      if (c == -1) {
        throw FormatException("Invalid geohash character: ${geohash[i]}");
      }

      for (int mask = 16; mask > 0; mask >>= 1) {
        final bool bit = (c & mask) != 0;
        if (isEven) {
          final double mid = (lonMin + lonMax) / 2;
          if (bit) {
            lonMin = mid;
          } else {
            lonMax = mid;
          }
        } else {
          final double mid = (latMin + latMax) / 2;
          if (bit) {
            latMin = mid;
          } else {
            latMax = mid;
          }
        }
        isEven = !isEven;
      }
    }

    final double latitude = (latMin + latMax) / 2;
    final double longitude = (lonMin + lonMax) / 2;
    final double latError = latMax - latitude;
    final double lonError = lonMax - longitude;

    return {
      'latitude': latitude,
      'longitude': longitude,
      'latitude_error': latError,
      'longitude_error': lonError,
    };
  }
}
