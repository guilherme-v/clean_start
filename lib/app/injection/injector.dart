import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:rootshealth_test/layers/data/data.dart';
import 'package:rootshealth_test/layers/datasource/datasources.dart';
import 'package:rootshealth_test/layers/domain/domain.dart';
import 'package:rootshealth_test/layers/presentation/presentation.dart';

// ignore_for_file: cascade_invocations

// This is our global ServiceLocator
GetIt getIt = GetIt.instance..allowReassignment = true;

void initializeServiceLocator() {
  // DataSources
  getIt.registerFactory<BluetoothDatasource>(
    () => BluetoothFakeDatasource(bundle: rootBundle),
  );

  // Data
  getIt.registerFactory<GlucoseRepository>(
    () => GlucoseDataRepository(bluetoothSensor: getIt()),
  );

  // Domain
  getIt.registerFactory(() => CalculateNumberOfGlucoseSpikes());
  getIt.registerFactory(() => CheckPercentageOfHealthValues());
  getIt.registerFactory(() => ReadGlucoseValues(repository: getIt()));

  // Presentation
  getIt.registerFactory(
    () => HomeCubit(
      calculateNumberOfGlucoseSpikes: getIt(),
      checkPercentageOfHealthValues: getIt(),
      readGlucoseValues: getIt(),
    ),
  );
}
