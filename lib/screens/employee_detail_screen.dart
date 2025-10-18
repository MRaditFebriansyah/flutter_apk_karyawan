import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/employee.dart';
import '../db/db_helper.dart';
import 'employee_form_screen.dart';

class EmployeeDetailScreen extends StatelessWidget {
  final Employee employee;
  const EmployeeDetailScreen({super.key, required this.employee});

  @override
  Widget build(BuildContext context) {
    final format = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');
    final dbHelper = DBHelper();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Karyawan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Edit Data',
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EmployeeFormScreen(employee: employee),
                ),
              );
              Navigator.pop(context, true);
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'Hapus Data',
            onPressed: () async {
              final confirm = await showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Konfirmasi'),
                  content:
                      const Text('Yakin ingin menghapus data karyawan ini?'),
                  actions: [
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.grey[700], // teks Batal abu gelap
                      ),
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Batal'),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red, // teks Hapus merah jelas
                      ),
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Hapus'),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                await dbHelper.deleteEmployee(employee.id!);
                if (context.mounted) Navigator.pop(context, true);
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 3,
          shadowColor: Colors.grey[400],
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRow('Nama', employee.name),
                _buildRow('Jabatan', employee.position),
                _buildRow('Gaji Pokok', format.format(employee.baseSalary)),
                _buildRow('Tunjangan', format.format(employee.allowance)),
                _buildRow('Potongan', format.format(employee.deduction)),
                const Divider(thickness: 1),
                _buildRow('Total Gaji', format.format(employee.totalSalary),
                    bold: true),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: bold ? FontWeight.bold : FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: bold ? FontWeight.bold : FontWeight.w400,
              color: bold ? Colors.blue[800] : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
