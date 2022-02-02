// Package imports:
import 'package:dio/dio.dart';

// Project imports:
import 'package:company_id_new/common/helpers/app-api.dart';
import 'package:company_id_new/store/models/rules.model.dart';

mixin RulesService {
  static Future<List<RulesModel>> getRules() async {
    final Response<dynamic> res = await api.dio.get<dynamic>('/rule');
    final List<dynamic> rules = res.data as List<dynamic>;
    return rules.isEmpty
        ? <RulesModel>[]
        : rules
            .map<RulesModel>((dynamic rule) =>
                RulesModel.fromJson(rule as Map<String, dynamic>))
            .toList();
  }
}
