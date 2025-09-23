import 'package:flutter/material.dart';
import 'package:sign_wave_v3/core/services/call_manager.dart';

class CallStatusWidget extends StatefulWidget {
  const CallStatusWidget({super.key});

  @override
  State<CallStatusWidget> createState() => _CallStatusWidgetState();
}

class _CallStatusWidgetState extends State<CallStatusWidget> {
  final CallManager _callManager = CallManager();
  CallState _currentState = CallState.idle;
  CallInfo? _currentCall;

  @override
  void initState() {
    super.initState();
    _callManager.onCallStateChanged = _onCallStateChanged;
    _callManager.onCallStarted = _onCallStarted;
    _callManager.onCallEnded = _onCallEnded;

    // Set initial state
    _currentState = _callManager.currentState;
    _currentCall = _callManager.currentCall;
  }

  void _onCallStateChanged(CallState state) {
    if (mounted) {
      setState(() {
        _currentState = state;
      });
    }
  }

  void _onCallStarted(CallInfo callInfo) {
    if (mounted) {
      setState(() {
        _currentCall = callInfo;
      });
    }
  }

  void _onCallEnded(CallInfo callInfo) {
    if (mounted) {
      setState(() {
        _currentCall = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_currentState == CallState.idle || _currentCall == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.white.withAlpha(20),
                child:
                    _currentCall!.callerAvatar.isNotEmpty
                        ? ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            _currentCall!.callerAvatar,
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 20,
                              );
                            },
                          ),
                        )
                        : Icon(Icons.person, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getCallStatusText(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _currentCall!.callerName,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              if (_currentState == CallState.ringing)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () => _callManager.declineCall(),
                      icon: const Icon(Icons.call_end, color: Colors.red),
                    ),
                    IconButton(
                      onPressed: () => _callManager.acceptCall(),
                      icon: const Icon(Icons.call, color: Colors.green),
                    ),
                  ],
                )
              else if (_currentState == CallState.connected)
                IconButton(
                  onPressed: () => _callManager.endCall(),
                  icon: const Icon(Icons.call_end, color: Colors.red),
                ),
            ],
          ),
          if (_currentState == CallState.connected)
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                'Connected - Tap to end call',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }

  String _getCallStatusText() {
    switch (_currentState) {
      case CallState.initiating:
        return 'Initiating call...';
      case CallState.ringing:
        return _currentCall!.type == CallType.incoming
            ? 'Incoming call'
            : 'Calling...';
      case CallState.connected:
        return 'Connected';
      case CallState.ended:
        return 'Call ended';
      case CallState.declined:
        return 'Call declined';
      case CallState.missed:
        return 'Missed call';
      case CallState.idle:
        return '';
    }
  }
}
