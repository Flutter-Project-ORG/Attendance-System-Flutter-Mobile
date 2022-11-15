import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:intl/intl.dart';

import '../../view_model/todo/tasks_view_model.dart';
import 'add_task_view.dart';

class TasksView extends StatefulWidget {
  const TasksView({Key? key}) : super(key: key);

  @override
  State<TasksView> createState() => _TasksViewState();
}

class _TasksViewState extends State<TasksView> {

  final TasksViewModel _viewModel = TasksViewModel();

  String studentId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TO DO'),
      ),
      body: StreamBuilder(
          stream: FirebaseDatabase.instance.ref('notes/$studentId').onValue,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            return Column(
              children: [
                _addTaskBar(),
                const SizedBox(height: 6),
                _showTasks(snapshot),
              ],
            );
          }),
    );
  }

  _addTaskBar() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 10, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(DateFormat.yMMMMd().format(DateTime.now())),
              const Text('Today')
            ],
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const AddTaskView()));
            },
            child: const Text('+ Add Task'),
          ),
        ],
      ),
    );
  }

  Widget _showTasks(AsyncSnapshot snapshot) {
    if (snapshot.data != null &&
        snapshot.hasData &&
        snapshot.data!.snapshot.value != null) {
      final Map<dynamic, dynamic> data =
          snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
      List dataKeys = data.keys.toList();
      return Expanded(
        child: ListView.builder(
          itemCount: data.length,
          itemBuilder: (BuildContext context, int index) {
            final singleData = data[dataKeys[index]];
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 500),
              child: SlideAnimation(
                horizontalOffset: 300,
                child: FadeInAnimation(
                  child: GestureDetector(
                    onTap: () {
                      showDialog(context: context, builder: (context){
                        return AlertDialog(
                          content: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              OutlinedButton(
                                onPressed: ()async {
                                  await _viewModel.makeTaskCompleted(context,dataKeys[index]);
                                },
                                child: const Text('Complete'),
                              ),
                              OutlinedButton(
                                onPressed: () async{
                                  await _viewModel.deleteTask(context,dataKeys[index]);
                                },
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                        );
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    singleData['title'],
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'Date: ${singleData['date']}',
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.access_time_rounded,
                                        color: Colors.grey[200],
                                        size: 18,
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        '${singleData['start']} - ${singleData['end']}',
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    singleData['note'],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            height: 60,
                            width: 0.5,
                            color: Colors.grey[200]!.withOpacity(0.7),
                          ),
                          RotatedBox(
                            quarterTurns: 3,
                            child: Text(
                              !singleData['isFinished'] ? 'To Do' : 'Completed',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      );
    }
    return Expanded(child: _noTaskMsg());
  }

  Center _noTaskMsg() {
    return Center(
      child: SingleChildScrollView(
        child: Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/images/no_tasks.svg',
              height: 90,
              semanticsLabel: 'Task',
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: Text(
                'You don\'t have any tasks yet!\n Add new tasks to make your days productive.',
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
