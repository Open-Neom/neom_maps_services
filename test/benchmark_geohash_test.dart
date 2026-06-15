import 'package:flutter_test/flutter_test.dart';
import 'package:neom_maps_services/utils/neom_geohash.dart';

void main() {
  group('Geohash Performance Benchmarks', () {
    test('Run Geohash Encoding and Decoding Throughput Benchmark', () {
      print('=== GEOHASH PERFORMANCE BENCHMARK ===');

      const int iterations = 10000;
      final double lat = 20.659698;
      final double lon = -103.349609;
      final String hash = '9ewt80zp7';

      // --- 1. Encode Performance ---
      final stopwatchEnc = Stopwatch()..start();
      for (int i = 0; i < iterations; i++) {
        NeomGeohash.encode(lat, lon, precision: 9);
      }
      stopwatchEnc.stop();

      final encTimeMs = stopwatchEnc.elapsedMicroseconds / 1000;
      final encOpsPerSec = (iterations / encTimeMs) * 1000;

      // --- 2. Decode Performance ---
      final stopwatchDec = Stopwatch()..start();
      for (int i = 0; i < iterations; i++) {
        NeomGeohash.decode(hash);
      }
      stopwatchDec.stop();

      final decTimeMs = stopwatchDec.elapsedMicroseconds / 1000;
      final decOpsPerSec = (iterations / decTimeMs) * 1000;

      print('Configurations:');
      print('  Iterations:                 $iterations');
      print('  Geohash Precision:          9 characters');
      print('\nResults:');
      print('  Encoding Time:              ${encTimeMs.toStringAsFixed(2)} ms (${encOpsPerSec.toStringAsFixed(0)} ops/sec)');
      print('  Decoding Time:              ${decTimeMs.toStringAsFixed(2)} ms (${decOpsPerSec.toStringAsFixed(0)} ops/sec)');
      print('========================================\n');

      expect(encTimeMs, greaterThan(0));
      expect(decTimeMs, greaterThan(0));
    });
  });
}
