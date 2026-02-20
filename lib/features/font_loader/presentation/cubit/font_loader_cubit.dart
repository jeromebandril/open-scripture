import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

part 'font_loader_state.dart';

class FontLoaderCubit extends Cubit<FontLoaderState> {
  FontLoaderCubit() : super(FontLoaderState());

  Future<void> loadFontFromUrl(String url) async {
    if (url.isEmpty) {
      emit(state.copyWith(
        status: FontLoaderStatus.error,
        errorMessage: 'URL cannot be empty',
      ));
      return;
    }

    emit(state.copyWith(
      status: FontLoaderStatus.loading,
      errorMessage: null,
    ));
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final fontLoader = FontLoader('cf');
        fontLoader
            .addFont(Future.value(ByteData.sublistView(response.bodyBytes)));

        await fontLoader.load();

        emit(state.copyWith(
          status: FontLoaderStatus.loaded,
          errorMessage: null,
        ));
      } else {
        emit(state.copyWith(
          status: FontLoaderStatus.error,
          errorMessage: 'Failed to load font: ${response.statusCode}',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: FontLoaderStatus.error,
        errorMessage: 'Error loading font: $e',
      ));
    }
  }
}
