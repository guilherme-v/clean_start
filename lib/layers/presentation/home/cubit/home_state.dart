import 'package:equatable/equatable.dart';
import 'package:rootshealth_test/layers/domain/domain.dart';
import 'package:rootshealth_test/layers/presentation/home/cubit/models/daily_resume.dart';

// ignore_for_file: lines_longer_than_80_chars

enum HomeStatus { initial, loading, success, failure }

enum SortOrder { ascending, descending }

extension SortOrderExtension on SortOrder {
  bool get isAscending => this == SortOrder.ascending;
  bool get isDescending => this == SortOrder.descending;
}

class HomeState with EquatableMixin {
  HomeState({
    this.status = HomeStatus.initial,
    this.sortOrder = SortOrder.descending,
    this.glucoseRecords = const [],
    this.dailyResumes = const {},
  });

  final HomeStatus status;
  final SortOrder sortOrder;
  final List<GlucoseRecord> glucoseRecords;
  final Map<DateTime, DailyResume> dailyResumes;

  @override
  String toString() {
    return 'status: $status, glucoseListSize:${glucoseRecords.length}, sortOrder:$sortOrder';
  }

  @override
  List<Object?> get props => [status, sortOrder, glucoseRecords];
}

// We Could also have used custom factories and CopyWith(..) method
