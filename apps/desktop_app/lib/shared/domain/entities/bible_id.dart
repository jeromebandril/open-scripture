import 'package:equatable/equatable.dart';
import '../../enums/bible_repository_type.dart';

class BibleId extends Equatable {
  const BibleId({required this.repoType, required this.externalId});

  final BibleRepositoryType repoType;
  final String externalId;

  String get key => '${repoType.name}::$externalId';

  factory BibleId.fromKey(String key) {
    final parts = key.split('::');
    return BibleId(
      repoType: BibleRepositoryType.values.byName(parts[0]),
      externalId: parts[1],
    );
  }

  @override
  String toString() => key;

  @override
  List<Object?> get props => [repoType, externalId];
}
