import 'package:equatable/equatable.dart';
import 'package:open_scripture/shared/domain/entities/bible_ref.dart';

class HistoryEntry extends Equatable {
  final BibleRef ref;
  final DateTime time;

  const HistoryEntry({required this.ref, required this.time});

  @override
  List<Object?> get props => [ref, time];
}
