import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: TextBox(),
    );
  }
}

class TextBox extends StatefulWidget {
  const TextBox({super.key});

  @override
  State<TextBox> createState() => _TextBoxState();
}

class _TextBoxState extends State<TextBox> {
  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double objectWidth = screenWidth * 0.75;
    return Scaffold(
        appBar: AppBar(
          title: const Text('G10A'),
        ),
        body: Center(
            child: SizedBox(
          width: objectWidth,
          child: Column(
            children: [
              TextField(
                controller: myController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter the sim number',
                ),
              ),
              const SubmitButton()
            ],
          ),
        )));
  }
}

class SubmitButton extends StatefulWidget {
  const SubmitButton({super.key});

  @override
  State<SubmitButton> createState() => _SubmitButtonState();
}

class _SubmitButtonState extends State<SubmitButton> {
  bool isClicked = false;
  String buttonText = 'Clicked';
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          setState(() {
            isClicked = !isClicked;
            if (isClicked) {
              buttonText = 'Not Clicked';
            } else {
              buttonText = 'Clicked';
            }
          });
        },
        child: Text(buttonText));
  }
}
