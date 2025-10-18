import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../db/db_helper.dart';
import '../models/employee.dart';
import 'employee_form_screen.dart';
import 'employee_detail_screen.dart';

class EmployeeListScreen extends StatefulWidget {
  const EmployeeListScreen({super.key});

  @override
  State<EmployeeListScreen> createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  final dbHelper = DBHelper();
  late Future<List<Employee>> employees;

  @override
  void initState() {
    super.initState();
    refreshEmployees();
  }

  void refreshEmployees() {
    setState(() {
      employees = dbHelper.getEmployees();
    });
  }

  void _deleteEmployee(int id) async {
    await dbHelper.deleteEmployee(id);
    refreshEmployees();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sistem Penggajian Mobile')),
      body: FutureBuilder<List<Employee>>(
        future: employees,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
                child: Text('Belum ada data karyawan.',
                    style: TextStyle(fontSize: 16)));
          }
          final data = snapshot.data!;
          final format = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');
          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final emp = data[index];
              return Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  title: Text(emp.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  subtitle: Text(emp.position),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(format.format(emp.totalSalary),
                          style: const TextStyle(color: Colors.indigo)),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Hapus Karyawan'),
                              content:
                                  Text('Yakin ingin menghapus ${emp.name}?'),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: const Text('Batal'),
                                ),
                                ElevatedButton(
                                  onPressed: () =>
                                      Navigator.pop(context, true),
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red),
                                  child: const Text('Hapus'),
                                ),
                              ],
                            ),
                          );

                          if (confirm == true) {
                            _deleteEmployee(emp.id!);
                          }
                        },
                      ),
                    ],
                  ),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EmployeeDetailScreen(employee: emp),
                      ),
                    );
                    refreshEmployees();
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const EmployeeFormScreen()),
          );
          refreshEmployees();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
