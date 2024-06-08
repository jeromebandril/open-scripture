import 'translation_download_progress/translation_download_progress_bloc.dart';
import 'translations_overview/translations_bloc.dart';
import 'installed_translations_overview/installed_translations_bloc.dart';

const String SERVER_FAILURE_MESSAGE =
    'Oops something went wrong, check your connection';
const String NO_LOCAL_DATA_FAILURE_MESSAGE = 'No Local Data';
const String INSTALLATION_FAILURE_MESSAGE = 'Failed To Install';

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
