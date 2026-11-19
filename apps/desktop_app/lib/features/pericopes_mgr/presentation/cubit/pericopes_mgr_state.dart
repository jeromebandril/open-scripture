part of 'pericopes_mgr_cubit.dart';

enum PericopesMgrStatus {
  initial,
  loading,
  error,
  success,
}

class PericopesMgrState extends Equatable {
  const PericopesMgrState({
    this.importStatus = PericopesMgrStatus.initial,
    this.listStatus = PericopesMgrStatus.initial,
    this.errorMessage,
    this.installedPericopes = const [],
  });

  final PericopesMgrStatus importStatus;
  final PericopesMgrStatus listStatus;
  final String? errorMessage;
  final List<PericopeSet> installedPericopes;

  PericopesMgrState copyWith({
    PericopesMgrStatus? importStatus,
    PericopesMgrStatus? listStatus,
    String? Function()? errorMessage,
    List<PericopeSet>? installedPericopes,
  }) {
    return PericopesMgrState(
      importStatus: importStatus ?? this.importStatus,
      listStatus: listStatus ?? this.listStatus,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
      installedPericopes: installedPericopes ?? this.installedPericopes,
    );
  }

  @override
  List<Object?> get props => [
        importStatus,
        listStatus,
        errorMessage,
        installedPericopes,
      ];
}
