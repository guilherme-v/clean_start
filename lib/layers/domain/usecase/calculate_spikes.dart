import 'package:rootshealth_test/layers/domain/domain.dart';

class CalculateNumberOfGlucoseSpikes {
  int call(List<GlucoseRecord> list) {
    var spikeCounter = 0;
    var latestSpikeIndex = -1;

    // edge case
    if (list.length < 2) return 0;

    for (var i = 1; i < list.length; i++) {
      // current item
      final current = list[i];

      // previous item
      var previousIndex = i - 1;
      final previous = list[previousIndex];

      // requirements to be a spike
      final interval =
          current.recordedAt.difference(previous.recordedAt).inMinutes;
      final isWithin15MinWindow =
          interval <= ReferenceValues.maxIntervalToBeASpikeInMin;

      // look back until time is more than 20 or until we reached the
      // previous spike
      while (isWithin15MinWindow && previousIndex >= 0) {
        if (previousIndex == latestSpikeIndex) break;

        final isDelta = current.value - previous.value >= 20;

        if (isDelta && current.value >= 110) {
          spikeCounter++;
          latestSpikeIndex = i;
          break;
        }

        previousIndex--;
      }
    }

    return spikeCounter;
  }
}
