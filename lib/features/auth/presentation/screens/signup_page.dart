import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../onboarding/data/onboarding_repository.dart';
import 'otp_screen.dart';
import 'validators.dart';
import 'login_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final formKey = GlobalKey<FormState>();
  late bool _isHidden = true;
  bool _isLoading = false;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();

  Future<void> _signUp() async {
    if (!formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse('https://accessories-eshop.runasp.net/api/auth/register');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': emailController.text.trim(),
          'password': passController.text,
          'firstName': firstNameController.text.trim(),
          'lastName': lastNameController.text.trim(),
        }),
      );

      debugPrint("Status Code: ${response.statusCode}");
      debugPrint("Response Body: ${response.body}");

      if (response.statusCode >= 200 && response.statusCode < 300) {
        // إعادة تعيين Onboarding بـ false لضمان توجيه المستخدم الجديد للـ Onboarding بعد الـ Login
        final prefs = await SharedPreferences.getInstance();
        final onboardingRepo = OnboardingRepository(prefs);
        await onboardingRepo.setOnboardingCompleted(false);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "Registration Successful, an OTP has been sent to your email.",
              ),
              backgroundColor: Colors.green,
            ),
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => OtpScreen(
                email: emailController.text.trim(),
              ),
            ),
          );
        }
      } else {
        String errorMessage = 'Registration failed (${response.statusCode})';
        try {
          final errorData = jsonDecode(response.body);
          if (errorData is Map && errorData.containsKey('message')) {
            errorMessage = errorData['message'];
          } else if (errorData is String) {
            errorMessage = errorData;
          }
        } catch (_) {
          errorMessage = response.body.isNotEmpty ? response.body : errorMessage;
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occurred: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    confirmPassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double strength = Validators.getPasswordStrength(passController.text);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "NOVA",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 45),
                  ),
                  const Text(
                    "Create your NOVA \naccount.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                  Text(
                    "Let's make shopping feel more like \nyou.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[800], fontSize: 16),
                  ),
                  const SizedBox(height: 5),
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        Container(
                          color: Colors.white,
                          child: TextFormField(
                            validator: Validators.validateFirstName,
                            controller: firstNameController,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              labelText: "  First Name",
                              hintText: "  Enter your First Name",
                              border: InputBorder.none,
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(vertical: 5),
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          color: Colors.white,
                          child: TextFormField(
                            validator: Validators.validateLastName,
                            controller: lastNameController,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              labelText: "  Last Name",
                              hintText: "  Enter your Last Name",
                              border: InputBorder.none,
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(vertical: 5),
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          color: Colors.white,
                          child: TextFormField(
                            validator: Validators.validateEmail,
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              labelText: "  Email Address",
                              hintText: "  Enter your Email Address",
                              border: InputBorder.none,
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(vertical: 5),
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          color: Colors.white,
                          child: TextFormField(
                            validator: Validators.validatePassword,
                            controller: passController,
                            obscureText: _isHidden,
                            keyboardType: TextInputType.visiblePassword,
                            onChanged: (value) {
                              setState(() {});
                            },
                            decoration: InputDecoration(
                              labelText: "  Password",
                              hintText: "  Enter password",
                              border: InputBorder.none,
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(vertical: 5),
                              suffixIcon: IconButton(
                                icon: _isHidden
                                    ? const Icon(Icons.visibility_off_outlined)
                                    : const Icon(Icons.visibility_outlined),
                                onPressed: () {
                                  setState(() {
                                    _isHidden = !_isHidden;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Password Strength",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 13,
                                    ),
                                  ),
                                  Text(
                                    passController.text.isEmpty
                                        ? "Min 8 chars"
                                        : Validators.getStrengthText(strength),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      color: passController.text.isEmpty
                                          ? Colors.grey
                                          : Validators.getStrengthColor(strength),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 3),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: LinearProgressIndicator(
                                  value: strength,
                                  backgroundColor: Colors.grey[300],
                                  color: Validators.getStrengthColor(strength),
                                  minHeight: 5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          color: Colors.white,
                          child: TextFormField(
                            validator: (value) => Validators.validateConfirmPassword(
                              value,
                              passController.text,
                            ),
                            controller: confirmPassController,
                            obscureText: _isHidden,
                            keyboardType: TextInputType.visiblePassword,
                            decoration: InputDecoration(
                              labelText: "  Confirm Password",
                              hintText: "  Enter password again",
                              border: InputBorder.none,
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(vertical: 5),
                              suffixIcon: IconButton(
                                icon: _isHidden
                                    ? const Icon(Icons.visibility_off_outlined)
                                    : const Icon(Icons.visibility_outlined),
                                onPressed: () {
                                  setState(() {
                                    _isHidden = !_isHidden;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            backgroundColor: Colors.black,
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          onPressed: _isLoading ? null : _signUp,
                          child: _isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Center(
                            child: Text(
                              "Create Account",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Row(
                    children: [
                      Expanded(child: Divider()),
                      SizedBox(width: 15),
                      Text("OR", style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(width: 15),
                      Expanded(child: Divider()),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      backgroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/images/google.png",
                            width: 20,
                            height: 20,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(width: 15),
                          const Text(
                            "CONTINUE WITH GOOGLE",
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account? ",
                        style: TextStyle(color: Colors.grey[800], fontSize: 16),
                      ),
                      GestureDetector(
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                          );
                        },
                        child: const Text(
                          "Sign IN",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}