part of 'font_loader_cubit.dart';

enum FontLoaderStatus {
  initial,
  loading,
  loaded,
  error,
}

class FontLoaderState extends Equatable {
  const FontLoaderState({
    this.errorMessage,
    this.status = FontLoaderStatus.initial,
  });

  final String? errorMessage;
  final FontLoaderStatus status;

  FontLoaderState copyWith({
    String? errorMessage,
    FontLoaderStatus? status,
  }) {
    return FontLoaderState(
      errorMessage: errorMessage ?? this.errorMessage,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [errorMessage, status];
}
