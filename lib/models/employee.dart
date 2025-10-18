class Employee {
  int id; // sekarang wajib diisi pengguna
  String name;
  String position;
  double baseSalary;
  double allowance;
  double deduction;

  Employee({
    required this.id,
    required this.name,
    required this.position,
    required this.baseSalary,
    required this.allowance,
    required this.deduction,
  });

  double get totalSalary => baseSalary + allowance - deduction;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'position': position,
      'baseSalary': baseSalary,
      'allowance': allowance,
      'deduction': deduction,
    };
  }

  factory Employee.fromMap(Map<String, dynamic> map) {
    return Employee(
      id: map['id'],
      name: map['name'],
      position: map['position'],
      baseSalary: map['baseSalary'],
      allowance: map['allowance'],
      deduction: map['deduction'],
    );
  }
}
