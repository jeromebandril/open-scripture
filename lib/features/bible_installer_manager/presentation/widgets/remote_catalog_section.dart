import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_smyrna_bible_v2/features/settings_window/presentation/widgets/setting_section.dart';

import '../../../../core/domain/entities/bible_meta.dart';
import '../../../../core/presentation/widgets/hoverable_container.dart';
import '../../domain/entities/bible_download_progress.dart';
import '../bloc/download_manager/bloc/download_manager_bloc.dart';
import '../bloc/installed_bibles/installed_bibles_bloc.dart';
import '../bloc/remote_catalog/remote_catalog_bloc.dart';

part 'parts/group_list.dart';
part 'remote_catalog_row.dart';

/*
  All translation overview will have a first layer of filtering
  with an expandable sections based on language (es: italian, english, and 
  each section will reaveal all the bible in that language) using [ExpandableTile]
*/
class RemoteCatalogSection extends StatelessWidget {
  const RemoteCatalogSection({super.key});

  @override
  Widget build(BuildContext context) {
    final installedIds = context.select(
      (InstalledBiblesBloc b) => b.state.installedBibles, // ideally Set<String>
    );

    return BlocBuilder<RemoteCatalogBloc, RemoteCatalogState>(
      builder: (context, state) {
        //  (group by language)
        final bibles = state.bibles.map((b) => b.copyWith(
              isAlreadyInstalled: installedIds.contains(b),
            ));
        final groups = groupBy<BibleMeta, String>(
          bibles,
          (info) => info.langEngName ?? '',
        );
        final keys = groups.keys.toList()..sort();

        return SettingListSection(
          title: 'Available Bibles',
          isLoading: state.status == RemoteCatalogStatus.loading,
          isError: state.status == RemoteCatalogStatus.error,
          emptyListPlaceholder: Text('Empty'),
          errorPlaceholder: Text(state.errorMessage ?? 'Error'),
          itemCount: groups.values.length,
          //separatorBuilder: (_, __) => Divider(),
          itemBuilder: (_, index) {
            final String key = keys.elementAt(index);

            return _GroupList(
              title: "$key (${groups[key]!.length})",
              bibles: groups[key]!,
            );
          },
        );
      },
    );
  }
}
