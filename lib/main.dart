import 'package:flutter/material.dart';
import 'package:string_validator/string_validator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'user_data.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TextBox(),
    );
  }
}

class TextBox extends StatefulWidget {
  const TextBox({Key? key}) : super(key: key);

  @override
  State<TextBox> createState() => _TextBoxState();
}

class _TextBoxState extends State<TextBox> {
  final userNameContr = TextEditingController();
  final simNumberContr = TextEditingController();
  late SharedPreferences prefs;
  final _formKey = GlobalKey<FormState>();

  String buttonText = 'Show User';
  bool showError = false;
  late String errorMsg; // Initializing button text

  @override
  void dispose() {
    userNameContr.dispose();
    simNumberContr.dispose();
    super.dispose();
  }

  @override
  void initState() {
    initPrefs();
    super.initState();
  }

  void initPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  void showToastmessage(BuildContext context, String name, String simNumber) {
    SnackBar snackBar = SnackBar(
      content: Text('$name has been created with $simNumber'),
    );

    // Find the ScaffoldMessenger in the widget tree
    // and use it to show a SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double objectWidth = screenWidth * 0.75;
    late UserData? user;

    return Form(
        key: _formKey,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('G10A', style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.red,
          ),
          body: Center(
            child: SizedBox(
              width: objectWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 100,
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a user name';
                        }
                        return null;
                      },
                      controller: userNameContr,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          // errorText: showError ? errorMsg : null,
                          labelText: 'User Name'),
                    ),
                  ),
                  SizedBox(
                    height: 100,
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a sim number';
                        } else if (isNumeric(value) == false) {
                          return 'Only numbers are allowed';
                        } else if (value.length != 10) {
                          return 'Sim number must be 10 digits long';
                        }
                        return null;
                      },
                      controller: simNumberContr,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          //errorText: showError ? errorMsg : null,
                          labelText: 'Sim Number'),
                    ),
                  ),
                  SubmitButton(
                    buttonText: 'Create User',
                    onButtonPressed: () {
                      // Validating the user input to the sim number field
                      if (_formKey.currentState!.validate()) {
                        user = UserData(
                          username: userNameContr.text,
                          simNumber: simNumberContr.text,
                        );

                        //saving the user data to shared preferences
                        prefs.setString(user!.username, user!.jsonToString());

                        //showing the saved data in a snackbar
                        showToastmessage(
                            context, user!.username, user!.simNumber);
                      }
                    },
                  ),
                  SubmitButton(
                    buttonText: buttonText,
                    onButtonPressed: () {
                      // Validating the user input to the sim number field
                      setState(() {
                        if (user == null) {
                          buttonText = 'No user created';
                        } else {
                          buttonText = user!.username;
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

class SubmitButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onButtonPressed;

  const SubmitButton({
    Key? key,
    required this.buttonText,
    required this.onButtonPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onButtonPressed,
      child: Text(buttonText),
    );
  }
}
