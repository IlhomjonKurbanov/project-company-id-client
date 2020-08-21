import 'package:company_id_new/store/models/current-day.model.dart';
import 'package:company_id_new/store/models/log.model.dart';

class GetAdminLogsPending {
  GetAdminLogsPending(this.query);
  String query;
}

class GetAdminLogsSuccess {
  GetAdminLogsSuccess(this.logs);
  Map<DateTime, List<double>> logs;
}

class GetLogsPending {}

class GetLogsSuccess {}

class FilterLogsPending {}

class FilterLogsSuccess {}

class SetAdminCurrentLogDay {
  SetAdminCurrentLogDay(this.currentDay);
  CurrentDateModel currentDay;
}

class SetCurrentLogDay {
  SetCurrentLogDay(this.currentDay);
  CurrentDateModel currentDay;
}
