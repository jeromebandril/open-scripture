import '../../domain/entities/bible_view_colorscheme.dart';
import '../../domain/repositories/colorschemes_repository.dart';
import '../datasource/colorscheme_datasource.dart';

class ColorschemeRepositoryImpl implements ColorschemeRepository {
  final ColorschemeDatasource _datasource;

  const ColorschemeRepositoryImpl({required ColorschemeDatasource datasource})
      : _datasource = datasource;

  @override
  Future<void> delete(String name) async {
    await _datasource.delete(name);
  }

  @override
  Future<List<BibleViewColorscheme>> loadCustom() async {
    return await _datasource.load();
  }

  @override
  Future<void> save(BibleViewColorscheme scheme) async {
    await _datasource.save(scheme);
  }
}
