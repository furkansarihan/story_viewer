import 'package:flutter/material.dart';

class UserModel {
  final String id;
  final String username;
  final ImageProvider profilePicture;
  const UserModel({
    this.id = '',
    this.username = '',
    this.profilePicture,
  });
}
