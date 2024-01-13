import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';

/// Flutter code sample for [IconButton].

//void main() => runApp(const IconButtonExampleApp());

Map<String, dynamic> userDetails = {};
String phoneNumber = '';
String password = '';

class IconButtonExampleApp extends StatelessWidget {
  final SharedPreferences prefs;
  final String username;

  const IconButtonExampleApp(
      {required this.prefs, required this.username, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    userDetails = getJson(prefs, username);
    phoneNumber = userDetails['simNumber'];
    password = userDetails['password'];

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Security System',
              style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.red,
        ),
        body: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [ArmButton(), DisarmButton()],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(60),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [ShowStatus()],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ArmButton extends StatefulWidget {
  const ArmButton({super.key});

  @override
  State<ArmButton> createState() => _ArmButtonState();
}

class _ArmButtonState extends State<ArmButton> {
  @override
  Widget build(BuildContext context) {
    IconData lock = const IconData(0xe3ae, fontFamily: 'MaterialIcons');

    return Column(
      children: [
        InkWell(
          child: Column(
            children: [
              Icon(
                lock,
                color: Colors.red,
                size: 75,
              ),
              const Text('Arm')
            ],
          ),
          onTap: () async {
            String message = "${password}1#";
            List<String> recipients = [phoneNumber];
            _sendSMS(context, message, recipients);
          },
        ),
      ],
    );
  }
}

class DisarmButton extends StatefulWidget {
  const DisarmButton({super.key});

  @override
  State<DisarmButton> createState() => _DisarmButtonState();
}

class _DisarmButtonState extends State<DisarmButton> {
  @override
  Widget build(BuildContext context) {
    IconData unlock = const IconData(0xe3b0, fontFamily: 'MaterialIcons');

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          child: Column(
            children: [
              Icon(
                unlock,
                color: Colors.red,
                size: 75,
              ),
              const Text('Disarm')
            ],
          ),
          onTap: () {
            String message = "${password}2#";
            List<String> recipients = [phoneNumber];
            _sendSMS(context, message, recipients);
          },
        ),
      ],
    );
  }
}

class ShowStatus extends StatefulWidget {
  const ShowStatus({super.key});

  @override
  State<ShowStatus> createState() => _ShowStatusState();
}

class _ShowStatusState extends State<ShowStatus> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          child: const Column(
            children: [
              Icon(
                Icons.description,
                size: 75,
                color: Colors.red,
              ),
              Text('Show Status')
            ],
          ),
          onTap: () {
            String message = "${password}4#";
            List<String> recipients = [phoneNumber];
            _sendSMS(context, message, recipients);
          },
        ),
      ],
    );
  }
}

Future<void> _sendSMS(
    BuildContext context, message, List<String> recipients) async {
  if (await Permission.sms.request().isGranted) {
    // Permission for SMS is granted.
    String alert = "";
    try {
      String _result = await sendSMS(
          message: message, recipients: recipients, sendDirect: true);
      if (_result == "SMS Sent!") {
        if (message == "${password}1#") {
          alert = "System Armed";
        } else if (message == "${password}2#") {
          alert = "System Disarmed";
        } else {
          alert = "Status Sent";
        }
      } else {
        alert = "Failed to perform action";
      }
    } catch (error) {
      alert = "Falied to send SMS";
    } finally {
      showToastmessage(context, alert);
    }
  } else {
    showToastmessage(context, "SMS Permission not granted. Allow in settings");
  }
}

void showToastmessage(BuildContext context, String message) {
  SnackBar snackBar = SnackBar(
    content: Text(message),
  );

  // Find the ScaffoldMessenger in the widget tree
  // and use it to show a SnackBar.
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

Map<String, dynamic> getJson(SharedPreferences prefs, String username) {
  String userDetails = prefs.getString(username) ?? "";
  Map<String, dynamic> userObject = json.decode(userDetails);
  return userObject;
}
