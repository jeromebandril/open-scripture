import 'package:the_smyrna_bible_v2/features/translations_installer_manager/presentation/bloc/single_translation_download/single_translation_download_bloc.dart';

import 'all_translations_overview/all_translations_bloc.dart';
import 'installed_translations_overview/installed_translations_bloc.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Error';
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
  final SingleTranslationDownloadBloc translationBloc;
}
