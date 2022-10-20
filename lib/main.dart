import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:takingnoteapp/screens/login_view.dart';
import 'package:takingnoteapp/screens/register_View.dart';

import 'firebase_options.dart';
import 'screens/email_verification_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: const HomePage(),
    routes: {
      '/register/': (context) => const RegisterView(),
      '/login/': (context) => const LoginView(),
      '/noteview/': (context) => const NoteView(),
    },
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final currentUser = FirebaseAuth.instance.currentUser;
            final emailVerified = currentUser?.emailVerified ?? false;
            if (currentUser == null) {
              return const LoginView();
            } else {
              if (emailVerified) {
                return const NoteView();
              } else {
                return const VerifyEmailView();
              }
            }

          default:
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
        }
      },
    );
  }
}

class NoteView extends StatefulWidget {
  const NoteView({super.key});

  @override
  State<NoteView> createState() => _NoteViewState();
}

enum MenuItems {
  logout,
}

class _NoteViewState extends State<NoteView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main UI'),
        actions: [
          PopupMenuButton<MenuItems>(
            itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuItems>(
                  value: MenuItems.logout,
                  child: Text('Log Out'),
                ),
              ];
            },
            onSelected: (value) async {
              switch (value) {
                case MenuItems.logout:
                  final shouldLogout = await showLogOutDialog(context);
                  if (shouldLogout == true) {
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil('/login/', (route) => false);
                  }
                  break;
              }
            },
          ),
        ],
      ),
    );
  }
}

Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text('Sign Out'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text('Cancel'),
          )
        ],
      );
    },
  ).then((value) => value ?? false);
}
