import 'package:flutter/material.dart';
import '../models/employee.dart';
import '../db/db_helper.dart';

class EmployeeFormScreen extends StatefulWidget {
  final Employee? employee;
  const EmployeeFormScreen({super.key, this.employee});

  @override
  State<EmployeeFormScreen> createState() => _EmployeeFormScreenState();
}

class _EmployeeFormScreenState extends State<EmployeeFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final dbHelper = DBHelper();

  late TextEditingController nameController;
  late TextEditingController positionController;
  late TextEditingController baseSalaryController;
  late TextEditingController allowanceController;
  late TextEditingController deductionController;

  bool get isEdit => widget.employee != null;

  @override
  void initState() {
    super.initState();
    nameController =
        TextEditingController(text: widget.employee?.name ?? '');
    positionController =
        TextEditingController(text: widget.employee?.position ?? '');
    baseSalaryController = TextEditingController(
        text: widget.employee?.baseSalary.toString() ?? '');
    allowanceController = TextEditingController(
        text: widget.employee?.allowance.toString() ?? '');
    deductionController = TextEditingController(
        text: widget.employee?.deduction.toString() ?? '');
  }

  void _saveEmployee() async {
    if (_formKey.currentState!.validate()) {
      final emp = Employee(
        id: widget.employee?.id,
        name: nameController.text,
        position: positionController.text,
        baseSalary: double.parse(baseSalaryController.text),
        allowance: double.parse(allowanceController.text),
        deduction: double.parse(deductionController.text),
      );
      if (isEdit) {
        await dbHelper.updateEmployee(emp);
      } else {
        await dbHelper.insertEmployee(emp);
      }
      if (mounted) Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Karyawan' : 'Tambah Karyawan')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(nameController, 'Nama Karyawan'),
              _buildTextField(positionController, 'Jabatan'),
              _buildTextField(baseSalaryController, 'Gaji Pokok', number: true),
              _buildTextField(allowanceController, 'Tunjangan', number: true),
              _buildTextField(deductionController, 'Potongan', number: true),
              const SizedBox(height: 20),
              ElevatedButton(
              style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue, 
              foregroundColor: Colors.white, 
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                onPressed: _saveEmployee,
                child: const Text(
                  "Simpan",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {bool number = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: number ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Field tidak boleh kosong';
          }
          return null;
        },
      ),
    );
  }
}
