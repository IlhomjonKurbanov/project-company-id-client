import 'package:company_id_new/common/helpers/app-converting.dart';
import 'package:company_id_new/common/helpers/app-enums.dart';
import 'package:company_id_new/store/models/project.model.dart';

class UserModel {
  UserModel({
    this.avatar,
    this.github,
    this.date,
    this.email,
    required this.lastName,
    required this.name,
    this.phone,
    this.activeProjects,
    this.position,
    this.skype,
    this.slack,
    this.projects,
    required this.id,
    this.salary,
    this.startDate,
    this.vacationCount,
    this.englishLevel,
    this.sickAvailable,
    this.evaluationDate,
    this.vacationAvailable,
    this.endDate,
  });
  String? avatar;
  String? github;
  DateTime? date;
  DateTime? evaluationDate;
  String? email;
  int? vacationCount;
  int? salary;
  String id;
  List<ProjectModel>? activeProjects;
  String lastName;
  String name;
  String? phone;
  Positions? position;
  String? skype;
  String? slack;
  String? englishLevel;
  List<ProjectModel>? projects;
  int? vacationAvailable;
  int? sickAvailable;
  DateTime? endDate;
  DateTime? startDate;

  static UserModel fromJson(Map<String, dynamic> json) => UserModel(
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
      avatar: json['avatar'] as String?,
      salary: json['salary'] as int?,
      vacationAvailable: json['vacationAvailable'] as int?,
      vacationCount: json['vacationCount'] as int?,
      sickAvailable: json['sickAvailable'] as int?,
      englishLevel: json['englishLevel'] as String?,
      github: json['github'] as String?,
      date: json['dob'] == null ? null : DateTime.parse(json['dob'] as String),
      evaluationDate: json['evaluationDate'] == null
          ? null
          : DateTime.parse(json['evaluationDate'] as String),
      startDate: json['startDate'] == null
          ? null
          : DateTime.parse(json['startDate'] as String),
      email: json['email'] as String?,
      id: json['_id'] as String,
      lastName: json['lastName'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String?,
      projects: json['projects'] != null &&
              (json['projects'] as List<dynamic>).isNotEmpty &&
              json['projects'][0]['_id'] != null
          ? json['projects']
              .map<ProjectModel>((dynamic project) =>
                  ProjectModel.fromJson(project as Map<String, dynamic>))
              .toList() as List<ProjectModel>
          : null,
      activeProjects: json['activeProjects'] != null &&
              (json['activeProjects'] as List<dynamic>).isNotEmpty &&
              json['activeProjects'][0]['_id'] != null
          ? json['activeProjects']
              .map<ProjectModel>((dynamic project) => ProjectModel.fromJson(project as Map<String, dynamic>))
              .toList() as List<ProjectModel>
          : null,
      position: AppConverting.getPositionFromEnum(json['position'] as String?),
      skype: json['skype'] as String?,
      slack: json['slack'] as String?);

  UserModel copyWith(
          {String? avatar,
          int? salary,
          String? github,
          DateTime? date,
          String? email,
          String? userId,
          List<ProjectModel>? activeProjects,
          String? lastName,
          String? id,
          String? name,
          String? phone,
          Positions? position,
          int? sickAvailable,
          int? vacationAvailable,
          String? skype,
          String? slack,
          String? englishLevel,
          String? documentId,
          bool? initialLogin,
          DateTime? endDate,
          DateTime? evaluationDate,
          List<ProjectModel>? projects}) =>
      UserModel(
          evaluationDate: evaluationDate ?? this.evaluationDate,
          avatar: avatar ?? this.avatar,
          englishLevel: englishLevel ?? this.englishLevel,
          github: github ?? this.github,
          activeProjects: activeProjects ?? this.activeProjects,
          date: date ?? this.date,
          email: email ?? this.email,
          id: id ?? this.id,
          salary: salary ?? this.salary,
          lastName: lastName ?? this.lastName,
          sickAvailable: sickAvailable ?? this.sickAvailable,
          vacationAvailable: vacationAvailable ?? this.vacationAvailable,
          name: name ?? this.name,
          phone: phone ?? this.phone,
          projects: projects ?? this.projects,
          position: position ?? this.position,
          skype: skype ?? this.skype,
          slack: slack ?? this.slack,
          endDate: endDate ?? this.endDate);
}
