import 'dart:convert';

class UserData {
  String username;
  String simNumber;

  UserData({required this.username, required this.simNumber});

  Map<String, String> toJson() {
    Map<String, String> userData = {
      'username': username,
      'simNumber': simNumber,
    };
    return userData;
  }

  String jsonToString() {
    Map<String, String> userData = {
      'username': username,
      'simNumber': simNumber,
    };
    return jsonEncode(userData);
  }
}
