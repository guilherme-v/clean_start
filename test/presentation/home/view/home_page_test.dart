import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rootshealth_test/app/injection/injector.dart';
import 'package:rootshealth_test/layers/domain/domain.dart';
import 'package:rootshealth_test/layers/presentation/presentation.dart';

import '../../../helpers/helpers.dart';

class MockHomeCubit extends MockCubit<HomeState> implements HomeCubit {}

void main() {
  final glucoseRecords = List.generate(
    3,
    (index) => GlucoseRecord(
      recordedAt: DateTime.now(),
      value: 10 * index,
    ),
  );

  setUpAll(initializeServiceLocator);

  group('HomePage', () {
    testWidgets('renders HomePage', (tester) async {
      await tester.pumpApp(const HomePage());
      expect(find.byType(HomePage), findsOneWidget);
    });
  });

  group('HomeView', () {
    late HomeCubit mockCubit;

    setUpAll(() {
      registerFallbackValue<HomeState>(HomeState());
      mockCubit = MockHomeCubit();
    });

    testWidgets('It should render Initial State', (tester) async {
      const key = Key('homeView_initial_sizedBox');

      final state = HomeState();
      when(() => mockCubit.state).thenReturn(state);

      await tester.pumpApp(
        BlocProvider.value(
          value: mockCubit,
          child: const HomeView(),
        ),
      );

      expect(find.byKey(key), findsOneWidget);
    });

    testWidgets('It should render Loading State', (tester) async {
      const key = Key('homeView_loading_indicator');

      final state = HomeState(status: HomeStatus.loading);
      when(() => mockCubit.state).thenReturn(state);

      await tester.pumpApp(
        BlocProvider.value(
          value: mockCubit,
          child: const HomeView(),
        ),
      );

      expect(find.byKey(key), findsOneWidget);
    });

    testWidgets('It should render Failure State', (tester) async {
      const key = Key('homeView_failure_text');

      final state = HomeState(status: HomeStatus.failure);
      when(() => mockCubit.state).thenReturn(state);

      await tester.pumpApp(
        BlocProvider.value(
          value: mockCubit,
          child: const HomeView(),
        ),
      );

      expect(find.byKey(key), findsOneWidget);
    });

    testWidgets('It should render success State', (tester) async {
      const key = Key('homeView_success');

      final state = HomeState(
        status: HomeStatus.success,
        glucoseRecords: glucoseRecords,
        dailyResumes: DailyResume.generateDailyResumes(
          glucoseList: glucoseRecords,
          spikesAnalyzerAlgorithm: (_) => 1,
          healthPercentageAlgorithm: (_) => 1,
        ),
      );

      when(() => mockCubit.state).thenReturn(state);

      await tester.pumpApp(
        BlocProvider.value(
          value: mockCubit,
          child: const HomeView(),
        ),
      );

      expect(find.byKey(key), findsOneWidget);
      expect(find.byType(Card), findsNWidgets(glucoseRecords.length));
    });

    testWidgets('It should navigates to GraphPage when FAB is tapped',
        (tester) async {
      final state = HomeState(
        status: HomeStatus.success,
        glucoseRecords: glucoseRecords,
        dailyResumes: DailyResume.generateDailyResumes(
          glucoseList: glucoseRecords,
          spikesAnalyzerAlgorithm: (_) => 1,
          healthPercentageAlgorithm: (_) => 1,
        ),
      );
      when(() => mockCubit.state).thenReturn(state);

      final navigator = MockNavigator();
      when(() => navigator.push(any())).thenAnswer((_) async {});

      await tester.pumpApp(
        MockNavigatorProvider(
          navigator: navigator,
          child: const HomePage(),
        ),
      );

      await tester.tap(find.byType(FloatingActionButton));

      verify(
        () => navigator.push(any(that: isRoute<void>(named: '/graph'))),
      ).called(1);
    });
  });
}
