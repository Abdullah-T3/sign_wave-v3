import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sign_wave_v3/features/home/presentation/translator/cubit/translator_cubit.dart';

import '../../../../core/Responsive/ui_component/info_widget.dart'
    show InfoWidget;
import '../../../../core/theming/colors.dart' show ColorsManager;
import '../../../../core/theming/styles.dart' show TextStyles;
import '../../data/services/translator_service.dart' show TranslatorService;

class TranslatorScreen extends StatefulWidget {
  const TranslatorScreen({super.key});

  @override
  State<TranslatorScreen> createState() => _TranslatorScreenState();
}

class _TranslatorScreenState extends State<TranslatorScreen> {
  late final TranslatorCubit _translatorCubit;

  @override
  void initState() {
    super.initState();
    _translatorCubit = TranslatorCubit(translatorService: TranslatorService());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _translatorCubit,
      child: SafeArea(
        child: InfoWidget(
          builder: (context, deviceInfo) {
            return Scaffold(
              body: Column(
                children: [
                  // Camera preview placeholder
                  Container(
                    height: deviceInfo.screenHeight * 0.5,
                    width: double.infinity,
                    color: Colors.black87,
                    child: Center(
                      child: BlocBuilder<TranslatorCubit, TranslatorState>(
                        builder: (context, state) {
                          if (state is TranslatorLoading) {
                            return const CircularProgressIndicator(
                              color: Colors.white,
                            );
                          }
                          return state is TranslatorSuccess
                              ? const Icon(
                                Icons.videocam,
                                color: Colors.white,
                                size: 64,
                              )
                              : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.videocam_off,
                                    color: Colors.white54,
                                    size: 64,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    "Camera preview will appear here",
                                    style: TextStyles.body.copyWith(
                                      color: Colors.white70,
                                      fontSize: deviceInfo.screenWidth * 0.04,
                                    ),
                                  ),
                                ],
                              );
                        },
                      ),
                    ),
                  ),

                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Translation Results",
                            style: TextStyles.title.copyWith(
                              fontSize: deviceInfo.screenWidth * 0.045,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: BlocBuilder<
                                TranslatorCubit,
                                TranslatorState
                              >(
                                builder: (context, state) {
                                  if (state is TranslatorLoading) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  } else if (state is TranslatorSuccess) {
                                    return SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            state.formedText,
                                            style: TextStyles.body.copyWith(
                                              fontSize:
                                                  deviceInfo.screenWidth * 0.04,
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  ColorsManager.backgroundColor,
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                          Text(
                                            'Predictions:',
                                            style: TextStyles.body.copyWith(
                                              fontSize:
                                                  deviceInfo.screenWidth *
                                                  0.035,
                                            ),
                                          ),
                                          ...state.predictions.map(
                                            (pred) => Padding(
                                              padding: const EdgeInsets.only(
                                                top: 8,
                                              ),
                                              child: Text(
                                                '${pred.gesture} (${pred.startTime.toStringAsFixed(1)}s - ${pred.endTime.toStringAsFixed(1)}s)',
                                                style: TextStyles.body.copyWith(
                                                  fontSize:
                                                      deviceInfo.screenWidth *
                                                      0.035,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  } else if (state is TranslatorError) {
                                    return Center(
                                      child: Text(
                                        'Error: ${state.error}',
                                        style: TextStyles.body.copyWith(
                                          color: Colors.red,
                                          fontSize:
                                              deviceInfo.screenWidth * 0.035,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    );
                                  }
                                  return Center(
                                    child: Text(
                                      "No translation available yet. Start translating to see results.",
                                      style: TextStyles.body.copyWith(
                                        color: Colors.grey.shade600,
                                        fontSize:
                                            deviceInfo.screenWidth * 0.035,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Control buttons
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildControlButton(
                          icon: Icons.refresh,
                          label: "Reset",
                          onPressed: () {
                            _translatorCubit.resetTranslation();
                          },
                          deviceInfo: deviceInfo,
                        ),
                        _buildControlButton(
                          icon: Icons.play_arrow,
                          label: "Start",
                          onPressed: () {
                            _translatorCubit.recordVideo();
                          },
                          deviceInfo: deviceInfo,
                          isPrimary: true,
                        ),
                        _buildControlButton(
                          icon: Icons.settings,
                          label: "Settings",
                          onPressed: () {
                            // Show settings dialog or navigate to settings screen
                          },
                          deviceInfo: deviceInfo,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required deviceInfo,
    bool isPrimary = false,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: isPrimary ? Colors.blue : Colors.grey.shade200,
            foregroundColor: isPrimary ? Colors.white : Colors.black87,
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(16),
          ),
          child: Icon(icon, size: deviceInfo.screenWidth * 0.06),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyles.body.copyWith(
            fontSize: deviceInfo.screenWidth * 0.035,
          ),
        ),
      ],
    );
  }
}
