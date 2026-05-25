import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'signup_screen.dart';

/// Shown when no user is logged in.
/// Toggles between LoginScreen and SignUpScreen.
class Authenticate extends StatefulWidget {
  const Authenticate({Key? key}) : super(key: key);

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool _showLogin = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── Brand header ─────────────────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 32),
              decoration: const BoxDecoration(
                color: Color(0xFF1A4A2E),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: const Color(0xFF6EE89E),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Icon(Icons.construction_rounded,
                        size: 40, color: Color(0xFF1A4A2E)),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'LabourConnect',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.5),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Find work. Find workers. Fast.',
                    style:
                        TextStyle(color: Colors.white60, fontSize: 13),
                  ),
                ],
              ),
            ),

            // ── Auth form ─────────────────────────────────────────────────────
            Expanded(
              child: _showLogin
                  ? LoginScreen(
                      showSignUp: () =>
                          setState(() => _showLogin = false),
                    )
                  : SignUpScreen(
                      showLogin: () =>
                          setState(() => _showLogin = true),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
