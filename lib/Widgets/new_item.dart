import 'package:flutter/material.dart';
import '../Model/list_item.dart';
import 'package:nanoid/nanoid.dart';

class NewItem extends StatefulWidget {

  final Function addItem;

  NewItem(this.addItem);

  @override
  State<StatefulWidget> createState() => _NewItemState();
}

class _NewItemState extends State<NewItem>{
  final _courseController = TextEditingController();
  final _dateController = TextEditingController();

  String course = "";
  DateTime date = DateTime.now();

  void _submitData(){
    if (_courseController.text.isEmpty){
      return;
    }
    final course1 = _courseController.text;
    final date1 = date;

    final newItem = ListItem(id:nanoid(5), course:course1, date:date1);

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
      date = value!;
    });
  }

  void _showTimePicker() {
    showTimePicker(
        context: context,
        initialTime: TimeOfDay.now()
    ).then((value) =>
    {
      date = new DateTime(date.year, date.month, date.day, value!.hour, value.minute)
    });
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Column (
        children: [
          TextField(
            controller: _courseController,
            decoration: InputDecoration(
              labelText: "Course",
            ),
            onSubmitted: (_) => _submitData,
          ),
          TextField(
            controller: _dateController,
            decoration: InputDecoration(
              icon: Icon(Icons.calendar_today),
              labelText: "Date",
            ),
            onTap: _showDatePicker,
            onSubmitted: (_) => _submitData,
          ),
          TextField(
            controller: _dateController,
            decoration: InputDecoration(
              icon: Icon(Icons.access_time_outlined),
              labelText: "Time",
            ),
            onTap: _showTimePicker,
            onSubmitted: (_) => _submitData,
          ),
          TextButton(
            child: Text("Add"),
            onPressed: _submitData,
          ),
        ],
      ),
    );
  }

}