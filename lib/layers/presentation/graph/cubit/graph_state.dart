part of 'graph_cubit.dart';

class GraphState with EquatableMixin {
  const GraphState({
    required this.glucoseList,
  });

  final List<GlucoseRecord> glucoseList;

  @override
  List<Object?> get props => [glucoseList];
}
