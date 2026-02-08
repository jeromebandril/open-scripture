import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_scripture/shared/utils/osis_parser.dart';

part 'bible_importer_state.dart';

class BibleImporterCubit extends Cubit<BibleImporterState> {
  BibleImporterCubit() : super(BibleImporterInitial());

  void pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xml'],
      withData: true,
    );

    if (result == null) return; // user canceled

    final file = result.files.single;
    final bytes = file.bytes;
    final name = file.name;

    if (bytes == null) return;

    final content = utf8.decode(bytes);

    OsisParser(content);
  }
}
