import 'package:fpdart/fpdart.dart';
import 'package:the_smyrna_bible_v2/core/data/datasources/bible_sqllite_datasource.dart';
import 'package:the_smyrna_bible_v2/core/domain/entities/bible_meta.dart';
import 'package:the_smyrna_bible_v2/features/bible_display/bible_selector/domain/repositories/bible_selector_repository.dart';

import '../../../../../core/error/failure.dart';

class BibleSelectorRepositoryImpl implements BibleSelectorRepository {
  final BibleLocalDataSource localDatasource;

  const BibleSelectorRepositoryImpl({required this.localDatasource});

  @override
  Future<Either<Failure, List<BibleMeta>>> getInstalledBibles() async {
    const mockBibles = <BibleMeta>[
      BibleMeta(
        id: 1,
        extId: 'KJV',
        bibleName: 'King James Version',
        abbreviation: 'KJV',
        langEngName: 'English',
        langNativeName: 'English',
        langIsoCode: 'en',
        originSource: 'public-domain',
      ),
      BibleMeta(
        id: 2,
        extId: 'NIV',
        bibleName: 'New International Version',
        abbreviation: 'NIV',
        langEngName: 'English',
        langNativeName: 'English',
        langIsoCode: 'en',
        originSource: 'copyright',
      ),
      BibleMeta(
        id: 3,
        extId: 'ESV',
        bibleName: 'English Standard Version',
        abbreviation: 'ESV',
        langEngName: 'English',
        langNativeName: 'English',
        langIsoCode: 'en',
        originSource: 'copyright',
      ),
      BibleMeta(
        id: 4,
        extId: 'NASB',
        bibleName: 'New American Standard Bible',
        abbreviation: 'NASB',
        langEngName: 'English',
        langNativeName: 'English',
        langIsoCode: 'en',
        originSource: 'copyright',
      ),
      BibleMeta(
        id: 5,
        extId: 'RVR60',
        bibleName: 'Reina-Valera 1960',
        abbreviation: 'RVR60',
        langEngName: 'Spanish',
        langNativeName: 'Español',
        langIsoCode: 'es',
        originSource: 'public-domain',
      ),
      BibleMeta(
        id: 6,
        extId: 'LSG',
        bibleName: 'La Bible Louis Segond',
        abbreviation: 'LSG',
        langEngName: 'French',
        langNativeName: 'Français',
        langIsoCode: 'fr',
        originSource: 'public-domain',
      ),
      BibleMeta(
        id: 7,
        extId: 'LUT',
        bibleName: 'Lutherbibel 1912',
        abbreviation: 'LUT',
        langEngName: 'German',
        langNativeName: 'Deutsch',
        langIsoCode: 'de',
        originSource: 'public-domain',
      ),
      BibleMeta(
        id: 8,
        extId: 'LUT',
        bibleName: 'Nuova Riveduta 2006',
        abbreviation: 'NR06',
        langEngName: 'Italian',
        langNativeName: 'Italiano',
        langIsoCode: 'it',
        originSource: 'copyright',
      ),
      BibleMeta(
        id: 9,
        extId: 'ARA',
        bibleName: 'Almeida Revista e Atualizada',
        abbreviation: 'ARA',
        langEngName: 'Portuguese',
        langNativeName: 'Português',
        langIsoCode: 'pt',
        originSource: 'public-domain',
      ),
      BibleMeta(
        id: 10,
        extId: 'RST',
        bibleName: 'Russian Synodal Translation',
        abbreviation: 'RST',
        langEngName: 'Russian',
        langNativeName: 'Русский',
        langIsoCode: 'ru',
        originSource: 'public-domain',
      ),
      BibleMeta(
        id: 11,
        extId: 'BT',
        bibleName: 'Biblia Tysiąclecia',
        abbreviation: 'BT',
        langEngName: 'Polish',
        langNativeName: 'Polski',
        langIsoCode: 'pl',
        originSource: 'copyright',
      ),
      BibleMeta(
        id: 12,
        extId: 'CUV',
        bibleName: 'Chinese Union Version',
        abbreviation: 'CUV',
        langEngName: 'Chinese',
        langNativeName: '中文',
        langIsoCode: 'zh',
        originSource: 'public-domain',
      ),
    ];

    return Right(await localDatasource.getInstalledBibles());
  }
}
