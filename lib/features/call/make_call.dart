import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';

class MakeCallPage extends StatefulWidget {
  const MakeCallPage({super.key});

  @override
  State<MakeCallPage> createState() => _MakeCallPageState();
}

var appid = "be5ffb877e864250a3dd19f1aa6d8f2f";
var appienew = "be5ffb877e864250a3dd19f1aa6d8f2f";
var appcertificate = "4e6571e33b73479ebcb308b56972ac05";
var channelName = "test";
var tempToken =
    "007eJxTYNjr4n3/Rt+0c33dVy7H+aQceW81M9f9PKf1jHmrzX/dKJupwJCUapqWlmRhbp5qYWZiZGqQaJySYmiZZpiYaJZikWaUpqH0PrUhkJEhffYBRkYGCATxWRhKUotLGBgAMq0idA==";

class _MakeCallPageState extends State<MakeCallPage> {
  final AgoraClient client = AgoraClient(
    agoraConnectionData: AgoraConnectionData(
      appId: appid,
      channelName: channelName,
      tempRtmToken: tempToken,
    ),
    enabledPermission: [
      Permission.camera,
      Permission.microphone,
    ],
    //agoraEventHandlers: AgoraEventHandlers(),
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
            AgoraVideoButtons(
              client: client,
            ),
          ],
        ),
      ),
    );
  }
}
