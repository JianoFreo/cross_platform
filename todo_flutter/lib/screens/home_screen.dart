import 'package:flutter/material.dart';
import '../models/task.dart';
import '../widgets/task_tile.dart';
 
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
 
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
 
class _HomeScreenState extends State<HomeScreen> {
 
  List<Task> tasks = [];
 
  void addTask(String title) {
    setState(() {
      tasks.add(Task(title: title));
    });
  }
 
  void toggleTask(int index, bool? value) {
    setState(() {
      tasks[index].isDone = value!;
    });
  }
 
  void deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }
 
  void showAddTaskDialog() {
    TextEditingController controller = TextEditingController();
 
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add Task"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: "Enter task",
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              addTask(controller.text);
              Navigator.pop(context);
            },
            child: const Text("Add"),
          )
        ],
      ),
    );
  }
 
  @override
  Widget build(BuildContext context) {
 
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Tasks"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            return TaskTile(
              task: tasks[index],
              onChanged: (value) => toggleTask(index, value),
              onDelete: () => deleteTask(index),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddTaskDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}