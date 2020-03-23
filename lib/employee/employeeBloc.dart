import 'dart:async';

import 'package:bloc_pattern/employee/employee.dart';
class EmployeeBloc {
  List<Employee> _employeesList = [
    Employee(1, "Edward", 100),
    Employee(2, "Natalia", 100),
    Employee(3, "Drako", 100),
    Employee(4, "Kira", 100),
  ];
  //Streams Controllers
  final _employeeListStreamController = StreamController<List<Employee>>();
  final _employeeIncrementSalaryController = StreamController<Employee>();
  final _employeeDecrementSalaryController = StreamController<Employee>();

  Stream<List<Employee>> get employeeListStream =>
      _employeeListStreamController.stream;
  StreamSink<List<Employee>> get employeeListSink =>
      _employeeListStreamController.sink;

  StreamSink<Employee> get employeeIncrement =>
      _employeeIncrementSalaryController.sink;

  StreamSink<Employee> get employeeDecremet =>
      _employeeDecrementSalaryController.sink;

  EmployeeBloc() {
    _employeeListStreamController.add(_employeesList);
    _employeeIncrementSalaryController.stream.listen(_incrementSalary);
    _employeeDecrementSalaryController.stream.listen(_decrementSalary);
  }

  double newSalary(double salary) => salary * 20/100;

  updateEmployeed(Employee emp) {
    _employeesList[emp.id - 1] = emp;
    employeeListSink.add(_employeesList);
  }

  _incrementSalary(Employee emp) {
    emp.salary = emp.salary + newSalary(emp.salary);
    updateEmployeed(emp);
  }

  _decrementSalary(Employee emp) {
    emp.salary = emp.salary - newSalary(emp.salary);
    updateEmployeed(emp);
  }

  dispose(){
    _employeeListStreamController.close();
    _employeeIncrementSalaryController.close();
    _employeeDecrementSalaryController.close();
  }
}
