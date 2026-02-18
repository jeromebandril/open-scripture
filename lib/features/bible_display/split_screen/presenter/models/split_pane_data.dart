import 'package:equatable/equatable.dart';

import '../../../../../shared/domain/entities/bible_ref.dart';

class PaneDescriptor extends Equatable {
  const PaneDescriptor({
    required this.id,
    this.ref,
    this.bibleId,
  });

  final int id;
  final BibleRef? ref;
  final int? bibleId;

  @override
  List<Object?> get props => [id, ref, bibleId];
}
