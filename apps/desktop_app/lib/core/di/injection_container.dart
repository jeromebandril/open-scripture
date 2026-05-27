import 'package:get_it/get_it.dart';
import 'package:open_scripture/core/di/init_common_features.dart';

import 'package:open_scripture/core/di/init_features_desktop.dart'
    if (dart.library.html) 'package:open_scripture/core/di/init_features_web.dart';

final sl = GetIt.instance;

/// Registers all dependencies in the correct order:
/// infrastructure -> app state -> features (leaves first, composites last).
Future<void> init() async {
  initCommonFeatures();

  initPlatformSpecificFeatures();
}

// Overview

// // 1. Database - no dependencies
// initDatabase();
// // 2. Installer engine - depends on database indirectly via datasources
// initInstaller();
// // 3. Core datasources - depend on database + installer
// initInfrastructure();
// // 4. Global app state & event buses - no feature dependencies
// initAppState();
// // 5. Features - registered leaves-first so composite features
// //   (shortcuts, remotecontroller) can safely resolve their deps.
// initMyLibraryFeature();
// initCustomizerFeature();
// initBibleInstallManagerFeature();
// initWindowStackFeature();
// initBSearchbarFeature();
// initBibleSelectorFeature();
// initReaderFeature();
// initBibleImporterFeature();
// initThreeTapNavFeature();
// initObsLiveOverlayFeature();
// initRemoteControllerFeature();
// initSplitScreenFeature();
// // Last - depends on PaneManagerCubit, BSearchbarBloc, and most app state
// initShortcutFeature();
