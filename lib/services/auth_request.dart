import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:stock_control/screens/list_screen.dart';

String baseURL = 'http://3.22.66.38';

Future<void> signInUsername(
    BuildContext context, String username, String password) async {
  Dio dio = Dio();
  var data = {"username": username, "password": password};
  await dio
      .post(
    '$baseURL/auth/login/',
    options:
        Options(headers: {HttpHeaders.contentTypeHeader: "application/json"}),
    data: jsonEncode(data),
  )
      .then(((response) async {
    dynamic userData = jsonDecode(response.toString());
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('localUserData', jsonEncode(userData));
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => ListScreen(userData['user'],
                userData['access_token'], userData['refresh_token'])));
  })).catchError(((e) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Error',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          // ignore: prefer_const_constructors
          content: Text('Verifique sus credenciales'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Ok'),
            ),
          ],
        );
      },
    );
  }));
}

Future<void> signUpUsername(
    BuildContext context, String username, String email, String password, String confirmPassword) async {
  Dio dio = Dio();
  var data = {
    "username": username,
    "email": email,
    "password1": password,
    "password2": confirmPassword
};
  await dio
      .post(
    '$baseURL/auth/register/',
    options:
        Options(headers: {HttpHeaders.contentTypeHeader: "application/json"}),
    data: jsonEncode(data),
  )
      .then(((response) async {
        showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Registrado',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          // ignore: prefer_const_constructors
          content: Text('Inicia sesión para continuar'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pushReplacementNamed(context, '/sign_in'),
              child: const Text('Ok'),
            ),
          ],
        );
      },
    );
  })).catchError(((e) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Error',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          // ignore: prefer_const_constructors
          content: Text(e.toString()),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Ok'),
            ),
          ],
        );
      },
    );
  }));
}

Future<void> signOut(BuildContext context, String accessToken) async {
  Dio dio = Dio();
  var data = {};
  await dio
      .post(
    '$baseURL/auth/logout/',
    options: Options(headers: {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer $accessToken"
    }),
    data: jsonEncode(data),
  )
      .then(((response) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('localUserData');
    Navigator.pushReplacementNamed(context, '/auth_scren');
  })).catchError(((e) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Error',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          // ignore: prefer_const_constructors
          content: Text(e.toString()),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Ok'),
            ),
          ],
        );
      },
    );
  }));
}
