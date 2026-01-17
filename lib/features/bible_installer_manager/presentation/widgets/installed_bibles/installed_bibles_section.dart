import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:the_smyrna_bible_v2/features/settings_window/presentation/widgets/components/setting_section.dart';

import '../../../../../core/domain/entities/bible_meta.dart';
import '../../../../../core/presentation/widgets/hoverable_container.dart';
import '../../bloc/installed_bibles/installed_bibles_bloc.dart';

part 'installed_bibles_row.dart';

class InstalledBiblesSection extends StatelessWidget {
  const InstalledBiblesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InstalledBiblesBloc, InstalledBiblesState>(
      builder: (context, state) {
        return SettingListSection(
          title: 'Installed bibles',
          isLoading: state.status == InstalledBiblesStatus.loading,
          isError: state.status == InstalledBiblesStatus.error,
          emptyListPlaceholder: Text('No Installed bibles yet'),
          errorPlaceholder: Text('Error'),
          itemCount: state.installedBibles.length,
          //separatorBuilder: (_, __) => Divider(),
          itemBuilder: (_, index) {
            return _InstalledBiblesRow(
              bibleMeta: state.installedBibles[index],
            );
          },
        );
      },
    );
  }
}
