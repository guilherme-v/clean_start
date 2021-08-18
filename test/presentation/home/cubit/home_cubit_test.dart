import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rootshealth_test/layers/domain/domain.dart';
import 'package:rootshealth_test/layers/presentation/presentation.dart';

class MockReadGlucoseValues extends Mock implements ReadGlucoseValues {}

class MockCalculateNumberOfGlucoseSpikes extends Mock
    implements CalculateNumberOfGlucoseSpikes {}

class MockCheckPercentageOfHealthValues extends Mock
    implements CheckPercentageOfHealthValues {}

void main() {
  late ReadGlucoseValues readGlucoseValues;
  late CalculateNumberOfGlucoseSpikes calculateNumberOfGlucoseSpikes;
  late CheckPercentageOfHealthValues checkPercentageOfHealthValues;
  final glucoseRecords = List.generate(
    3,
    (index) => GlucoseRecord(
      recordedAt: DateTime.now(),
      value: 10 * index,
    ),
  );

  setUpAll(() {
    readGlucoseValues = MockReadGlucoseValues();
    calculateNumberOfGlucoseSpikes = MockCalculateNumberOfGlucoseSpikes();
    checkPercentageOfHealthValues = MockCheckPercentageOfHealthValues();

    when(() => readGlucoseValues.call())
        .thenAnswer((_) async => glucoseRecords);
    when(() => calculateNumberOfGlucoseSpikes(glucoseRecords)).thenReturn(1);
    when(() => checkPercentageOfHealthValues(glucoseRecords)).thenReturn(1);
  });

  group('HomeCubit', () {
    test('Initial State should be correct', () {
      final expected = HomeState();
      final actual = HomeCubit(
        readGlucoseValues: readGlucoseValues,
        calculateNumberOfGlucoseSpikes: calculateNumberOfGlucoseSpikes,
        checkPercentageOfHealthValues: checkPercentageOfHealthValues,
      ).state;

      expect(actual, expected);
    });

    group('.loadGlucoseList', () {
      blocTest<HomeCubit, HomeState>(
        'emits state with updated glucoseRecords and dailyResumes',
        build: () => HomeCubit(
          readGlucoseValues: readGlucoseValues,
          calculateNumberOfGlucoseSpikes: calculateNumberOfGlucoseSpikes,
          checkPercentageOfHealthValues: checkPercentageOfHealthValues,
        ),
        act: (cubit) => cubit.loadGlucoseList(),
        expect: () => [
          HomeState(
            status: HomeStatus.loading,
          ),
          HomeState(
            status: HomeStatus.success,
            glucoseRecords: glucoseRecords,
            dailyResumes: DailyResume.generateDailyResumes(
              glucoseList: glucoseRecords,
              spikesAnalyzerAlgorithm: calculateNumberOfGlucoseSpikes,
              healthPercentageAlgorithm: checkPercentageOfHealthValues,
            ),
          ),
        ],
      );
    });
  });
}
