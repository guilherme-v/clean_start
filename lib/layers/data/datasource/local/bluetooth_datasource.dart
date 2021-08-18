import 'package:rootshealth_test/layers/domain/domain.dart';

abstract class BluetoothDatasource {
  Future<List<GlucoseRecord>> readGlucoseRecords();
}
