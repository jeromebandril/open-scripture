import 'package:flutter/widgets.dart';
import 'package:the_smyrna_bible_v2/features/customizer/domain/entities/searchbar_position.dart';

extension SearchbarPositionFlutter on SearchbarPosition {
  MainAxisAlignment toFlutter() {
    switch (this) {
      case SearchbarPosition.left:
        return MainAxisAlignment.start;
      case SearchbarPosition.center:
        return MainAxisAlignment.center;
    }
  }
}
