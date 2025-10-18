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
  final _dbHelper = DBHelper();

  final _idController = TextEditingController();
  final _nameController = TextEditingController();
  final _positionController = TextEditingController();
  final _baseController = TextEditingController();
  final _allowanceController = TextEditingController();
  final _deductionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.employee != null) {
      _idController.text = widget.employee!.id.toString();
      _nameController.text = widget.employee!.name;
      _positionController.text = widget.employee!.position;
      _baseController.text = widget.employee!.baseSalary.toString();
      _allowanceController.text = widget.employee!.allowance.toString();
      _deductionController.text = widget.employee!.deduction.toString();
    }
  }

  @override
  void dispose() {
    _idController.dispose();
    _nameController.dispose();
    _positionController.dispose();
    _baseController.dispose();
    _allowanceController.dispose();
    _deductionController.dispose();
    super.dispose();
  }

  void _saveEmployee() async {
    if (_formKey.currentState!.validate()) {
      final emp = Employee(
        id: int.parse(_idController.text),
        name: _nameController.text,
        position: _positionController.text,
        baseSalary: double.parse(_baseController.text),
        allowance: double.parse(_allowanceController.text),
        deduction: double.parse(_deductionController.text),
      );

      if (widget.employee == null) {
        await _dbHelper.insertEmployee(emp);
      } else {
        await _dbHelper.updateEmployee(emp);
      }

      if (context.mounted) Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.employee == null ? 'Tambah Karyawan' : 'Edit Karyawan')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _idController,
                decoration: const InputDecoration(labelText: 'ID Karyawan'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value == null || value.isEmpty ? 'ID wajib diisi' : null,
              ),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nama'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Nama wajib diisi' : null,
              ),
              TextFormField(
                controller: _positionController,
                decoration: const InputDecoration(labelText: 'Jabatan'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Jabatan wajib diisi' : null,
              ),
              TextFormField(
                controller: _baseController,
                decoration: const InputDecoration(labelText: 'Gaji Pokok'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Gaji Pokok wajib diisi' : null,
              ),
              TextFormField(
                controller: _allowanceController,
                decoration: const InputDecoration(labelText: 'Tunjangan'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _deductionController,
                decoration: const InputDecoration(labelText: 'Potongan'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveEmployee,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('Simpan Data', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
