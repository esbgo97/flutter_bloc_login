import 'package:bloc_pattern/employee/employee.dart';
import 'package:bloc_pattern/employee/employeeBloc.dart';
import 'package:flutter/material.dart';

class EmployeePage extends StatefulWidget {
  EmployeePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _EmployeePageState createState() => _EmployeePageState();
}

class _EmployeePageState extends State<EmployeePage> {
  final EmployeeBloc _employeeBloc = EmployeeBloc();

  @override
  void dispose() {
    _employeeBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Employees"),
      ),
      body: Container(
        child: StreamBuilder<List<Employee>>(
          stream: _employeeBloc.employeeListStream,
          builder:
              (BuildContext context, AsyncSnapshot<List<Employee>> snapshot) {
            return ListView.builder(
                itemCount: snapshot.hasData ? snapshot.data.length : 0,
                itemBuilder: (BuildContext context, i) {
                  return Card(
                    elevation: 5.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(20.0),
                          child: Text(
                            "${snapshot.data[i].id}",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        Container(
                            padding: EdgeInsets.all(18.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "${snapshot.data[i].name}",
                                  style: TextStyle(fontSize: 18),
                                ),
                                Text(
                                  "${snapshot.data[i].salary}",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            )),
                        Container(
                          child: IconButton(
                            icon: Icon(Icons.thumb_up),
                            color: Colors.green,
                            onPressed: () {
                              _employeeBloc.employeeIncrement.add(snapshot.data[i]);
                            },
                          ),
                        ),
                        Container(
                          child: IconButton(
                            icon: Icon(Icons.thumb_down),
                            color: Colors.red,
                            onPressed: () {
                              _employeeBloc.employeeDecremet.add(snapshot.data[i]);
                            },
                          ),
                        )
                      ],
                    ),
                  );
                });
          },
        ),
      ),
    );
  }
}
