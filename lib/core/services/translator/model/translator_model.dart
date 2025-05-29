class TranslationResponse {
  final String formedText;
  final String mostCommonGesture;
  final List<GesturePrediction> predictions;
  final List<RawPrediction> rawPredictions;
  final double videoDuration;

  TranslationResponse({
    required this.formedText,
    required this.mostCommonGesture,
    required this.predictions,
    required this.rawPredictions,
    required this.videoDuration,
  });

  factory TranslationResponse.fromJson(Map<String, dynamic> json) {
    try {
      return TranslationResponse(
        formedText: json['formed_text']?.toString() ?? '',
        mostCommonGesture: json['most_common_gesture']?.toString() ?? '',
        predictions:
            (json['predictions'] as List<dynamic>?)
                ?.map(
                  (p) => GesturePrediction.fromJson(p as Map<String, dynamic>),
                )
                .toList() ??
            [],
        rawPredictions:
            (json['raw_predictions'] as List<dynamic>?)
                ?.map((p) => RawPrediction.fromJson(p as Map<String, dynamic>))
                .toList() ??
            [],
        videoDuration: (json['video_duration'] as num?)?.toDouble() ?? 0.0,
      );
    } catch (e) {
      throw FormatException(
        'Failed to parse TranslationResponse: ${e.toString()}',
      );
    }
  }
}

class GesturePrediction {
  final double duration;
  final double endTime;
  final String gesture;
  final double startTime;

  GesturePrediction({
    required this.duration,
    required this.endTime,
    required this.gesture,
    required this.startTime,
  });

  factory GesturePrediction.fromJson(Map<String, dynamic> json) {
    try {
      return GesturePrediction(
        duration: (json['duration'] as num?)?.toDouble() ?? 0.0,
        endTime: (json['end_time'] as num?)?.toDouble() ?? 0.0,
        gesture: json['gesture']?.toString() ?? '',
        startTime: (json['start_time'] as num?)?.toDouble() ?? 0.0,
      );
    } catch (e) {
      throw FormatException(
        'Failed to parse GesturePrediction: ${e.toString()}',
      );
    }
  }
}

class RawPrediction {
  final double confidence;
  final String gesture;
  final double time;

  RawPrediction({
    required this.confidence,
    required this.gesture,
    required this.time,
  });

  factory RawPrediction.fromJson(Map<String, dynamic> json) {
    try {
      return RawPrediction(
        confidence: (json['confidence'] as num?)?.toDouble() ?? 0.0,
        gesture: json['gesture']?.toString() ?? '',
        time: (json['time'] as num?)?.toDouble() ?? 0.0,
      );
    } catch (e) {
      throw FormatException('Failed to parse RawPrediction: ${e.toString()}');
    }
  }
}
