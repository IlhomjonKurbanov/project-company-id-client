class StatisticModel {
  StatisticModel({required this.workedOut, this.toBeWorkedOut, this.overtime});
  String workedOut;
  String? toBeWorkedOut;
  String? overtime;

  static StatisticModel fromJson(Map<String, dynamic> json) => StatisticModel(
      workedOut: json['workedOut'] as String,
      toBeWorkedOut: json['toBeWorkedOut'] as String?,
      overtime: json['overtime'] as String?);
}
