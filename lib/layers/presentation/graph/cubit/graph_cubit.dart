import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rootshealth_test/layers/domain/domain.dart';

part 'graph_state.dart';

class GraphCubit extends Cubit<GraphState> {
  GraphCubit({
    required List<GlucoseRecord> glucoseList,
  }) : super(GraphState(glucoseList: glucoseList));
}
