import 'dart:convert';
import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class VideoCall extends StatefulWidget {
  const VideoCall({super.key, required this.channelName});
  final String channelName;

  @override
  State<VideoCall> createState() => _VideoCallState();
}

class _VideoCallState extends State<VideoCall> {
  bool _loading = true;
  late final AgoraClient _client;
  var rtmToken = '';

  var appid = "be5ffb877e864250a3dd19f1aa6d8f2f";
  var appcertificate = "4e6571e33b73479ebcb308b56972ac05";

  @override
  void initState() {
    getToken();
    super.initState();
  }

  Future<void> getToken() async {
    String link = "https://32788e4d-3d60-41c3-9a6e-d4fe828edf83-00-1icxzzm7wnepb.spock.replit.dev/rtm/test/?expiry=3600";
    final response = await http.get(Uri.parse(link));
    Map data = jsonDecode(response.body);
    setState(() {
      rtmToken =
          "007eJxTYFAoX15vwuf4Rv58e6rH+dxawcYCH/fuBSZLDnxbv+JgzhcFhqRU07S0JAtz81QLMxMjU4NE45QUQ8s0w8REsxSLNKO0lI1WaQ2BjAzTns9nZWSAQBCfhaEktbiEgQEAYiAgrQ==";
      //data["rtmToken"];
    });

    _client = AgoraClient(
        agoraConnectionData: AgoraConnectionData(
          appId: appid,
          tempRtmToken: rtmToken,
          channelName: widget.channelName,
        ),
        enabledPermission: [
          Permission.camera,
          Permission.microphone,
        ]);
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() => _loading = false));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _loading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Stack(
                children: [
                  AgoraVideoViewer(
                    client: _client,
                  ),
                  AgoraVideoButtons(
                    client: _client,
                  )
                ],
              ),
      ),
    );
  }
}
