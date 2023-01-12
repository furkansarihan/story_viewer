import 'package:flutter/material.dart';

class UserModel {
  const UserModel({
    required this.username,
    required this.profilePicture,
  });
  final String username;
  final ImageProvider profilePicture;
}
