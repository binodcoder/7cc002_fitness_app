import 'dart:convert';
import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class VideoCall extends StatefulWidget {
  const VideoCall({super.key, required this.channelName});
  final String channelName;

  @override
  State<VideoCall> createState() => _VideoCallState();
}

class _VideoCallState extends State<VideoCall> {
  late final AgoraClient _client;
  bool _loading = true;
  String tempToken = "";

  @override
  void initState() {
    getToken();
    super.initState();
  }

  Future<void> getToken() async {
    String link = "https://agora-node-tokenserver-1.davidcaleb.repl.co/access_token?channelName=${widget.channelName}";

    Response response = await get(Uri.parse(link));
    Map data = jsonDecode(response.body);
    setState(() {
      tempToken = data["token"];
    });
    _client = AgoraClient(
        agoraConnectionData: AgoraConnectionData(
          appId: "843077704d2f4d19a7ed336afaa0c2ca",
          tempToken: tempToken,
          channelName: widget.channelName,
        ),
        enabledPermission: [Permission.camera, Permission.microphone]);
    Future.delayed(const Duration(seconds: 1)).then(
      (value) => setState(() => _loading = false),
    );
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
                  AgoraVideoButtons(client: _client)
                ],
              ),
      ),
    );
  }
}
