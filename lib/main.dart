import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fridge_app/screens/admin/admin_screen.dart';
import 'package:fridge_app/screens/fridge/fridge_screen.dart';
import 'package:fridge_app/screens/splash_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import './screens/auth/welcome_page.dart';
import 'helpers/firebase_notification_handler.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return MaterialApp(
      title: 'Fridge App',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        accentColor: Colors.purpleAccent,
        canvasColor: Color.fromRGBO(254, 254, 229, 1),
        textTheme: GoogleFonts.latoTextTheme(textTheme).copyWith(
          bodyText1: GoogleFonts.montserrat(textStyle: textTheme.bodyText1),
          headline1: TextStyle(
            fontSize: 20,
            fontFamily: 'RobotoCondensed',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return SplashScreen();
          }
          if (userSnapshot.data != null) {
            if (userSnapshot.data.email == 'admin@admin.com') {
              return AdminScreen();
            }
            return FridgeScreen();
          }
          return WelcomePage();
        },
      ),
    );
  }
}

Future<void> _backgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handle background Service $message');
  dynamic data = message.data['data'];
  FirebaseNotifications.showNotification(data['title'], data['body']);
}
