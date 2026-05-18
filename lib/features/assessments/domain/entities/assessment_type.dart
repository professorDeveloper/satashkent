enum AssessmentType {
  placements('/placement/new'),
  levelChecks('/level-checks/new'),
  homework('/homework/new'),
  exams('/exams/new'),
  lastDances('/final-exams/new');

  final String endpoint;
  const AssessmentType(this.endpoint);
}
