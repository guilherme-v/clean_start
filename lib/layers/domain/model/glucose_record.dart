import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:rootshealth_test/layers/domain/domain.dart';

class GlucoseRecord with EquatableMixin implements Comparable<GlucoseRecord> {
  GlucoseRecord({
    required this.recordedAt,
    required this.value,
  });

  GlucoseRecord.fromRawEntry(List entry)
      : recordedAt = _dateTimeExpectedFormat.parse(entry[0] as String),
        value = entry[1] as int;

  static final _dateTimeExpectedFormat = DateFormat('d-M-y H:m');

  final DateTime recordedAt;
  final int value;

  bool get isHealthy =>
      value >= ReferenceValues.healthyPersonGlucoseMinLevelInMg &&
      value <= ReferenceValues.healthyPersonGlucoseMaxLevelInMg;

  @override
  String toString() => 'GlucoseEntry(recordedAt: $recordedAt, value: $value)';

  @override
  List<Object?> get props => [recordedAt, value];

  @override
  int compareTo(covariant GlucoseRecord other) =>
      recordedAt.compareTo(other.recordedAt);
}

// or Factory Method
// factory GlucoseEntry.fromRawEntry(List entry) {
//   final rawDateTime = entry[0] as String;
//   final dateTime = format.parse(rawDateTime);
//   final value = entry[1] as int;
//   return GlucoseEntry(dateTime: dateTime, value: value);
// }
