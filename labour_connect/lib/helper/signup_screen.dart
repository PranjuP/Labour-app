import 'package:flutter/material.dart';
import '../../services/auth.dart';
import '../../services/database.dart';
import '../../helper/helperfunctions.dart';
import '../screens/home_screen.dart';

class SignUpScreen extends StatefulWidget {
  final VoidCallback showLogin;
  const SignUpScreen({Key? key, required this.showLogin}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _auth = AuthMethods();
  final _db = DatabaseMethods();

  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _loading = false;
  bool _obscurePass = true;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    final user = await _auth.signUpWithEmailAndPassword(
        _emailCtrl.text.trim(), _passCtrl.text.trim());

    if (user != null) {
      // Save user details to Firestore
      final userData = {
        'name': _nameCtrl.text.trim(),
        'email': _emailCtrl.text.trim(),
        'uid': user.uid,
      };
      await _db.addUserInfo(userData, user.uid);

      // Persist login state
      await HelperFunctions.saveUserLoggedIn(true);
      await HelperFunctions.saveUserID(user.uid);
      await HelperFunctions.saveUserName(_nameCtrl.text.trim());
      await HelperFunctions.saveUserEmail(_emailCtrl.text.trim());

      if (!mounted) return;
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()));
    } else {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Registration failed. Email may already be in use.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(28),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const Text('Create account',
                      style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A4A2E))),
                  const SizedBox(height: 6),
                  Text('Join the Labour Connect platform',
                      style: TextStyle(
                          fontSize: 14, color: Colors.grey.shade600)),
                  const SizedBox(height: 32),

                  // Full name
                  TextFormField(
                    controller: _nameCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Full name',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    validator: (v) =>
                        (v == null || v.trim().length < 2)
                            ? 'Enter your full name'
                            : null,
                  ),
                  const SizedBox(height: 16),

                  // Email
                  TextFormField(
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email address',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    validator: (v) =>
                        (v == null || !v.contains('@'))
                            ? 'Enter a valid email'
                            : null,
                  ),
                  const SizedBox(height: 16),

                  // Password
                  TextFormField(
                    controller: _passCtrl,
                    obscureText: _obscurePass,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePass
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined),
                        onPressed: () =>
                            setState(() => _obscurePass = !_obscurePass),
                      ),
                    ),
                    validator: (v) =>
                        (v == null || v.length < 6)
                            ? 'Min 6 characters'
                            : null,
                  ),
                  const SizedBox(height: 28),

                  // Sign up button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _signUp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1A4A2E),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        elevation: 0,
                      ),
                      child: const Text('Create Account',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.white)),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Switch to login
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Already have an account? ',
                          style: TextStyle(color: Colors.grey.shade600)),
                      GestureDetector(
                        onTap: widget.showLogin,
                        child: const Text('Login',
                            style: TextStyle(
                                color: Color(0xFF1A4A2E),
                                fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
  }
}
