import 'package:rootshealth_test/layers/domain/domain.dart';

abstract class GlucoseRepository {
  Future<List<GlucoseRecord>> readGlucoseValues();
}
