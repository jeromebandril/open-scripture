import 'translation_download_progress/translation_download_progress_bloc.dart';
import 'installed_translations_overview/installed_translations_bloc.dart';
import 'translations_overview/translations_bloc.dart';

class TranslationManagerBloc {
  TranslationManagerBloc({
    required this.allTranslationsBloc,
    required this.installedTranslationsBloc,
    required this.translationBloc,
  }) {}

  final AllTranslationsBloc allTranslationsBloc;
  final InstalledTranslationsBloc installedTranslationsBloc;
  final TranslationDownloadProgressBloc translationBloc;
}
