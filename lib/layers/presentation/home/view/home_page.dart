import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:rootshealth_test/app/injection/injector.dart';
import 'package:rootshealth_test/app/l10n/l10n.dart';
import 'package:rootshealth_test/extensions/datetime_extensions.dart';
import 'package:rootshealth_test/layers/domain/domain.dart';
import 'package:rootshealth_test/layers/presentation/presentation.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<HomeCubit>()..loadGlucoseList(),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.homeAppBarTitle),
        actions: [
          PopupMenuButton<SortOrder>(
            onSelected: (SortOrder result) {
              context.read<HomeCubit>().sortBy(result);
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<SortOrder>>[
              const PopupMenuItem<SortOrder>(
                value: SortOrder.ascending,
                child: Text('ascending'),
              ),
              const PopupMenuItem<SortOrder>(
                value: SortOrder.descending,
                child: Text('descending'),
              ),
            ],
          )
        ],
      ),
      body: const Center(child: _Content()),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final list = context.read<HomeCubit>().state.glucoseRecords;
          Navigator.of(context).push(GraphPage.route(list: list));
        },
        child: const Icon(Icons.bar_chart),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = context.select((HomeCubit cubit) => cubit.state.status);

    switch (state) {
      case HomeStatus.initial:
        return const SizedBox(
          key: Key('homeView_initial_sizedBox'),
        );
      case HomeStatus.loading:
        return const Center(
          key: Key('homeView_loading_indicator'),
          child: CircularProgressIndicator.adaptive(),
        );
      case HomeStatus.failure:
        return Center(
          key: const Key('homeView_failure_text'),
          child: Text(l10n.homeLoadErrorMessage),
        );
      case HomeStatus.success:
        return const _GlucoseListGrouped(
          key: Key('homeView_success'),
        );
    }
  }
}

class _GlucoseListGrouped extends StatelessWidget {
  const _GlucoseListGrouped({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext ctx) {
    final list = ctx.select((HomeCubit cubit) => cubit.state.glucoseRecords);
    final order = ctx.select((HomeCubit cubit) => cubit.state.sortOrder);
    final drs = ctx.select((HomeCubit cubit) => cubit.state.dailyResumes);

    final theme = Theme.of(ctx);
    final locale = Localizations.localeOf(ctx).languageCode;
    final dateFormatYMED = DateFormat.yMEd(locale);
    final dateFormatJM = DateFormat.jm(locale);

    return GroupedListView<GlucoseRecord, DateTime>(
      elements: list,
      groupBy: (GlucoseRecord e) => e.recordedAt.dateOnly,
      itemComparator: (a, b) => a.recordedAt.compareTo(b.recordedAt),
      groupHeaderBuilder: (GlucoseRecord e) {
        final dailyResume = drs[e.recordedAt.dateOnly];
        return Container(
          color: theme.secondaryHeaderColor,
          child: ListTile(
            contentPadding: const EdgeInsets.all(4),
            minVerticalPadding: 10,
            leading: const Icon(Icons.stacked_bar_chart, size: 36),
            title: Text(dateFormatYMED.format(e.recordedAt)),
            subtitle: Text(
              'Healthy values:'
              ' ${dailyResume?.percentageOfHealthyValues}%, '
              'Spikes: ${dailyResume?.numberOfSpikes}',
            ),
          ),
        );
      },
      itemBuilder: (context, GlucoseRecord e) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Card(
            child: ListTile(
              leading: CircleAvatar(
                radius: 24,
                backgroundColor:
                    e.value < 100 ? Colors.green : Colors.redAccent,
                child: Text(
                  '${e.value}',
                  style: theme.textTheme.headline5!.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
              title: Text(dateFormatJM.format(e.recordedAt)),
              subtitle: Text(
                'Glucose level: ${e.value < 100 ? 'Good' : 'Bad'}',
              ),
            ),
          ),
        );
      },
      useStickyGroupSeparators: true,
      order: order.isDescending ? GroupedListOrder.DESC : GroupedListOrder.ASC,
    );
  }
}
