import 'package:flutter/material.dart';
import 'package:testbdgtt/screens/login_screen.dart';
import 'package:testbdgtt/services/auth_service.dart';
import 'package:testbdgtt/ultis/appvalidator.dart';

class SignUpView extends StatefulWidget {
  SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _userNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  var authService = AuthService();
  var isLoader = false;

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoader = true;
      });

      try {
        var data = {
          "username": _userNameController.text,
          "email": _emailController.text,
          "password": _passwordController.text,
          "phone": _phoneController.text,
          'remainingAmount': 0,
          'totalCredit': 0,
          'toatlDebit': 0,
        };

        // Attempt to create the user
        await authService.createUser(data, context);

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Account created successfully")),
        );
      } catch (e) {
        // Handle the error, show an error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to create account. Please try again.")),
        );
      } finally {
        setState(() {
          isLoader = false;
        });
      }
    }
  }

  var appValidator = AppValidator();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF252634),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 80),  // Adjust height for better spacing
            // Heading
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Create New Account",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Username
                    _buildTextField(
                      controller: _userNameController,
                      label: "Username",
                      icon: Icons.person,
                      validator: appValidator.validateUsername,
                    ),
                    SizedBox(height: 20),
                    // Email
                    _buildTextField(
                      controller: _emailController,
                      label: "Email",
                      icon: Icons.email,
                      validator: appValidator.validateEmail,
                    ),
                    SizedBox(height: 20),
                    // Phone
                    _buildTextField(
                      controller: _phoneController,
                      label: "Phone Number",
                      icon: Icons.call,
                      validator: appValidator.validatePhoneNumber,
                    ),
                    SizedBox(height: 20),
                    // Password
                    _buildTextField(
                      controller: _passwordController,
                      label: "Password",
                      icon: Icons.lock,
                      obscureText: true,
                      validator: appValidator.validatePassword,
                    ),
                    SizedBox(height: 40),
                    // Create Account Button
                    SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFB8C2B),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: isLoader ? null : _submitForm,
                        child: isLoader
                            ? Center(child: CircularProgressIndicator(color: Colors.white))
                            : Text(
                                "Create Account",
                                style: TextStyle(fontSize: 20),
                              ),
                      ),
                    ),
                    SizedBox(height: 20),
                    // Login Button
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginView()),
                        );
                      },
                      child: Text(
                        "Already have an account? Log in",
                        style: TextStyle(
                          color: Color(0xFFFB8C2B),
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build text fields with uniform styling
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String? Function(String?) validator,
    bool obscureText = false,
  }) {
    return TextFormField(
      controller: controller,
      style: TextStyle(color: Colors.white),
      obscureText: obscureText,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        fillColor: Color(0xAA494A59),
        filled: true,
        labelText: label,
        labelStyle: TextStyle(color: Color(0xFF949494)),
        suffixIcon: Icon(icon, color: Color(0xFF949494)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Color(0xFF949494)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Color(0xFFFB8C2B)),
        ),
      ),
      validator: validator,
    );
  }
}
