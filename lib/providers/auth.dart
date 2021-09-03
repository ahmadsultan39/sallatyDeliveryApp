import 'dart:convert';

import 'package:flutter/foundation.dart';
import '../models/http_exception.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  String id;
  String name;
  String email;
  String number;
  String _token;
  final mainUrl = 'https://sallaty-store.herokuapp.com';

  Future<bool> isAuth() async {
    if (token == null) {
      return await tryAutoLogin();
    } else {
      return await validToken();
    }
  }

  String get token {
    return _token;
  }

  Future<void> signInWithNumber(
    String number,
    String password,
  ) async {
    final url =
        Uri.parse('https://hamdi1234.herokuapp.com/users/loginbynumber');
    final response = await http.post(url,
        headers: {
          'usertype': 'vendor',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode({
          "number": number,
          "password": password,
        }));

    final responseData = json.decode(response.body);
    if (response.statusCode != 200) throw HttpException(responseData);
    id = responseData['_id'];
    name = responseData['name'];
    number = responseData['number'];
    _token = responseData['tokens'][0]['token'];
    saveToken();
    notifyListeners();
  }

  Future<void> signInWithEmail(
    String useremail,
    String password,
  ) async {
    final url = Uri.parse('$mainUrl/delivaryUser/login');
  final response = await http.post(
      url,
      headers: {
        'usertype': 'vendor',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode({
        'email': useremail,
        'password': password,
      }),
    );
    final responseData = json.decode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      id = responseData['_id'];
      name = responseData['name'];
      number = responseData['number'];
      _token = response.headers['authorization'];
      saveToken();
      notifyListeners();
    } else
      throw HttpException(responseData);
  }

  void saveToken() async {
    final pref = await SharedPreferences.getInstance();
    pref.setString(
        'userData',
        json.encode({
          'token': token,
          'userId': id,
          'username': name,
          'number': number,
        }));
  }

  Future<bool> tryAutoLogin() async {
    final pref = await SharedPreferences.getInstance();
    if (!pref.containsKey('userData')) return false;

    final extractedData =
        json.decode(pref.getString('userData')) as Map<String, Object>;
    _token = extractedData['token'];
    id = extractedData['userId'];
    name = extractedData['username'];
    number = extractedData['number'];

    //Checks whether the user's session token is valid
    return await validToken();
  }

  Future<bool> validToken() async {
    final url = Uri.parse('$mainUrl/users/checkAccessiblity');
    final response = await http.post(
      url,
      headers: {
        'usertype': 'vendor',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode({"token": token}),
    );
    if (response.statusCode == 200 || response.statusCode == 201) return true;
    await logout();
    return false;
  }

  Future<void> logout() async {
    _token = null;
    id = null;
    name = null;
    number = null;
    final pref = await SharedPreferences.getInstance();
    pref.clear();
    notifyListeners();
    // http logout
  }
}
