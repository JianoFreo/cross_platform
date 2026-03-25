import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/task.dart';
import '../utils/date_utils.dart' as MyDateUtils;

class CalendarScreen extends StatefulWidget {
  final List<Task> tasks;

  const CalendarScreen({super.key, required this.tasks});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  List<Task> getTasksForDay(DateTime day) {
    return widget.tasks.where((task) {
      final taskDay = task.dueDate ?? task.createdAt;
      return taskDay.year == day.year &&
          taskDay.month == day.month &&
          taskDay.day == day.day;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final tasksForSelectedDay =
        _selectedDay != null ? getTasksForDay(_selectedDay!) : [];

    // Highlight days with tasks
    final taskDays = widget.tasks
        .map((t) => DateTime(
            t.dueDate?.year ?? t.createdAt.year,
            t.dueDate?.month ?? t.createdAt.month,
            t.dueDate?.day ?? t.createdAt.day))
        .toSet();

    return Scaffold(
      appBar: AppBar(title: const Text('Calendar')),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime(2000),
            lastDay: DateTime(2100),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) {
                if (taskDays.contains(DateTime(day.year, day.month, day.day))) {
                  return Container(
                    margin: const EdgeInsets.all(4),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.greenAccent,
                      shape: BoxShape.circle,
                    ),
                    child: Text('${day.day}'),
                  );
                }
                return null;
              },
            ),
            calendarStyle: const CalendarStyle(
              todayDecoration: BoxDecoration(
                  color: Colors.blue, shape: BoxShape.circle),
              selectedDecoration: BoxDecoration(
                  color: Colors.orange, shape: BoxShape.circle),
            ),
          ),
          const Divider(),
          Expanded(
            child: tasksForSelectedDay.isEmpty
                ? const Center(child: Text('No tasks for this day'))
                : ListView.builder(
                    itemCount: tasksForSelectedDay.length,
                    itemBuilder: (context, index) {
                      final task = tasksForSelectedDay[index];
                      return ListTile(
                        title: Text(task.title),
                        subtitle: Text(
                            'Created: ${MyDateUtils.DateUtils.formatTime(task.createdAt)}'),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}