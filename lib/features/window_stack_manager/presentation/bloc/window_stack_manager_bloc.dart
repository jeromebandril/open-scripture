import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'window_stack_manager_event.dart';
part 'window_stack_manager_state.dart';

class WindowStackManagerBloc
    extends Bloc<WindowStackManagerEvent, WindowStackManagerState> {
  WindowStackManagerBloc() : super(const WindowStackManagerState()) {
    on<WindowStackManagerOpen>(_onOpen);
    on<WindowStackManagerClose>(_onClose);
  }

  Future<void> _onOpen(
    WindowStackManagerOpen event,
    Emitter<WindowStackManagerState> emit,
  ) async {
    emit(WindowStackManagerState(
      windows: [...state.windows, (_) => event.window],
    ));
  }

  Future<void> _onClose(
    WindowStackManagerClose event,
    Emitter<WindowStackManagerState> emit,
  ) async {
    emit(WindowStackManagerState(
      windows: state.windows.sublist(0, state.windows.length - 1),
    ));
  }
}
