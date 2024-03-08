import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';

class CallPage extends StatefulWidget {
  const CallPage({super.key});

  @override
  State<CallPage> createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  final AgoraClient client = AgoraClient(
    agoraConnectionData: AgoraConnectionData(
      appId: "be5ffb877e864250a3dd19f1aa6d8f2f",
      channelName: "fitnessapp",
      tempToken: '4e6571e33b73479ebcb308b56972ac05',
    ),
    enabledPermission: [
      Permission.camera,
      Permission.microphone,
    ],
  );

  @override
  void initState() {
    super.initState();
    initAgora();
  }

  void initAgora() async {
    await client.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            AgoraVideoViewer(
              client: client,
              layoutType: Layout.floating,
              enableHostControls: true,
            ),
            AgoraVideoButtons(client: client),
          ],
        ),
      ),
    );
  }
}
