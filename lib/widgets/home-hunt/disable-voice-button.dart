import 'package:flutter/material.dart';
import 'package:real_state_finder/services/read-text-service.dart';
import 'package:real_state_finder/utils/constants.dart';

class DisableVoiceButton extends StatefulWidget {
  @override
  _DisableVoiceButtonState createState() => _DisableVoiceButtonState();
}

class _DisableVoiceButtonState extends State<DisableVoiceButton> {
  IconData icon = Icons.volume_off;
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, color: Colors.white,), 
      onPressed: () {
        if(icon == Icons.volume_off) {
          ReadService().tts.stop();
          enableVoice = false;
          setState(() => icon = Icons.volume_up);
        } else {
          enableVoice = true;
          setState(() => icon = Icons.volume_off);
        }
      }
    );
  }
}