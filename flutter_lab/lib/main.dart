// main.dart - Study Tracker lab
import 'dart:async';
import 'package:flutter/material.dart';

const String studentName = 'Rafay Sultan';
const String rollNo = '04072312037';

// ===== Seeded settings (generated from YOUR roll number). Do not edit. =====
final int seed = int.parse(rollNo.substring(rollNo.length - 2));
final int t = seed ~/ 10; // tens digit
final int u = seed % 10; // units digit
const List<String> courses = [
  'Mobile Dev', 'Data Structures', 'Operating Systems', 'Databases',
  'Networks', 'Software Eng', 'AI', 'Web Engineering', 'Graphics', 'Security',
];
final String course = courses[u]; // your course name
final int startCount = 3 + u; // where the tally starts
final int stepSize = 1 + t % 4; // how much + and - change the tally
final int maxCount = 20 + 2 * t; // the tally may never go above this
final int startSeconds = 5 + (t + u) % 6; // where the countdown starts
final int bugStep = 1 + u % 4; // used by BuggyCounter in Step 7
// ===========================================================================

// Step 9 writes to this list from initState and dispose.
final List<String> lifecycleLog = <String>[];

void main() => runApp(const LabApp());

// Stateless: it only wraps the app and never changes after it is created.
class LabApp extends StatelessWidget {
  const LabApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Think: runApp receives the root widget of the whole app (LabApp),
    // while MaterialApp receives only the first screen as `home` (HomePage).
    // runApp starts the app; home is just one page inside it.
    return const MaterialApp(title: 'Study Tracker', home: HomePage());
  }
}

// Stateless: the page layout is fixed, changing parts live in child widgets.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Think (widget tree): LabApp > MaterialApp > HomePage > Scaffold >
    // SingleChildScrollView > Column > Row > Text('Max: ..').
    // Counting LabApp as level 0, the Max text is at level 7.
    return Scaffold(
      appBar: AppBar(title: Text('Study Tracker: $course')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StudentCard(name: studentName, roll: rollNo, course: course),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Start: $startCount', key: const Key('info-start')),
                Text('Step: $stepSize', key: const Key('info-step')),
                Text('Max: $maxCount', key: const Key('info-max')),
              ],
            ),
            const SizedBox(height: 12),
            const Tally(),
            const SizedBox(height: 12),
            const Countdown(),
            const SizedBox(height: 12),
            const BuggyCounter(),
          ],
        ),
      ),
    );
  }
}

// Stateless: output depends only on the three values it is given.
class StudentCard extends StatelessWidget {
  // Think: fields are final because a StatelessWidget is immutable; a new
  // value means a new widget. Without final the analyzer complains that a
  // class with a const constructor must have only final fields.
  final String name;
  final String roll;
  final String course;

  const StudentCard({
    super.key,
    required this.name,
    required this.roll,
    required this.course,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: $name', key: const Key('student-name')),
            Text('Roll no: $roll', key: const Key('student-roll')),
            Text('Course: $course', key: const Key('student-course')),
          ],
        ),
      ),
    );
  }
}

// Stateless: it just draws the count and max it receives.
class GoalBanner extends StatelessWidget {
  final int count;
  final int max;

  const GoalBanner({super.key, required this.count, required this.max});

  @override
  Widget build(BuildContext context) {
    // Think: GoalBanner owns no changing data, so it needs no setState.
    // To show a new count, its parent (Tally) must rebuild and pass a new
    // count into a new GoalBanner.
    final percent = count * 100 ~/ max;
    return Text(
      'Progress: $count of $max ($percent%)',
      key: const Key('progress'),
    );
  }
}

// Stateful: the tally changes when the user taps the buttons.
class Tally extends StatefulWidget {
  const Tally({super.key});

  // Think: the widget is only the immutable configuration and gets recreated
  // on rebuild; the State object lives on and keeps _count. That is why
  // there are two classes.
  @override
  State<Tally> createState() => _TallyState();
}

class _TallyState extends State<Tally> {
  int _count = startCount;

  // Think: hot reload keeps the State, so the count stays 12 (only the new
  // widget code is applied). Hot restart throws the State away and runs
  // main() again, so the count goes back to startCount.
  void _plus() {
    setState(() {
      _count += stepSize;
      if (_count > maxCount) _count = maxCount;
    });
  }

  void _minus() {
    setState(() {
      _count -= stepSize;
      if (_count < 0) _count = 0;
    });
  }

  void _reset() {
    setState(() {
      _count = startCount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Count: $_count', key: const Key('count')),
        GoalBanner(count: _count, max: maxCount),
        Row(
          children: [
            ElevatedButton(
              key: const Key('plus'),
              onPressed: _plus,
              child: Text('+$stepSize'),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              key: const Key('minus'),
              onPressed: _minus,
              child: Text('-$stepSize'),
            ),
            const SizedBox(width: 8),
            OutlinedButton(
              key: const Key('reset'),
              onPressed: _reset,
              child: const Text('Reset'),
            ),
          ],
        ),
      ],
    );
  }
}

// Stateful: the remaining seconds change every second.
class Countdown extends StatefulWidget {
  const Countdown({super.key});

  @override
  State<Countdown> createState() => _CountdownState();
}

class _CountdownState extends State<Countdown> {
  late int _left;
  late Timer _timer;
  int _builds = 0;

  @override
  void initState() {
    super.initState();
    lifecycleLog.add('initState');
    _left = startSeconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() => _left--);
      if (_left <= 0) timer.cancel(); // stop at zero
    });
  }

  @override
  void dispose() {
    // Think: without this cancel, the timer keeps firing after the widget is
    // removed and setState() is called on a disposed State, which gives
    // "setState() called after dispose()" in the console.
    _timer.cancel();
    lifecycleLog.add('dispose');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Think: build runs once per setState, and the timer calls setState once
    // per second, so Builds goes up by one (not two) each second.
    // lifecycleLog can be printed with debugPrint(lifecycleLog.toString())
    // inside dispose to prove that dispose ran.
    _builds++;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _left > 0
            ? Text('Time left: $_left s', key: const Key('time-left'))
            : const Text('Time is up!', key: Key('time-left')),
        Text('Builds: $_builds', key: const Key('builds')),
      ],
    );
  }
}

// Stateful: the click count changes when the button is pressed.
class BuggyCounter extends StatefulWidget {
  const BuggyCounter({super.key});

  @override
  State<BuggyCounter> createState() => _BuggyCounterState();
}

class _BuggyCounterState extends State<BuggyCounter> {
  int _clicks = 0;

  @override
  Widget build(BuildContext context) {
    // Think: before the fix, after 3 taps _clicks inside the State was 12
    // (3 * bugStep = 3 * 4), but the screen still showed 0 because no
    // rebuild was requested.
    return Row(
      children: [
        Text('Bug clicks: $_clicks', key: const Key('bug-text')),
        const SizedBox(width: 12),
        ElevatedButton(
          key: const Key('bug-button'),
          onPressed: () {
            setState(() {
              _clicks += bugStep;
            });
          },
          child: Text('+$bugStep'),
        ),
      ],
    );
  }
}