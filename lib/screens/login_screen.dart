import 'package:flutter/material.dart';
import 'package:testbdgtt/screens/sign_up.dart';
import 'package:testbdgtt/services/auth_service.dart';
import 'package:testbdgtt/ultis/appvalidator.dart';

class LoginView extends StatefulWidget {
  LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  var isLoader = false;
  var authService = AuthService();
  var appValidator = AppValidator();

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoader = true;
      });

      var data = {
        "email": _emailController.text,
        "password": _passwordController.text,
      };
      await authService.login(data, context);

      setState(() {
        isLoader = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF252634),
      body: SingleChildScrollView( // To allow scrolling when keyboard is open
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 50.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 50),
                _buildHeader(),
                SizedBox(height: 50),
                _buildTextField(
                  label: 'Email',
                  controller: _emailController,
                  validator: appValidator.validateEmail,
                  keyboardType: TextInputType.emailAddress,
                  icon: Icons.email,
                ),
                SizedBox(height: 20),
                _buildTextField(
                  label: 'Password',
                  controller: _passwordController,
                  validator: appValidator.validatePassword,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                  icon: Icons.lock,
                ),
                SizedBox(height: 40),
                _buildLoginButton(),
                SizedBox(height: 30),
                _buildCreateAccountLink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Text(
          "Welcome Back!",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Text(
          "Login to your account",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: TextStyle(color: Colors.white),
      decoration: _buildInputDecoration(label, icon),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validator,
    );
  }

  InputDecoration _buildInputDecoration(String label, IconData suffixIcon) {
    return InputDecoration(
      fillColor: Color(0xAA494A59),
      filled: true,
      labelText: label,
      labelStyle: TextStyle(color: Color(0xFF949494)),
      suffixIcon: Icon(suffixIcon, color: Color(0xFF949494)),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFF6C6F80)),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.orange),
        borderRadius: BorderRadius.circular(12),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          shadowColor: Colors.orangeAccent,
          elevation: 5,
        ),
        onPressed: isLoader ? null : _submitForm,
        child: isLoader
            ? Center(child: CircularProgressIndicator(color: Colors.white))
            : Text(
                'Login',
                style: TextStyle(fontSize: 18),
              ),
      ),
    );
  }

  Widget _buildCreateAccountLink() {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SignUpView()),
        );
      },
      child: Text(
        "Create New Account",
        style: TextStyle(
          color: Colors.orange,
          fontSize: 16,
        ),
      ),
    );
  }
}
