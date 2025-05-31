part of 'translations_bloc.dart';

sealed class AllTranslationsEvent extends Equatable {
  const AllTranslationsEvent();

  @override
  List<Object> get props => [];
}

final class AllTranslationsSubscriptionRequested extends AllTranslationsEvent {}
