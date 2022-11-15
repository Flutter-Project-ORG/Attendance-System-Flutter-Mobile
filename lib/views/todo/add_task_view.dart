import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import '../../res/text_field_theme.dart';
import '../../view_model/todo/add_task_view_model.dart';

class AddTaskView extends StatefulWidget {
  const AddTaskView({Key? key}) : super(key: key);

  @override
  State<AddTaskView> createState() => _AddTaskViewState();
}

class _AddTaskViewState extends State<AddTaskView> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _startTime = TimeOfDay.now();
  TimeOfDay _endTime =
      TimeOfDay.fromDateTime(DateTime.now().add(const Duration(minutes: 15)));

  int _selectedRemind = 5;
  List<int> remindList = [5, 10, 15, 20];

  final AddTaskViewModel _viewModel = AddTaskViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Task'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                style: Theme.of(context).textTheme.labelMedium,
                decoration: InputDecoration(
                  hintStyle: Theme.of(context).textTheme.headline5,
                  labelText: 'Title',
                  labelStyle: Theme.of(context).textTheme.headline5,
                  hintText: 'Enter title here',
                  border: TextFieldTheme.border1,
                  enabledBorder: TextFieldTheme.border2,
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _noteController,
                style: Theme.of(context).textTheme.labelMedium,
                decoration: InputDecoration(
                  hintStyle: Theme.of(context).textTheme.headline5,
                  labelText: 'Note',
                  labelStyle: Theme.of(context).textTheme.headline5,
                  hintText: 'Enter note here',
                  border: TextFieldTheme.border1,
                  enabledBorder: TextFieldTheme.border2,
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                readOnly: true,
                style: Theme.of(context).textTheme.labelMedium,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () async {
                      _selectedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2030),
                          ) ??
                          DateTime.now();
                      setState(() {});
                    },
                    icon: Icon(
                      Icons.date_range,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  hintStyle: Theme.of(context).textTheme.headline5,
                  labelText: DateFormat('dd/MM/yyyy').format(_selectedDate),
                  labelStyle: Theme.of(context).textTheme.headline5,
                  border: TextFieldTheme.border1,
                  enabledBorder: TextFieldTheme.border2,
                  disabledBorder: TextFieldTheme.border2,
                ),
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      readOnly: true,
                      style: Theme.of(context).textTheme.labelMedium,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: () async {
                            _startTime = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                ) ??
                                TimeOfDay.now();
                            setState(() {});
                          },
                          icon: Icon(
                            Icons.access_time_outlined,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        hintStyle: Theme.of(context).textTheme.headline5,
                        labelText: _startTime.format(context),
                        labelStyle: Theme.of(context).textTheme.headline5,
                        border: TextFieldTheme.border1,
                        enabledBorder: TextFieldTheme.border2,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: TextField(
                      readOnly: true,
                      style: Theme.of(context).textTheme.labelMedium,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: () async {
                            _endTime = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                ) ??
                                TimeOfDay.fromDateTime(DateTime.now()
                                    .add(const Duration(minutes: 15)));
                            setState(() {});
                          },
                          icon: Icon(
                            Icons.access_time_outlined,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        hintStyle: Theme.of(context).textTheme.headline5,
                        labelText: _endTime.format(context),
                        labelStyle: Theme.of(context).textTheme.headline5,
                        border: TextFieldTheme.border1,
                        enabledBorder: TextFieldTheme.border2,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              DropdownButtonFormField<int>(
                value: _selectedRemind,
                items: remindList.map((e) {
                  return DropdownMenuItem(
                    value: e,
                    child: Text(e.toString()),
                  );
                }).toList(),
                onChanged: (int? value) {
                  _selectedRemind = value!;
                },
                style: Theme.of(context).textTheme.labelMedium,
                decoration: InputDecoration(
                  labelStyle: Theme.of(context).textTheme.headline5,
                  hintStyle: Theme.of(context).textTheme.headline5,
                  labelText: 'Remind',
                  border: TextFieldTheme.border1,
                  enabledBorder: TextFieldTheme.border2,
                ),
              ),
              const SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () {
                  _viewModel.addTask(
                    context,
                    title: _titleController.text.trim(),
                    note: _noteController.text.trim(),
                    date: _selectedDate,
                    start: _startTime,
                    end: _endTime,
                    remind: _selectedRemind,
                  );
                },
                child: const Text('Create task'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
