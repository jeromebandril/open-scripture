import 'package:equatable/equatable.dart';

import '../../../translations_installer_manager/domain/entities/translation.dart';

class TranslationViewer extends Equatable {
  final List<Translation> translations;

  const TranslationViewer({
    this.translations = const [],
  });

  @override
  List<Object?> get props => [translations];
}
