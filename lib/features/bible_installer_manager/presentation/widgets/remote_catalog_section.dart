import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_scripture/features/settings_window/presentation/widgets/setting_section.dart';

import '../../../../shared/domain/entities/bible_meta.dart';
import '../../../../shared/presentation/widgets/hoverable_container.dart';
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
class RemoteCatalogSection extends StatefulWidget {
  const RemoteCatalogSection({super.key});

  @override
  State<RemoteCatalogSection> createState() => _RemoteCatalogSectionState();
}

class _RemoteCatalogSectionState extends State<RemoteCatalogSection> {
  String? filter;

  @override
  Widget build(BuildContext context) {
    final installedIds = context
        .select(
          (InstalledBiblesBloc b) => b.state.installedBibles.map(
            (e) => e.extId,
          ),
        )
        .toList();

    return BlocBuilder<RemoteCatalogBloc, RemoteCatalogState>(
      builder: (context, state) {
        late List<BibleMeta> bib;

        if (filter != null) {
          bib = state.bibles.where((b) {
            return b.bibleName.toLowerCase().contains(filter!) ||
                b.bibleNameLocal.toLowerCase().contains(filter!) ||
                (b.langEngName != null &&
                    b.langEngName!.toLowerCase().contains(filter!));
          }).toList();
        } else {
          bib = state.bibles;
        }

        // Set which bible is already installed
        final bibles = bib.map((b) => b.copyWith(
              isAlreadyInstalled: installedIds.contains(b.extId),
            ));
        // Group bibles by langauge
        final groups = groupBy<BibleMeta, String>(
          bibles,
          (info) => info.langEngName ?? '',
        );
        // Get the list of laguage
        final keys = groups.keys.toList()..sort();
        // Group the language alphabetically

        return SettingListSection(
          title: 'Repository  ( ${state.bibles.length} )',
          onFilter: (val) {
            setState(() {
              filter = val.isEmpty ? null : val.toLowerCase();
            });
          },
          isLoading: state.status == RemoteCatalogStatus.loading,
          isError: state.status == RemoteCatalogStatus.error,
          emptyListPlaceholder: Text('Empty'),
          errorPlaceholder: Text(state.errorMessage ?? 'Error'),
          itemCount: groups.values.length,
          separatorBuilder: (_, __) => Divider(
            height: 1,
          ),
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
