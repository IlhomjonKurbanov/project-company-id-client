class RulesModel {
  RulesModel({required this.title, required this.desc});
  String title;
  String desc;
  RulesModel copyWith({String? title, String? desc}) =>
      RulesModel(title: title ?? this.title, desc: desc ?? this.desc);

  static RulesModel fromJson(Map<String, dynamic> json) => RulesModel(
        title: json['title'] as String,
        desc: json['desc'] as String,
      );
}
