import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'reminder_service.dart';

class FarmTask {
  final int id;
  final String title;
  final String crop;
  final DateTime date;
  bool done;
  bool reminder;
  FarmTask({
    required this.id,
    required this.title,
    required this.crop,
    required this.date,
    this.done = false,
    this.reminder = false,
  });
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'crop': crop,
    'date': date.toIso8601String(),
    'done': done,
    'reminder': reminder,
  };
  factory FarmTask.fromJson(Map<String, dynamic> j) => FarmTask(
    id: j['id'],
    title: j['title'],
    crop: j['crop'],
    date: DateTime.parse(j['date']),
    done: j['done'],
    reminder: j['reminder'] ?? false,
  );
}

class DailyStore extends ChangeNotifier {
  static final instance = DailyStore();
  late SharedPreferences _prefs;
  final List<FarmTask> _tasks = [];
  List<FarmTask> get tasks => List.unmodifiable(_tasks);
  final List<Map<String, dynamic>> _history = [];
  List<Map<String, dynamic>> get history => List.unmodifiable(_history);
  bool morning = false;
  int morningHour = 7;
  Future<void> _writes = Future.value();
  String _storageKey = 'daily_flow_v1';
  Future<void> useAccount(String? id) async {
    await _writes;
    for (final task in _tasks.where((t) => t.reminder)) {
      try {
        await ReminderService.instance.cancel(task.id);
      } on Object {
        /* OS may be unavailable on web/tests. */
      }
    }
    if (morning) {
      try {
        await ReminderService.instance.cancel(7);
      } on Object {}
    }
    _storageKey = 'daily_flow_v1_${id ?? "signed_out"}';
    _tasks.clear();
    _history.clear();
    morning = false;
    morningHour = 7;
    await init();
    if (id != null) {
      for (final task in _tasks.where(
        (t) => t.reminder && !t.done && t.date.isAfter(DateTime.now()),
      )) {
        try {
          await ReminderService.instance.schedule(
            task.id,
            task.title,
            task.date,
          );
        } on Object {
          task.reminder = false;
        }
      }
      if (morning) {
        try {
          await setMorning(true, morningHour);
        } on Object {
          morning = false;
        }
      }
      await save();
    }
    notifyListeners();
  }

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    final raw = _prefs.getString(_storageKey);
    if (raw == null) return;
    try {
      final j = jsonDecode(raw);
      _tasks.clear();
      _tasks.addAll(
        (j['tasks'] as List).map(
          (e) => FarmTask.fromJson(Map<String, dynamic>.from(e)),
        ),
      );
      _history.clear();
      _history.addAll(
        (j['history'] as List).map((e) => Map<String, dynamic>.from(e)),
      );
      morning = j['morning'] ?? false;
      morningHour = j['morningHour'] ?? 7;
    } on Object catch (e) {
      debugPrint('Unable to restore daily flow: $e');
    }
  }

  int newId() => DateTime.now().microsecondsSinceEpoch.remainder(2147483646);
  Future<void> save() {
    final raw = jsonEncode({
      'tasks': _tasks.map((e) => e.toJson()).toList(),
      'history': _history,
      'morning': morning,
      'morningHour': morningHour,
    });
    final storageKey = _storageKey;
    _writes = _writes.then((_) async {
      await _prefs.setString(storageKey, raw);
    });
    notifyListeners();
    return _writes;
  }

  Future<void> add(FarmTask task) async {
    if (task.reminder) {
      await ReminderService.instance.schedule(task.id, task.title, task.date);
    }
    _tasks.add(task);
    _tasks.sort((a, b) => a.date.compareTo(b.date));
    await save();
  }

  Future<void> toggle(FarmTask task) async {
    final done = !task.done;
    if (task.reminder) {
      if (done) {
        await ReminderService.instance.cancel(task.id);
      } else if (task.date.isAfter(DateTime.now())) {
        await ReminderService.instance.schedule(task.id, task.title, task.date);
      }
    }
    task.done = done;
    await save();
  }

  Future<void> remove(FarmTask task) async {
    if (task.reminder) await ReminderService.instance.cancel(task.id);
    _tasks.remove(task);
    await save();
  }

  Future<void> setMorning(bool value, int hour) async {
    if (value) {
      final now = DateTime.now();
      var next = DateTime(now.year, now.month, now.day, hour);
      if (!next.isAfter(now)) next = next.add(const Duration(days: 1));
      await ReminderService.instance.schedule(
        7,
        'सुबह का किसान बुलेटिन • मौसम, मंडी और खाता',
        next,
        daily: true,
      );
    } else {
      await ReminderService.instance.cancel(7);
    }
    morning = value;
    morningHour = hour;
    await save();
  }

  Future<void> record(Map<String, dynamic> item) async {
    _history.insert(0, {...item, 'date': DateTime.now().toIso8601String()});
    await save();
  }

  int get doctorCallsToday => _history
      .where(
        (e) =>
            e['type'] == 'doctor' &&
            e['date'].toString().startsWith(
              DateTime.now().toIso8601String().substring(0, 10),
            ),
      )
      .length;
}
