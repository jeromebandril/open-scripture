import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../../core/domain/entities/bible_meta.dart';
import '../../../../../core/presentation/widgets/hoverable_container.dart';
import '../../../../../core/presentation/widgets/section_header.dart';
import '../../bloc/installed_bibles/installed_bibles_bloc.dart';

part 'installed_bibles_row.dart';

class InstalledBiblesSection extends StatelessWidget {
  const InstalledBiblesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.black26),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          const SectionHeader('INSTALLED'),
          Expanded(
            child: BlocBuilder<InstalledBiblesBloc, InstalledBiblesState>(
              builder: (context, state) {
                switch (state.status) {
                  case InstalledBiblesStatus.loading:
                    return const Center(child: CircularProgressIndicator());
                  case InstalledBiblesStatus.loaded:
                    return ListView.builder(
                      itemCount: state.installedBibles.length,
                      itemBuilder: (_, index) {
                        return _InstalledBiblesRow(
                          bibleMeta: state.installedBibles[index],
                        );
                      },
                    );

                  default:
                    return Text(state.toString());
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
