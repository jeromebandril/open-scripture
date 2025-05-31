import 'package:equatable/equatable.dart';

class EBible extends Equatable {
  final String bibleName;
  final String abbreviation;
  final String? langEngName;
  final String? langNativeName;
  final String? langAbbreviation;

  const EBible({
    required this.bibleName,
    required this.abbreviation,
    this.langEngName,
    this.langNativeName,
    this.langAbbreviation,
  });

  @override
  List<Object?> get props => [
        bibleName,
        abbreviation,
        langEngName,
        langNativeName,
        langAbbreviation,
      ];
}
