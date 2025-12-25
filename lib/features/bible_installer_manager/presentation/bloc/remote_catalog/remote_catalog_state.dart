part of 'remote_catalog_bloc.dart';

enum RemoteCatalogStatus {
  initial,
  loading,
  loaded,
  error,
}

class RemoteCatalogState extends Equatable {
  const RemoteCatalogState({
    this.status = RemoteCatalogStatus.initial,
    this.bibles = const [],
    this.errorMessage,
  });

  final RemoteCatalogStatus status;
  final List<BibleMeta> bibles;
  final String? errorMessage;

  RemoteCatalogState copyWith({
    RemoteCatalogStatus Function()? status,
    List<BibleMeta> Function()? bibles,
    String Function()? errorMessage,
  }) {
    return RemoteCatalogState(
      status: status != null ? status() : this.status,
      bibles: bibles != null ? bibles() : this.bibles,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }

  @override
  List<Object> get props => [status, bibles];
}
