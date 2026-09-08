import 'package:flutter/material.dart';

class Validators {

  // First Name
  static String? validateFirstName(String? value) {
  if (value == null || value.trim().isEmpty) {
  return 'Please enter your first name';
  }
  if (value.trim().length < 2) {
  return 'First name must be at least 2 characters';
  }
  return null;
  }

  // Last Name
  static String? validateLastName(String? value) {
  if (value == null || value.trim().isEmpty) {
  return 'Please enter your last name';
  }
  if (value.trim().length < 2) {
  return 'Last name must be at least 2 characters';
  }
  return null;
  }


  // Email
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your email address';
    }

    final emailRegExp = RegExp(
      r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
    );

    if (!emailRegExp.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  // Password
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }

    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }

    final hasLetter = value.contains(RegExp(r'[a-zA-Z]'));
    final hasDigits = value.contains(RegExp(r'[0-9]'));

    if (!hasLetter || !hasDigits) {
      return 'Password must contain both letters and numbers';
    }

    return null;
  }

  // Confirm Password
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }


  //Pass Strength
  static double getPasswordStrength(String password) {
  if (password.isEmpty) return 0.0;

  double strength = 0.0;


  if (password.length >= 8) strength += 0.25;


  if (password.contains(RegExp(r'[a-z]')) && password.contains(RegExp(r'[A-Z]'))) {
  strength += 0.25;
  }


  if (password.contains(RegExp(r'[0-9]'))) strength += 0.25;


  if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength += 0.25;

  return strength;
  }


  static String getStrengthText(double strength) {
  if (strength <= 0.25) return 'Weak';
  if (strength <= 0.5) return 'Medium';
  if (strength <= 0.75) return 'Good';
  return 'Strong';
  }


  static Color getStrengthColor(double strength) {
  if (strength <= 0.25) return Colors.red;
  if (strength <= 0.5) return Colors.orange;
  if (strength <= 0.75) return Colors.blue;
  return Colors.green;
  }
}