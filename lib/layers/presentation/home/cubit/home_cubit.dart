import 'package:bloc/bloc.dart';
import 'package:rootshealth_test/extensions/extensions.dart';
import 'package:rootshealth_test/layers/domain/domain.dart';
import 'package:rootshealth_test/layers/presentation/presentation.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({
    required ReadGlucoseValues readGlucoseValues,
    required CalculateNumberOfGlucoseSpikes calculateNumberOfGlucoseSpikes,
    required CheckPercentageOfHealthValues checkPercentageOfHealthValues,
  })  : _calculateNumberOfGlucoseSpikes = calculateNumberOfGlucoseSpikes,
        _checkPercentageOfHealthValues = checkPercentageOfHealthValues,
        _readGlucoseValues = readGlucoseValues,
        super(HomeState());

  final CalculateNumberOfGlucoseSpikes _calculateNumberOfGlucoseSpikes;
  final CheckPercentageOfHealthValues _checkPercentageOfHealthValues;
  final ReadGlucoseValues _readGlucoseValues;

  Future<void> loadGlucoseList() async {
    emit(HomeState(status: HomeStatus.loading));

    final glucoseEntries = await _readGlucoseValues();
    glucoseEntries.sorted(ascending: state.sortOrder.isAscending);

    final dailyResumes = DailyResume.generateDailyResumes(
      glucoseList: glucoseEntries,
      spikesAnalyzerAlgorithm: _calculateNumberOfGlucoseSpikes,
      healthPercentageAlgorithm: _checkPercentageOfHealthValues,
    );

    emit(HomeState(
      status: HomeStatus.success,
      glucoseRecords: glucoseEntries,
      dailyResumes: dailyResumes,
    ));
  }

  void sortBy(SortOrder order) {
    state.glucoseRecords.sorted(ascending: order.isAscending);
    emit(HomeState(
      sortOrder: order,
      status: state.status,
      dailyResumes: state.dailyResumes,
      glucoseRecords: state.glucoseRecords,
    ));
  }
}
