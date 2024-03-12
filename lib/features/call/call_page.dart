import 'package:fitness_app/features/call/join_call.dart';
import 'package:fitness_app/features/call/new_meeting.dart';
import 'package:flutter/material.dart';

class CallPage extends StatelessWidget {
  const CallPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Video Conference"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const NewMeeting(),
                    fullscreenDialog: true,
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text("New Meeting"),
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(350, 30),
                backgroundColor: Colors.indigo,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ),
          const Divider(
            thickness: 1,
            height: 30,
            indent: 40,
            endIndent: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(
              20,
            ),
            child: OutlinedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => JoinCall(),
                    fullscreenDialog: true,
                  ),
                );
              },
              icon: const Icon(Icons.margin),
              label: const Text("Join with a code"),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.indigo,
                side: const BorderSide(color: Colors.indigo),
                fixedSize: const Size(350, 30),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ),
          const SizedBox(height: 150),
          Image.network("https://user-images.githubusercontent.com/67534990/127524449-fa11a8eb-473a-4443-962a-07a3e41c71c0.png")
        ],
      ),
    );
  }
}
