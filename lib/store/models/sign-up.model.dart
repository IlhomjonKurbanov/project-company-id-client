import 'dart:io';

import 'package:dio/dio.dart';

class SignupModel {
  const SignupModel(
      {required this.avatar,
      required this.date,
      required this.token,
      required this.englishLevel,
      required this.github,
      required this.lastName,
      required this.name,
      required this.phone,
      required this.skype,
      required this.password,
      required this.slackId});
  final File avatar;
  final String github;
  final DateTime date;
  final String token;
  final String phone;
  final String lastName;
  final String name;
  final String skype;
  final String slackId;
  final String englishLevel;
  final String password;

  Future<FormData> toJson() async {
    final String fileName = avatar.path.split('/').last;
    return FormData.fromMap(<String, dynamic>{
      'avatar': await MultipartFile.fromFile(avatar.path, filename: fileName),
      'github': github,
      'dob': date,
      'token': token,
      'phone': phone,
      'lastName': lastName,
      'name': name,
      'skype': skype,
      'slackId': slackId,
      'englishLevel': englishLevel,
      'password': password
    });
  }
}
