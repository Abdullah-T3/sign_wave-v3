part of 'translator_cubit.dart';

sealed class TranslatorState extends Equatable {
  const TranslatorState();

  @override
  List<Object?> get props => [];
}

class TranslatorInitial extends TranslatorState {
  const TranslatorInitial();
}

class TranslatorLoading extends TranslatorState {
  const TranslatorLoading();
}

class TranslatorSuccess extends TranslatorState {
  final String formedText;
  final List<GesturePrediction> predictions;
  final List<RawPrediction> rawPredictions;

  const TranslatorSuccess({
    required this.formedText,
    required this.predictions,
    required this.rawPredictions,
  });

  @override
  List<Object?> get props => [formedText, predictions, rawPredictions];
}

class TranslatorError extends TranslatorState {
  final String error;

  const TranslatorError({required this.error});

  @override
  List<Object?> get props => [error];
}
