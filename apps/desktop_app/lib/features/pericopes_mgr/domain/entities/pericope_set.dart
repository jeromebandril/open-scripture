import 'package:equatable/equatable.dart';

class PericopeSet extends Equatable {
  final String? name;
  final String extId;

  /// A list of language iso-codes
  /// example: ['it', 'en']
  final List<String> assignedTo;
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
