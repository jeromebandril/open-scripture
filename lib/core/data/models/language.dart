import 'package:equatable/equatable.dart';

class LanguageModel extends Equatable {
  final int? id;
  final String langEngName;
  final String? langNativeName;
  final String abbreviation; // ISO 639

  const LanguageModel({
    this.id,
    required this.langEngName,
    this.langNativeName,
    required this.abbreviation,
  });

  @override
  List<Object?> get props => [id, langEngName, langNativeName, abbreviation];
}
