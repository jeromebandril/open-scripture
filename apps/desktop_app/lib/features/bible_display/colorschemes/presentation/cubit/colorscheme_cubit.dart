import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/bible_view_colorscheme.dart';
import '../../domain/entities/colorscheme_presets.dart';
import '../../domain/repositories/colorschemes_repository.dart';

part 'colorscheme_state.dart';

class ColorschemesCubit extends Cubit<ColorschemesState> {
  ColorschemesCubit({required ColorschemeRepository repo})
      : _repo = repo,
        super(ColorschemesState());

  final ColorschemeRepository _repo;

  Future<void> load() async {
    final custom = await _repo.loadCustom();
    emit(ColorschemesState(custom: custom, isLoaded: true));
  }

  /// Creates or updates a custom colorscheme (matched by name).
  Future<void> save(BibleViewColorscheme scheme) async {
    assert(scheme.isCustom, 'Presets are read-only. Fork them first.');
    await _repo.save(scheme);

    final custom = [...state.custom];
    final index = custom.indexWhere((s) => s.name == scheme.name);
    if (index >= 0) {
      custom[index] = scheme;
    } else {
      custom.add(scheme);
    }
    emit(ColorschemesState(custom: custom, isLoaded: true));
  }

  Future<void> delete(String name) async {
    await _repo.delete(name);
    emit(ColorschemesState(
      custom: state.custom.where((s) => s.name != name).toList(),
      isLoaded: true,
    ));
  }
}
