import 'package:flutter_test/flutter_test.dart';
import 'package:rootshealth_test/app/app.dart';
import 'package:rootshealth_test/app/injection/injector.dart';
import 'package:rootshealth_test/layers/presentation/presentation.dart';

void main() {
  group('App', () {
    setUpAll(initializeServiceLocator);

    testWidgets('It should renders HomePage when opening', (tester) async {
      await tester.pumpWidget(const App());
      expect(find.byType(HomePage), findsOneWidget);
    });
  });
}
