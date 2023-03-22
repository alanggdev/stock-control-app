import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

Future<void> signInUsername(BuildContext context, String username, String password) async {
  Dio dio = new Dio();
  Map<String, dynamic> data = {"username": username, "password": password};

  Map<String, dynamic> headers = {"Content-Type": "application/json"};

  print(data);
  // Response response = await dio.post(
  //   'https://miapp.com/auth/login/',
  //   data: data,
  //   options: Options(headers: headers),
  // );
}
