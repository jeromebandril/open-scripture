import 'package:equatable/equatable.dart';

import '../../../../shared/domain/entities/bible_ref.dart';

class HistoryData extends Equatable {
  final BibleRef ref;
  final DateTime time;

  const HistoryData({required this.ref, required this.time});

  @override
  List<Object?> get props => [ref, time];
}
