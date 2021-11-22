import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:moor_tutorial/data/moor_database.dart';
import 'package:moor_tutorial/ui/widget/new_tag_input.dart';
import 'package:provider/provider.dart';

import 'widget/new_task_input.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool showCompleted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Tasks'),
        ),
        body: Column(
          children: <Widget>[
            Expanded(child: _buildTaskList(context)),
            NewTaskInput(),
            NewTagInput(),
          ],
        ));
  }

  StreamBuilder<List<TaskWithTag>> _buildTaskList(BuildContext context) {
    final dao = Provider.of<TaskDao>(context);
    return StreamBuilder(
      stream: dao.watchAllTasks(),
      builder: (context, AsyncSnapshot<List<TaskWithTag>> snapshot) {
        final tasks = snapshot.data ?? List();

        print(" => $snapshot");

        return ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (_, index) {
            final item = tasks[index];
            return _buildListItem(item, dao);
          },
        );
      },
    );
  }

  Widget _buildListItem(TaskWithTag item, TaskDao taskDao) {
    return Slidable(
      startActionPane: ActionPane(
        motion: ScrollMotion(),
        children: [
          SlidableAction(
              label: "Delete",
              backgroundColor: Colors.red,
              icon: Icons.delete,
              onPressed: (context) => taskDao.deleteTask(item.task))
        ],
      ),
      child: CheckboxListTile(
        title: Text(item.task.name),
        subtitle: Text(item.task.dueData.toString() ?? 'No date'),
        value: item.task.completed,
        onChanged: (newValue) {
          taskDao.updateTask(item.task.copyWith(completed: newValue));
        },
      ),
    );
  }

  Row _buildCompletedOnlySwitch() {
    return Row(
      children: <Widget>[
        Text("Completed only"),
        Switch(
            value: showCompleted,
            activeColor: Colors.white,
            onChanged: (value) {
              setState(() {
                showCompleted = value;
              });
            })
      ],
    );
  }

  Column _buildTag(Tag tag) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (tag != null) ...[
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(tag.color),
            ),
          ),
          Text(
            tag.name,
            style: TextStyle(
              color: Colors.black.withOpacity(0.5),
            ),
          ),
        ],
      ],
    );
  }
}
