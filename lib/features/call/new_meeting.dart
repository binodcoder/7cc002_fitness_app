import 'package:fitness_app/features/call/call_test.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class NewMeeting extends StatefulWidget {
  const NewMeeting({Key? key}) : super(key: key);

  @override
  State<NewMeeting> createState() => _NewMeetingState();
}

class _NewMeetingState extends State<NewMeeting> {
  final String _meetingCode = "test";

  @override
  void initState() {
    // var uuid = const Uuid();
    //  _meetingCode = uuid.v1().substring(0, 8);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_sharp),
                iconSize: 35,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            const SizedBox(height: 50),
            Image.network(
              "https://user-images.githubusercontent.com/67534990/127776392-8ef4de2d-2fd8-4b5a-b98b-ea343b19c03e.png",
              fit: BoxFit.cover,
              height: 100,
            ),
            const SizedBox(height: 20),
            const Text(
              "Enter meeting code below",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.all(
                10,
              ),
              child: Card(
                color: Colors.grey[300],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                child: ListTile(
                  leading: const Icon(Icons.link),
                  title: SelectableText(
                    _meetingCode,
                    style: const TextStyle(fontWeight: FontWeight.w300),
                  ),
                  trailing: const Icon(Icons.copy),
                ),
              ),
            ),
            const Divider(
              thickness: 1,
              height: 20,
              indent: 20,
              endIndent: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  Share.share("Meeting Code : $_meetingCode");
                },
                icon: const Icon(Icons.arrow_drop_down),
                label: const Text("Share invite"),
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(350, 30),
                  backgroundColor: Colors.indigo,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => CallTest(
                        channel: _meetingCode.trim(),
                      ),
                      fullscreenDialog: true,
                    ),
                  );
                },
                icon: const Icon(Icons.video_call),
                label: const Text("start call"),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.indigo,
                  side: const BorderSide(
                    color: Colors.indigo,
                  ),
                  fixedSize: const Size(350, 30),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
