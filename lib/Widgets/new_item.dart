import 'package:flutter/material.dart';
import '../Model/list_item.dart';
import 'package:nanoid/nanoid.dart';
import '../Model/location.dart';

class NewItem extends StatefulWidget {

  final Function addItem;

  NewItem(this.addItem);

  @override
  State<StatefulWidget> createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  final _courseController = TextEditingController();
  final _dateController = TextEditingController();

  String course = "";
  DateTime date = DateTime.now();

  late Location location;
  String defaultValue = 'FINKI';

  void _submitData(BuildContext context) {
    if (_courseController.text.isEmpty) {
      return;
    }
    final course1 = _courseController.text;
    final date1 = date;

    if (defaultValue == 'FINKI') {
      location = Location(latitude: 42.0043165, longitude: 21.4096452);
    } else if (defaultValue == 'FEIT') {
      location = Location(latitude: 42.004400, longitude: 21.408918);
    } else {
      location = Location(latitude: 42.004906, longitude: 21.409890);
    }

    final newItem = ListItem(
        id: nanoid(5), course: course1, date: date1, location: location);

    widget.addItem(newItem);
    Navigator.of(context).pop();
  }

  void _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    ).then((value) {
      if (value != null) {
        setState(() {
          date = value;
        });
      }
    });
  }

  void _showTimePicker() {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then((value) {
      if (value != null) {
        setState(() {
          date = DateTime(
            date.year,
            date.month,
            date.day,
            value.hour,
            value.minute,
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          TextField(
            controller: _courseController,
            decoration: InputDecoration(
              labelText: "Course",
            ),
            onSubmitted: (_) => _submitData(context),
          ),
          TextField(
            controller: _dateController,
            decoration: InputDecoration(
              icon: Icon(Icons.calendar_today),
              labelText: "Date",
            ),
            onTap: _showDatePicker,
            onSubmitted: (_) => _submitData(context),
          ),
          TextField(
            controller: _dateController,
            decoration: InputDecoration(
              icon: Icon(Icons.access_time_outlined),
              labelText: "Time",
            ),
            onTap: _showTimePicker,
            onSubmitted: (_) => _submitData(context),
          ),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(right: 20),
                child: Text(
                  "Location",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ),
              DropdownButton(
                value: defaultValue,
                items: <String>['FINKI', 'TMF', 'FEIT']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      textAlign: TextAlign.center,
                    ),
                  );
                }).toList(),
                onChanged: (String? novo) {
                  setState(() {
                    defaultValue = novo!;
                  });
                  _submitData(context);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
