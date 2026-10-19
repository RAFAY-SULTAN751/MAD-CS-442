// main.dart - Study Tracker lab
import 'dart:async';
import 'package:flutter/material.dart';

const String studentName = 'RAFAY SULTAN';
const String rollNo = '04072312037';

// ===== Seeded settings (generated from YOUR roll number). Do not edit. =====
final int seed = int.parse(rollNo.substring(rollNo.length - 2));
final int t = seed ~/ 10; // tens digit
final int u = seed % 10; // units digit
const List<String> courses = [
  'Mobile Dev', 'Data Structures', 'Operating Systems', 'Databases',
  'Networks', 'Software Eng', 'AI', 'Web Engineering', 'Graphics', 'Security',
];
final String course = courses[u];
final int startCount = 3 + u;
final int stepSize = 1 + t % 4;
final int maxCount = 20 + 2 * t;
final int startSeconds = 5 + (t + u) % 6;
final int bugStep = 1 + u % 4;
// ===========================================================================

final List<String> lifecycleLog = <String>[];

void main() => runApp(const LabApp());

class LabApp extends StatelessWidget {
  const LabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(title: 'Study Tracker', home: HomePage());
  }
}

// Think: LabApp > MaterialApp > HomePage > Scaffold > SingleChildScrollView
// > Column > Row > Text('Max: ..'). The Max Text is 8 levels deep.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Study Tracker: $course')),
                  body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StudentCard(name: studentName, roll: rollNo, course: course),
              const SizedBox(height: 12),
            const Tally(),
            const SizedBox(height: 12),
            const Countdown(),
            const SizedBox(height: 12),
            const BuggyCounter(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Start: $startCount', key: const Key('info-start')),
                Text('Step: $stepSize', key: const Key('info-step')),
                Text('Max: $maxCount', key: const Key('info-max')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ---- Provided for Step 7. It has a bug on purpose. Do not rename anything.
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

class StudentCard extends StatelessWidget {
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
// Stateless: it only displays the count and max it was given.
// Think: it has no state of its own, so it never calls setState. To show a
// new count, its parent must rebuild it with a new count value.
class GoalBanner extends StatelessWidget {
  final int count;
  final int max;

  const GoalBanner({super.key, required this.count, required this.max});

  @override
  Widget build(BuildContext context) {
    final percent = count * 100 ~/ max;
    return Text(
      'Progress: $count of $max ($percent%)',
      key: const Key('progress'),
    );
  }
}

// Stateful: the count changes while the app runs.
// Think: the widget (Tally) is immutable configuration that gets recreated;
// the State object (_TallyState) lives on and remembers _count.
class Tally extends StatefulWidget {
  const Tally({super.key});

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

class _CountdownState extends State<Countdown> {
  late int _left;
  late Timer _timer;
  int _builds = 0; // CHANGE 1: naya field

  @override
  void initState() {
    super.initState();
    lifecycleLog.add('initState'); // CHANGE 2: super.initState() ke turant baad
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
    lifecycleLog.add('dispose'); // CHANGE 3: super.dispose() se pehle
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // CHANGE 4: build ka pura content replace
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