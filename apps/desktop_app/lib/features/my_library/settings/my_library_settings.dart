import 'package:equatable/equatable.dart';

import '../../../shared/domain/entities/bible_id.dart';

class MyLibrarySettings extends Equatable {
  final BibleId? preferredBibleId;

  const MyLibrarySettings({this.preferredBibleId});

  MyLibrarySettings copyWith({
    BibleId? Function()? preferredBibleId,
  }) {
    return MyLibrarySettings(
      preferredBibleId:
          preferredBibleId != null ? preferredBibleId() : this.preferredBibleId,
    );
  }

  factory MyLibrarySettings.fromJson(Map<String, dynamic> json) {
    return MyLibrarySettings(
        preferredBibleId: json['preferredBibleId'] != null
            ? BibleId.fromKey(json['preferredBibleId'])
            : null);
  }

  Map<String, dynamic> toJson() {
    return {
      'preferredBibleId': preferredBibleId?.key,
    };
  }

  @override
  List<Object?> get props => [preferredBibleId];
}
