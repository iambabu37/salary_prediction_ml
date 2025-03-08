import 'package:flutter/material.dart';
import 'package:salary_prediction_ml/pages/home_page.dart';
import 'package:salary_prediction_ml/pages/login_page.dart';
import 'package:salary_prediction_ml/pages/result.dart';
import 'package:salary_prediction_ml/pages/userlogin_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Salary Prediction App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white, // Light background color
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: const AppBarTheme(
          color: Colors.blue, // AppBar background color
          iconTheme: IconThemeData(color: Colors.white), // AppBar icon color
          titleTextStyle: TextStyle(
            color: Colors.white, // AppBar title text color
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        textTheme: const TextTheme(
          bodyLarge:
              TextStyle(color: Colors.black, fontSize: 16), // General body text
          bodyMedium: TextStyle(
              color: Colors.black87, fontSize: 14), // Secondary body text
          titleLarge: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold), // Headline text
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue, // Button background color
            foregroundColor: Colors.white, // Button text color
            textStyle: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold), // Button text style
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey,
          labelStyle: TextStyle(color: Colors.black), // Input label text color
          border:
              OutlineInputBorder(), // Add borders to input fields for better visibility
        ),
      ),
      home: const LoginPage(),
      routes: {
        '/login': (context) => LoginPage(),
        '/userlogin': (context) => UserLogin(),
        '/home': (context) => SalaryPredictionPage(),
        '/result': (context) => Result(),
      },
    );
  }
}
