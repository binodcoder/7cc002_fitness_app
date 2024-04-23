import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../drawer.dart';
import '../../../injection_container.dart';
import '../../../resources/colour_manager.dart';
import 'join_call.dart';
import 'new_meeting.dart';

class CallPage extends StatelessWidget {
  CallPage({super.key});

  final SharedPreferences sharedPreferences = sl<SharedPreferences>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(),
      appBar: AppBar(
        backgroundColor: ColorManager.primary,
        title: const Text("Video Conference"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 15,
          ),
          sharedPreferences.getString('role') == "trainer"
              ? Padding(
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
                )
              : const SizedBox(),
          sharedPreferences.getString('role') == "standard"
              ? Padding(
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
                )
              : const SizedBox(),
          const SizedBox(height: 10),
          Image.network("https://user-images.githubusercontent.com/67534990/127524449-fa11a8eb-473a-4443-962a-07a3e41c71c0.png")
        ],
      ),
    );
  }
}
