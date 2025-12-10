import 'package:bloc/bloc.dart';
import 'UserState.dart';
import 'package:flutter/material.dart';

class UserLogic extends Cubit<UserState> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  final TextEditingController confirmPasswordController = TextEditingController();

  String? selectedGender;
  UserLogic():super(InitUser());
}