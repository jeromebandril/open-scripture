import 'package:equatable/equatable.dart';

import '../../../../shared/domain/entities/bible_id.dart';

class PericopeSet extends Equatable {
  final String? name;
  final String extId;

  /// A list of BibleId
  /// example: ['it', 'en']
  final List<BibleId> assignedTo;
  final int versionNumber;
  final String? langIsoCode;
  final String? attribution;

  const PericopeSet({
    this.name,
    required this.extId,
    required this.versionNumber,
    this.assignedTo = const [],
    this.langIsoCode,
    this.attribution,
  });

  PericopeSet copyWith({List<BibleId>? assignedTo}) {
    return PericopeSet(
      name: name,
      extId: extId,
      versionNumber: versionNumber,
      assignedTo: assignedTo ?? this.assignedTo,
      langIsoCode: langIsoCode,
      attribution: attribution,
    );
  }

  @override
  List<Object?> get props => [
        name,
        extId,
        versionNumber,
        assignedTo,
        langIsoCode,
        attribution,
      ];
}
