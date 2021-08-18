import 'package:rootshealth_test/layers/domain/domain.dart';

class CheckPercentageOfHealthValues {
  int call(List<GlucoseRecord> list) {
    var counter = 0;
    for (final e in list) {
      if (e.isHealthy) counter++;
    }
    return ((counter / list.length) * 100).toInt();
  }
}
