import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Email')),
      body: Column(
        children: [
          const Text('Click Below to verify email address'),
          TextButton(
            onPressed: () async {
              final currentUser = FirebaseAuth.instance.currentUser;
              await currentUser?.sendEmailVerification();
            },
            child: const Text('Send Email Verification Link'),
          )
        ],
      ),
    );
  }
}
