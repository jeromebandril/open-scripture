import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

class InterfaceVisibilityState extends Equatable {
  final bool isToolMenuVisible;
  final bool isHistoryVisible;
  final bool is3TapNavVisible;
  final bool isToolbarVisible;

  const InterfaceVisibilityState({
    this.isToolMenuVisible = false,
    this.isHistoryVisible = false,
    this.is3TapNavVisible = false,
    this.isToolbarVisible = true,
  });

  InterfaceVisibilityState copyWith({
    bool? isToolMenuVisible,
    bool? isHistoryVisible,
    bool? is3TapNavVisible,
    bool? isToolbarVisible,
  }) {
    return InterfaceVisibilityState(
      isToolMenuVisible: isToolMenuVisible ?? this.isToolMenuVisible,
      isHistoryVisible: isHistoryVisible ?? this.isHistoryVisible,
      is3TapNavVisible: is3TapNavVisible ?? this.is3TapNavVisible,
      isToolbarVisible: isToolbarVisible ?? this.isToolbarVisible,
    );
  }

  @override
  List<Object?> get props => [
        isToolMenuVisible,
        isHistoryVisible,
        is3TapNavVisible,
        isToolbarVisible,
      ];
}

class InterfaceVisibilityCubit extends Cubit<InterfaceVisibilityState> {
  InterfaceVisibilityCubit() : super(const InterfaceVisibilityState());

  void toggleToolMenu() {
    emit(state.copyWith(isToolMenuVisible: !state.isToolMenuVisible));
  }

  void toggleHistory() {
    emit(state.copyWith(isHistoryVisible: !state.isHistoryVisible));
  }

  void toggle3TapNav() {
    emit(state.copyWith(is3TapNavVisible: !state.is3TapNavVisible));
  }

  void toggleToolbar() {
    emit(state.copyWith(isToolbarVisible: !state.isToolbarVisible));
  }

  void setVisibility({
    bool? toolmenu,
    bool? history,
    bool? threeTapNav,
    bool? toolbar,
  }) {
    emit(state.copyWith(
      isToolMenuVisible: toolmenu ?? state.isToolMenuVisible,
      isHistoryVisible: history ?? state.isHistoryVisible,
      is3TapNavVisible: threeTapNav ?? state.is3TapNavVisible,
      isToolbarVisible: toolbar ?? state.isToolbarVisible,
    ));
  }

  void hideAll() {
    emit(const InterfaceVisibilityState(
      isToolMenuVisible: false,
      isHistoryVisible: false,
      is3TapNavVisible: false,
      isToolbarVisible: false,
    ));
  }
}
