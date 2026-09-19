import '../../../../core/infrastructure/database/database.dart';
import '../../domain/entities/pericope_set.dart' as domain;

class PericopeSetDto {
  static domain.PericopeSet fromJson(PericopeSet row) {
    return domain.PericopeSet(
      extId: row.extId,
      langIsoCode: row.langIsoCode,
      versionCount: row.versionNumber,
      attribution: row.attribution,
    );
  }
}
