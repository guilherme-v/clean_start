import 'package:rootshealth_test/extensions/extensions.dart';
import 'package:rootshealth_test/layers/domain/domain.dart';

class DailyResume {
  DailyResume({
    required this.date,
  });

  final DateTime date;
  final List<GlucoseRecord> glucoseRecords = List.empty(growable: true);
  late final int numberOfSpikes;
  late final int percentageOfHealthyValues;

  static Map<DateTime, DailyResume> generateDailyResumes({
    required List<GlucoseRecord> glucoseList,
    required int Function(List<GlucoseRecord> list) spikesAnalyzerAlgorithm,
    required int Function(List<GlucoseRecord> list) healthPercentageAlgorithm,
  }) {
    final dailyResumes = <DateTime, DailyResume>{};

    for (final e in glucoseList) {
      final key = e.recordedAt.dateOnly;
      dailyResumes.putIfAbsent(key, () => DailyResume(date: key));
      dailyResumes[key]?.glucoseRecords.add(e);
    }

    for (final resume in dailyResumes.values) {
      final list = resume.glucoseRecords;
      resume
        ..numberOfSpikes = spikesAnalyzerAlgorithm(list)
        ..percentageOfHealthyValues = healthPercentageAlgorithm(list);
    }

    return dailyResumes;
  }
}
