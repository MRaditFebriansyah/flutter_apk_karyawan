import 'package:flutter/material.dart';
import 'screens/employee_list_screen.dart';

void main() {
  runApp(const PayrollApp());
}

class PayrollApp extends StatelessWidget {
  const PayrollApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sistem Penggajian Mobile',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      home: const EmployeeListScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
