import 'package:equatable/equatable.dart';

class BibleModel extends Equatable {
  final int? id;
  final int languageId;
  final String bibleName;
  final String abbreviation;

  const BibleModel({
    this.id,
    required this.languageId,
    required this.bibleName,
    required this.abbreviation,
  });

  @override
  List<Object?> get props => [id, languageId, bibleName, abbreviation];
}
