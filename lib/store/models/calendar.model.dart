class CalendarModel {
  CalendarModel(
      {required this.vacations,
      this.holiday,
      this.timelogs,
      this.birthdays,
      this.evaluation});
  int? vacations;
  double? timelogs;
  String? holiday;
  int? birthdays;
  int? evaluation;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'timelogs': timelogs,
        'holiday': holiday,
        'vacations': vacations,
        'birthdays': birthdays
      };

  static CalendarModel fromJson(Map<String, dynamic> json) => CalendarModel(
        vacations: json['vacations'] as int?,
        evaluation: json['evaluation'] as int?,
        timelogs: json['timelogs'] == null
            ? null
            : json['timelogs'] is int
                ? (json['timelogs'] as int).toDouble()
                : json['timelogs'] as double,
        holiday: json['holidays'] != null
            ? (json['holidays'] as List<dynamic>)[0] as String
            : null,
        birthdays: json['birthdays'] as int?,
      );
}
