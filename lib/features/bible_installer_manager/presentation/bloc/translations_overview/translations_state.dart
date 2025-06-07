part of 'translations_bloc.dart';

enum AllTranslationsStatus {
  initial,
  loading,
  loaded,
  error,
}

class AllTranslationsState extends Equatable {
  const AllTranslationsState({
    this.status = AllTranslationsStatus.initial,
    this.bibles = const [],
    this.errorMessage,
  });

  final AllTranslationsStatus status;
  final List<EBible> bibles;
  final String? errorMessage;

  AllTranslationsState copyWith({
    AllTranslationsStatus Function()? status,
    List<EBible> Function()? translationInfos,
    String Function()? errorMessage,
  }) {
    return AllTranslationsState(
      status: status != null ? status() : this.status,
      bibles: translationInfos != null ? translationInfos() : this.bibles,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }

  @override
  List<Object> get props => [status, bibles];
}
