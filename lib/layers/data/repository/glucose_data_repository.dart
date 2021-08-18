import 'package:rootshealth_test/layers/data/datasource/local/bluetooth_datasource.dart';
import 'package:rootshealth_test/layers/domain/model/glucose_record.dart';
import 'package:rootshealth_test/layers/domain/repository/glucose_repository.dart';

class GlucoseDataRepository extends GlucoseRepository {
  GlucoseDataRepository({
    required this.bluetoothSensor,
  });

  final BluetoothDatasource bluetoothSensor;

  @override
  Future<List<GlucoseRecord>> readGlucoseValues() {
    return bluetoothSensor.readGlucoseRecords();
  }
}
