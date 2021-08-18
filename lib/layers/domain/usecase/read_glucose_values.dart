import 'package:rootshealth_test/layers/domain/domain.dart';

class ReadGlucoseValues {
  const ReadGlucoseValues({
    required this.repository,
  });

  final GlucoseRepository repository;

  Future<List<GlucoseRecord>> call() {
    return repository.readGlucoseValues();
  }
}
