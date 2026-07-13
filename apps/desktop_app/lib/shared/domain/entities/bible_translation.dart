import 'package:equatable/equatable.dart';
import 'bible_id.dart';

/// Represents the metadata for a specific Bible translation (e.g., KJV, RVR60).
/// Use [extId] is the unique id
class BibleTranslation extends Equatable {
  // Nullable because API/Sword items might not be saved in local SQLite yet
  final int? localId;

  /// The unique code name across all engines (e.g., "KJV", "RSV")
  final BibleId extId;
  final String name;
  final String? localName;
  final String abbreviation;
  final String? langIsoCode;
  final String? langEngName;
  final String? langNativeName;
  final String? originSource;
  final String? originFormat;
  final String? description;
  final String? copyright;

  // UI state: true if this translation exists in the local database
  final bool isAlreadyInstalled;

  const BibleTranslation({
    this.localId,
    required this.extId,
    required this.name,
    this.localName,
    required this.abbreviation,
    this.langIsoCode,
    this.langEngName,
    this.langNativeName,
    this.originSource,
    this.originFormat,
    this.description,
    this.copyright,
    this.isAlreadyInstalled = false,
  });

  BibleTranslation copyWith({
    int? localId,
    BibleId? extId,
    String? name,
    String? localName,
    String? abbreviation,
    String? langIsoCode,
    String? langEngName,
    String? langNativeName,
    String? originSource,
    String? originFormat,
    String? description,
    String? copyright,
    bool? isAlreadyInstalled,
  }) {
    return BibleTranslation(
      localId: localId ?? this.localId,
      extId: extId ?? this.extId,
      name: name ?? this.name,
      localName: localName ?? this.localName,
      abbreviation: abbreviation ?? this.abbreviation,
      langIsoCode: langIsoCode ?? this.langIsoCode,
      langEngName: langEngName ?? this.langEngName,
      langNativeName: langNativeName ?? this.langNativeName,
      originSource: originSource ?? this.originSource,
      originFormat: originFormat ?? this.originFormat,
      description: description ?? this.description,
      copyright: copyright ?? this.copyright,
      isAlreadyInstalled: isAlreadyInstalled ?? this.isAlreadyInstalled,
    );
  }

  @override
  List<Object?> get props => [
        localId,
        extId,
        name,
        localName,
        abbreviation,
        langIsoCode,
        langEngName,
        langNativeName,
        originSource,
        originFormat,
        description,
        copyright,
        isAlreadyInstalled,
      ];
}
