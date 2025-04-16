import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../data/services/translator_service.dart';

part 'translator_state.dart';

class TranslatorCubit extends Cubit<TranslatorState> {
  final TranslatorService _translatorService;
  final ImagePicker _picker = ImagePicker();

  TranslatorCubit({required TranslatorService translatorService})
    : _translatorService = translatorService,
      super(const TranslatorInitial());

  Future<void> recordVideo() async {
    try {
      final XFile? videoFile = await _picker.pickVideo(
        source: ImageSource.camera,
        maxDuration: const Duration(seconds: 30),
      );

      if (videoFile != null) {
        emit(const TranslatorLoading());
        await processVideoForTranslation(videoFile);
      }
    } catch (e) {
      emit(TranslatorError(error: 'Failed to record video: ${e.toString()}'));
    }
  }

  Future<void> processVideoForTranslation(XFile videoFile) async {
    try {
      // Read video file as bytes
      final File file = File(videoFile.path);
      final videoData = await file.readAsBytes();

      // Convert to base64 or whatever format your API expects
      final response = await _translatorService.predictGestures(videoFile.path);

      emit(
        TranslatorSuccess(
          formedText: response.formedText,
          predictions: response.predictions,
          rawPredictions: response.rawPredictions,
        ),
      );
      print(response.predictions);
    } catch (e, trace) {
      print(trace.toString());
      emit(TranslatorError(error: 'Failed to process video: ${e.toString()}'));
    }
  }

  void resetTranslation() {
    emit(const TranslatorInitial());
  }
}
