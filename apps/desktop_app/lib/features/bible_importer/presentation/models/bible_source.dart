import '../../../../shared/enums/bible_repository_type.dart';

class BibleSource {
  final String name;
  final String url;
  final String description;
  final BibleRepositoryType repoType;
  const BibleSource({
    required this.name,
    required this.url,
    required this.description,
    required this.repoType,
  });
}
