import 'dart:convert';

class UserData {
  String username;
  String simNumber;
  String password;

  UserData(
      {required this.username,
      required this.simNumber,
      required this.password});

  Map<String, String> toJson() {
    Map<String, String> userData = {
      'username': username,
      'simNumber': simNumber,
      'password': password
    };
    return userData;
  }

  String jsonToString() {
    Map<String, String> userData = {
      'username': username,
      'simNumber': simNumber,
      'password': password
    };
    return jsonEncode(userData);
  }
}
