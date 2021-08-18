import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:rootshealth_test/app/l10n/l10n.dart';
import 'package:rootshealth_test/layers/domain/domain.dart';
import 'package:rootshealth_test/layers/presentation/graph/graph.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class GraphPage extends StatelessWidget {
  const GraphPage({Key? key}) : super(key: key);

  static Route<void> route({required List<GlucoseRecord> list}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: '/graph'),
      builder: (_) => BlocProvider(
        create: (_) => GraphCubit(glucoseList: list),
        child: const GraphPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => const _GraphView();
}

class _GraphView extends StatelessWidget {
  const _GraphView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.homeAppBarTitle),
      ),
      body: const Center(child: _Content()),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final list = context.select((GraphCubit cubit) => cubit.state.glucoseList);
    final l10n = context.l10n;

    return SfCartesianChart(
      tooltipBehavior: TooltipBehavior(enable: true),
      title: ChartTitle(text: l10n.homeAppBarTitle),
      zoomPanBehavior: ZoomPanBehavior(
        enablePanning: true,
        enableDoubleTapZooming: true,
        enablePinching: true,
      ),
      primaryYAxis: NumericAxis(labelFormat: '{value} mg'),
      primaryXAxis: DateTimeAxis(
        visibleMinimum: list[0].recordedAt,
        visibleMaximum: list[7].recordedAt,
        intervalType: DateTimeIntervalType.minutes,
        dateFormat: DateFormat.Md().add_jm(),
      ),
      series: <ChartSeries>[
        LineSeries<GlucoseRecord, DateTime>(
          name: l10n.homeAppBarTitle,
          dataSource: list,
          xValueMapper: (GlucoseRecord entry, _) => entry.recordedAt,
          yValueMapper: (GlucoseRecord entry, _) => entry.value,
          dataLabelSettings: const DataLabelSettings(isVisible: true),
          markerSettings: const MarkerSettings(isVisible: true),
        )
      ],
    );
  }
}
