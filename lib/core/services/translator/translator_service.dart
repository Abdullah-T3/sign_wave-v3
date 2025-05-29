import 'dart:io';
import 'package:dio/dio.dart';
import 'package:sign_wave_v3/core/services/translator/model/translator_model.dart';

class TranslatorService {
  static const String _baseUrl = 'https://sign-app-048839719ea2.herokuapp.com';
  final dio = Dio();

  Future<TranslationResponse> predictGestures(String videoPath) async {
    // If videoPath is a file path, handle it accordingly
    final File videoFile = File(videoPath);

    // Create form data for the request
    final formData = FormData.fromMap({
      'video': await MultipartFile.fromFile(
        videoFile.path,
        filename: videoFile.path.split('/').last,
      ),
    });

    // Send the request and process the response
    final response = await dio.post(
      '$_baseUrl/predict_video_batch',
      data: formData,
    );

    return TranslationResponse.fromJson(response.data);
  }
}
