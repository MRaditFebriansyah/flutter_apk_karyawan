class Employee {
  int? id;
  String name;
  String position;
  double baseSalary;
  double allowance;
  double deduction;
  double totalSalary;

  Employee({
    this.id,
    required this.name,
    required this.position,
    required this.baseSalary,
    required this.allowance,
    required this.deduction,
  }) : totalSalary = baseSalary + allowance - deduction;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'position': position,
      'baseSalary': baseSalary,
      'allowance': allowance,
      'deduction': deduction,
      'totalSalary': totalSalary,
    };
  }

  factory Employee.fromMap(Map<String, dynamic> map) {
    return Employee(
      id: map['id'],
      name: map['name'],
      position: map['position'],
      baseSalary: (map['baseSalary'] as num).toDouble(),
      allowance: (map['allowance'] as num).toDouble(),
      deduction: (map['deduction'] as num).toDouble(),
    );
  }
}
