# APPENDIX (CODES)

## A.1 Key Algorithms

### A.1.1 Sign Recognition Model

```dart
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite/tflite.dart';
import 'dart:math' as math;

class SignRecognizer {
  // Model configuration
  static const String modelPath = 'assets/models/sign_language_model.tflite';
  static const String labelsPath = 'assets/models/sign_labels.txt';
  
  // Recognition parameters
  static const int inputSize = 224;
  static const double confidenceThreshold = 0.70;
  
  // Model state
  bool isModelLoaded = false;
  List<dynamic> recognitionResults = [];
  
  // Initialize the TFLite model
  Future<void> loadModel() async {
    try {
      await Tflite.loadModel(
        model: modelPath,
        labels: labelsPath,
        numThreads: 2,
        useGpuDelegate: true,
      );
      isModelLoaded = true;
      debugPrint('Sign language model loaded successfully');
    } catch (e) {
      debugPrint('Failed to load model: $e');
    }
  }
  
  // Process camera frame for sign recognition
  Future<List<dynamic>> recognizeFromFrame(CameraImage cameraImage) async {
    if (!isModelLoaded) {
      await loadModel();
    }
    
    // Convert camera image to appropriate format
    var recognitions = await Tflite.runModelOnFrame(
      bytesList: cameraImage.planes.map((plane) => plane.bytes).toList(),
      imageHeight: cameraImage.height,
      imageWidth: cameraImage.width,
      imageMean: 127.5,
      imageStd: 127.5,
      rotation: 90,
      numResults: 3,
      threshold: confidenceThreshold,
    );
    
    // Filter and process results
    recognitionResults = recognitions ?? [];
    return recognitionResults;
  }
  
  // Get the highest confidence prediction
  Map<String, dynamic> getTopPrediction() {
    if (recognitionResults.isEmpty) {
      return {'label': 'No sign detected', 'confidence': 0.0};
    }
    
    // Sort by confidence and return top result
    recognitionResults.sort((a, b) => (b['confidence'] as double).compareTo(a['confidence'] as double));
    var topResult = recognitionResults.first;
    
    return {
      'label': topResult['label'].toString().substring(2), // Remove index prefix
      'confidence': topResult['confidence'] as double,
    };
  }
  
  // Clean up resources
  Future<void> dispose() async {
    await Tflite.close();
    isModelLoaded = false;
  }
}
```

### A.1.2 Text-to-Speech Implementation

```dart
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeechService {
  final FlutterTts flutterTts = FlutterTts();
  bool isPlaying = false;
  
  // TTS configuration parameters
  double speechRate = 0.5; // Range: 0.0 - 1.0
  double volume = 1.0;     // Range: 0.0 - 1.0
  double pitch = 1.0;      // Range: 0.0 - 2.0
  String language = 'en-US';
  
  // Initialize TTS engine with default settings
  Future<void> initTts() async {
    await flutterTts.setLanguage(language);
    await flutterTts.setSpeechRate(speechRate);
    await flutterTts.setVolume(volume);
    await flutterTts.setPitch(pitch);
    
    // Set up completion listener
    flutterTts.setCompletionHandler(() {
      isPlaying = false;
    });
  }
  
  // Speak the provided text
  Future<void> speak(String text) async {
    if (text.isEmpty) return;
    
    // Stop any ongoing speech
    if (isPlaying) {
      await stop();
    }
    
    isPlaying = true;
    await flutterTts.speak(text);
  }
  
  // Stop current speech
  Future<void> stop() async {
    await flutterTts.stop();
    isPlaying = false;
  }
  
  // Update TTS settings
  Future<void> updateSettings({
    double? rate,
    double? vol,
    double? p,
    String? lang,
  }) async {
    if (rate != null) {
      speechRate = rate;
      await flutterTts.setSpeechRate(speechRate);
    }
    
    if (vol != null) {
      volume = vol;
      await flutterTts.setVolume(volume);
    }
    
    if (p != null) {
      pitch = p;
      await flutterTts.setPitch(pitch);
    }
    
    if (lang != null) {
      language = lang;
      await flutterTts.setLanguage(language);
    }
  }
  
  // Clean up resources
  void dispose() {
    flutterTts.stop();
  }
}
```

### A.1.3 Video Call Integration

```dart
import 'package:flutter/material.dart';
import 'package:zego_express_engine/zego_express_engine.dart';

class VideoCallService {
  // ZegoCloud configuration
  final int appID;
  final String appSign;
  final String userID;
  final String userName;
  
  // Call state
  bool isInitialized = false;
  String? currentRoomID;
  bool isLocalVideoMuted = false;
  bool isLocalAudioMuted = false;
  
  VideoCallService({
    required this.appID,
    required this.appSign,
    required this.userID,
    required this.userName,
  });
  
  // Initialize the ZegoCloud SDK
  Future<void> initializeSDK() async {
    if (isInitialized) return;
    
    // Create engine
    ZegoEngineProfile profile = ZegoEngineProfile(
      appID,
      ZegoScenario.General,
      appSign: appSign,
      enablePlatformView: true,
    );
    
    await ZegoExpressEngine.createEngineWithProfile(profile);
    
    // Set event handlers
    ZegoExpressEngine.onRoomStateUpdate = (String roomID, ZegoRoomState state, int errorCode, Map<String, dynamic> extendedData) {
      debugPrint('Room state updated: $roomID, state: $state, error: $errorCode');
    };
    
    ZegoExpressEngine.onRoomUserUpdate = (String roomID, ZegoUpdateType updateType, List<ZegoUser> userList) {
      debugPrint('Room user updated: $roomID, type: $updateType, users: ${userList.length}');
    };
    
    isInitialized = true;
  }
  
  // Join a video call room
  Future<bool> joinRoom(String roomID) async {
    if (!isInitialized) {
      await initializeSDK();
    }
    
    try {
      // Create user object
      ZegoUser user = ZegoUser(userID, userName);
      
      // Join room
      await ZegoExpressEngine.instance.loginRoom(
        roomID,
        user,
        config: ZegoRoomConfig(
          0, // Maximum member count, 0 means unlimited
          true, // Is user update notification required
          'extra_info', // Room extra info
        ),
      );
      
      // Start publishing local stream
      await ZegoExpressEngine.instance.startPublishingStream('stream_$userID');
      
      // Start local preview
      await ZegoExpressEngine.instance.startPreview(
        canvas: ZegoCanvas(null, viewMode: ZegoViewMode.AspectFill),
      );
      
      currentRoomID = roomID;
      return true;
    } catch (e) {
      debugPrint('Failed to join room: $e');
      return false;
    }
  }
  
  // Leave the current video call
  Future<void> leaveRoom() async {
    if (currentRoomID == null) return;
    
    try {
      // Stop publishing
      await ZegoExpressEngine.instance.stopPublishingStream();
      
      // Stop preview
      await ZegoExpressEngine.instance.stopPreview();
      
      // Log out of room
      await ZegoExpressEngine.instance.logoutRoom(currentRoomID!);
      
      currentRoomID = null;
    } catch (e) {
      debugPrint('Error leaving room: $e');
    }
  }
  
  // Toggle local video (camera)
  Future<bool> toggleLocalVideo() async {
    isLocalVideoMuted = !isLocalVideoMuted;
    
    try {
      await ZegoExpressEngine.instance.mutePublishStreamVideo(isLocalVideoMuted);
      return true;
    } catch (e) {
      debugPrint('Failed to toggle video: $e');
      isLocalVideoMuted = !isLocalVideoMuted; // Revert state change
      return false;
    }
  }
  
  // Toggle local audio (microphone)
  Future<bool> toggleLocalAudio() async {
    isLocalAudioMuted = !isLocalAudioMuted;
    
    try {
      await ZegoExpressEngine.instance.mutePublishStreamAudio(isLocalAudioMuted);
      return true;
    } catch (e) {
      debugPrint('Failed to toggle audio: $e');
      isLocalAudioMuted = !isLocalAudioMuted; // Revert state change
      return false;
    }
  }
  
  // Clean up resources
  Future<void> dispose() async {
    if (currentRoomID != null) {
      await leaveRoom();
    }
    
    if (isInitialized) {
      await ZegoExpressEngine.destroyEngine();
      isInitialized = false;
    }
  }
}
```

## A.2 Database Schema

```json
// Firebase Firestore Collections Schema

// Users Collection
{
  "users": {
    "user_id": {
      "uid": "string",
      "email": "string",
      "displayName": "string",
      "photoURL": "string",
      "createdAt": "timestamp",
      "lastLogin": "timestamp",
      "preferences": {
        "isDarkMode": "boolean",
        "fontSize": "number",
        "isHighContrast": "boolean",
        "primaryLanguage": "string",
        "useHapticFeedback": "boolean",
        "recognitionSensitivity": "number"
      },
      "deviceTokens": ["string"]
    }
  },
  
  // Contacts Collection
  "contacts": {
    "contact_id": {
      "ownerUid": "string",
      "contactUid": "string",
      "displayName": "string",
      "photoURL": "string",
      "lastInteraction": "timestamp",
      "isFavorite": "boolean",
      "notes": "string"
    }
  },
  
  // Conversations Collection
  "conversations": {
    "conversation_id": {
      "participants": ["string"],
      "startTime": "timestamp",
      "endTime": "timestamp",
      "duration": "number",
      "callType": "string"
    }
  },
  
  // Messages Collection
  "messages": {
    "message_id": {
      "conversationId": "string",
      "senderUid": "string",
      "content": "string",
      "timestamp": "timestamp",
      "messageType": "string",
      "isTranslated": "boolean",
      "originalContent": "string"
    }
  },
  
  // SavedPhrases Collection
  "savedPhrases": {
    "phrase_id": {
      "ownerUid": "string",
      "content": "string",
      "translation": "string",
      "category": "string",
      "usageCount": "number",
      "lastUsed": "timestamp",
      "isFavorite": "boolean"
    }
  },
  
  // FeedbackReports Collection
  "feedbackReports": {
    "report_id": {
      "userUid": "string",
      "reportType": "string",
      "content": "string",
      "timestamp": "timestamp",
      "appVersion": "string",
      "deviceInfo": "string",
      "status": "string",
      "resolution": "string"
    }
  }
}
```

## A.3 API Documentation

### A.3.1 Authentication API

```
Endpoint: /api/auth/register
Method: POST
Parameters: 
  - email: string
  - password: string
  - displayName: string
Response: 
  - uid: string
  - token: string
  - expiresIn: number
```

```
Endpoint: /api/auth/login
Method: POST
Parameters: 
  - email: string
  - password: string
Response: 
  - uid: string
  - token: string
  - expiresIn: number
  - refreshToken: string
```

### A.3.2 Translation API

```
Endpoint: /api/translate/sign
Method: POST
Parameters: 
  - video_data: base64 string or multipart form data
  - source_language: string (default: "asl")
  - target_language: string (default: "en")
Response: 
  - translated_text: string
  - confidence: number
  - alternatives: array of strings
```

```
Endpoint: /api/translate/speech
Method: POST
Parameters: 
  - audio_data: base64 string or multipart form data
  - source_language: string (default: "en")
  - target_language: string (default: "asl")
Response: 
  - transcribed_text: string
  - confidence: number
```

### A.3.3 User Data API

```
Endpoint: /api/user/profile
Method: GET
Headers: 
  - Authorization: Bearer {token}
Response: 
  - uid: string
  - email: string
  - displayName: string
  - photoURL: string
  - preferences: object
```

```
Endpoint: /api/user/preferences
Method: PUT
Headers: 
  - Authorization: Bearer {token}
Parameters: 
  - preferences: object
Response: 
  - success: boolean
  - updated_preferences: object
```

## A.4 Testing Scripts

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:sign_wave/services/sign_recognizer.dart';
import 'package:sign_wave/services/text_to_speech_service.dart';
import 'package:sign_wave/services/video_call_service.dart';
import 'package:mockito/mockito.dart';

// Mock classes
class MockTflite extends Mock implements Tflite {}
class MockFlutterTts extends Mock implements FlutterTts {}
class MockZegoExpressEngine extends Mock implements ZegoExpressEngine {}

void main() {
  group('SignRecognizer Tests', () {
    late SignRecognizer signRecognizer;
    late MockTflite mockTflite;
    
    setUp(() {
      mockTflite = MockTflite();
      signRecognizer = SignRecognizer();
    });
    
    test('loadModel initializes correctly', () async {
      // Arrange
      when(mockTflite.loadModel(
        model: anyNamed('model'),
        labels: anyNamed('labels'),
        numThreads: anyNamed('numThreads'),
        useGpuDelegate: anyNamed('useGpuDelegate'),
      )).thenAnswer((_) async => 1);
      
      // Act
      await signRecognizer.loadModel();
      
      // Assert
      expect(signRecognizer.isModelLoaded, true);
    });
    
    test('getTopPrediction returns highest confidence result', () {
      // Arrange
      signRecognizer.recognitionResults = [
        {'label': '0 Hello', 'confidence': 0.7},
        {'label': '1 Thank You', 'confidence': 0.9},
        {'label': '2 Please', 'confidence': 0.5},
      ];
      
      // Act
      var result = signRecognizer.getTopPrediction();
      
      // Assert
      expect(result['label'], 'Thank You');
      expect(result['confidence'], 0.9);
    });
  });
  
  group('TextToSpeechService Tests', () {
    late TextToSpeechService ttsService;
    late MockFlutterTts mockFlutterTts;
    
    setUp(() {
      mockFlutterTts = MockFlutterTts();
      ttsService = TextToSpeechService();
      ttsService.flutterTts = mockFlutterTts;
    });
    
    test('speak calls FlutterTts correctly', () async {
      // Arrange
      when(mockFlutterTts.speak(any)).thenAnswer((_) async => 1);
      
      // Act
      await ttsService.speak('Hello world');
      
      // Assert
      verify(mockFlutterTts.speak('Hello world')).called(1);
      expect(ttsService.isPlaying, true);
    });
    
    test('updateSettings changes TTS parameters', () async {
      // Arrange
      when(mockFlutterTts.setSpeechRate(any)).thenAnswer((_) async => 1);
      when(mockFlutterTts.setVolume(any)).thenAnswer((_) async => 1);
      
      // Act
      await ttsService.updateSettings(rate: 0.8, vol: 0.5);
      
      // Assert
      expect(ttsService.speechRate, 0.8);
      expect(ttsService.volume, 0.5);
      verify(mockFlutterTts.setSpeechRate(0.8)).called(1);
      verify(mockFlutterTts.setVolume(0.5)).called(1);
    });
  });
  
  group('VideoCallService Tests', () {
    late VideoCallService videoCallService;
    
    setUp(() {
      videoCallService = VideoCallService(
        appID: 12345,
        appSign: 'test_sign',
        userID: 'test_user',
        userName: 'Test User',
      );
    });
    
    test('toggleLocalVideo changes mute state', () async {
      // Arrange - Initial state
      expect(videoCallService.isLocalVideoMuted, false);
      
      // Mock the ZegoExpressEngine instance
      // This would require more complex setup in a real test
      
      // Act - Toggle video
      await videoCallService.toggleLocalVideo();
      
      // Assert - State should be changed
      expect(videoCallService.isLocalVideoMuted, true);
      
      // Act - Toggle again
      await videoCallService.toggleLocalVideo();
      
      // Assert - Back to original state
      expect(videoCallService.isLocalVideoMuted, false);
    });
  });
}
```