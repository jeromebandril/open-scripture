import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ToolbarCubit extends Cubit<ToolbarState> {
  ToolbarCubit() : super(ToolbarState.initial());

  void toggleVisibility() {
    emit(state.copyWith(isVisible: !state.isVisible));
  }

  void setHightlightActivePane(bool value) {
    emit(state.copyWith(highlightActivePane: value));
  }
}

class ToolbarState extends Equatable {
  final bool isVisible;
  final bool highlightActivePane;

  const ToolbarState({
    required this.isVisible,
    required this.highlightActivePane,
  });

  const ToolbarState.initial({
    this.isVisible = false,
    this.highlightActivePane = true,
  });

  ToolbarState copyWith({bool? isVisible, bool? highlightActivePane}) {
    return ToolbarState(
      isVisible: isVisible ?? this.isVisible,
      highlightActivePane: highlightActivePane ?? this.highlightActivePane,
    );
  }

  @override
  List<Object?> get props => [isVisible, highlightActivePane];
}
