class StackModel {
  StackModel({required this.id, required this.name});
  String id;
  String name;

  static StackModel fromJson(Map<String, dynamic> json) => StackModel(
        id: json['_id'] as String,
        name: json['name'] as String,
      );
}
