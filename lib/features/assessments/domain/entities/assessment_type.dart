enum AssessmentType {
  placements('/placements/new'),
  levelChecks('/level-checks/new'),
  homework('/homework/new'),
  exams('/exams/new'),
  lastDances('/last-dances/new');

  final String endpoint;
  const AssessmentType(this.endpoint);
}
