/// Course Roster Console App — Lab 1

void main() {
  //Part 1
  printWelcome('Course Roster Manager');

  //Part 2: Course & Roster Data
  const int maxCapacity = 4;
  final DateTime createdAt = DateTime.now();
  String courseTitle = 'CS201: Mobile App Development';
  int capacity = maxCapacity;
  double creditHours = 3.0;
  bool isOpen = true;
  List<String> enrolledStudents = ['Aiden', 'Maria', 'Jamal'];
  Set<String> waitlist = {'Priya', 'Noah'};
  Map<String, int> attendanceCount = {
    'Aiden': 3,
    'Maria': 4,
    'Jamal': 2,
  };

  print(
    '$courseTitle | Capacity: $capacity | Enrolled: ${enrolledStudents.length}',
  );

  //Part 3: Null-Safe Instructor Info
  String? instructorEmail;
  print(instructorEmail ?? 'TBA');

  late String enrollmentCode;
  enrollmentCode = generateCode(courseTitle);
  print('Enrollment code: $enrollmentCode');

  print('Instructor email length: ${instructorEmail?.length ?? 0}');

  //Part 4: Formatting Strings
  String rawNames = ' Aiden , maria ,JAMAL , Priya ';
  List<String> cleanNames = [];

  for (var name in rawNames.split(',')) {
    cleanNames.add(name.trim());
  }

  String courseDescription = '''
CS201: Mobile App Development
This course introduces mobile application development.
''';

  print(courseDescription);
  print('Seats left: ${capacity - enrolledStudents.length}');

  //Part 5: Operators in Action
  int fullGroups = enrolledStudents.length ~/ 3;
  int leftover = enrolledStudents.length % 3;

  print('Full groups of 3: $fullGroups, leftover: $leftover');

  Object formInput = 'twenty-two';

  if (formInput is String) {
    print('This is text!');
  }

  if (formInput is! int) {
    print('Form input is not an int.');
  }

  StringBuffer report = StringBuffer()
    ..write('Report: $courseTitle')
    ..write(' | Cap: $capacity')
    ..write(' | Roster: ${enrolledStudents.length}');

  print(report.toString());

  List<String>? extraNotes;
  extraNotes?..add('Room change pending');
  print('Extra notes: $extraNotes');

  int? bonusSeats;
  bonusSeats ??= 0;
  print('Bonus seats: $bonusSeats');

  //Part 6: Enrollment Logic
  if (isOpen && enrolledStudents.length < capacity) {
    print("You're in! Welcome aboard.");
  } else {
    print('Course is full or closed.');
  }

  int enrollmentStatusCode = 200;

  switch (enrollmentStatusCode) {
    case 200:
      print('Enrolled');
      break;
    case 404:
      print('Course not found');
      break;
    default:
      print('Unknown error');
      break;
  }

  String statusTag = isOpen ? 'OPEN' : 'FULL';
  print(statusTag);

  //Part 7: Reports & Loops
  for (var student in enrolledStudents) {
    print(student);
  }

  attendanceCount.forEach((key, value) {
    print('$key: $value');
  });

  List<String> announcements = [
    'Welcome to $courseTitle',
    if (!isOpen) 'Course is FULL — waitlist open',
    for (var student in waitlist)
      'Reminder: $student, please confirm attendance',
  ];

  for (var announcement in announcements) {
    print(announcement);
  }
}

/// Prints the application welcome banner.
void printWelcome(String appName) {
  print('=== $appName ===');
}

String generateCode(String title) =>
    title.substring(0, 2).toUpperCase() + '101';
