import 'package:rootshealth_test/layers/data/datasource/local/bluetooth_datasource.dart';
import 'package:rootshealth_test/layers/domain/model/glucose_record.dart';

class BluetoothSensorDatasource extends BluetoothDatasource {
  @override
  Future<List<GlucoseRecord>> readGlucoseRecords() {
    throw UnimplementedError();
  }
}
