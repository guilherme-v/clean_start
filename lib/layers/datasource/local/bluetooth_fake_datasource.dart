import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'package:rootshealth_test/layers/data/datasource/local/bluetooth_datasource.dart';
import 'package:rootshealth_test/layers/domain/model/glucose_record.dart';

class BluetoothFakeDatasource extends BluetoothDatasource {
  BluetoothFakeDatasource({required this.bundle});

  final AssetBundle bundle;

  @override
  Future<List<GlucoseRecord>> readGlucoseRecords() async {
    final input = await bundle.loadString('assets/csv/values.csv');

    final rawHeaderAndEntries = const CsvToListConverter().convert(input);
    final rawEntriesOnly = rawHeaderAndEntries.skip(1).toList();
    final glucoseEntries =
        rawEntriesOnly.map((e) => GlucoseRecord.fromRawEntry(e)).toList();

    return glucoseEntries;
  }
}
