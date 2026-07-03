import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:new_app_mine/view/home_screen.dart';
import 'package:new_app_mine/view/login_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'firebase_options.dart';
import 'services/auth_service.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  await Supabase.initialize(
    url: 'https://wythhkznirkacxzjzoio.supabase.co/rest/v1/',  // Replace with your URL
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Ind5dGhoa3puaXJrYWN4emp6b2lvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODMwNTQzNTUsImV4cCI6MjA5ODYzMDM1NX0.pVgICwIG3l-RZiEvVaaDv3RXB2sK9HG02_ta8Q49fTE',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Photo Vault',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const AuthWrapper(),
    );
  }
}


// Handle auth state changes
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading...'),
                ],
              ),
            ),
          );
        }

        final session = snapshot.data?.session;

        if (session != null) {
          return HomeScreen();
        }
        return const LoginScreen();
      },
    );
  }
}