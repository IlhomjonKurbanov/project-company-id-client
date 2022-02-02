// Package imports:
import 'package:pull_to_refresh/pull_to_refresh.dart';

mixin AppRefreshers {
  static RefreshController statistic = RefreshController(initialRefresh: false);
  static RefreshController projectdetails =
      RefreshController(initialRefresh: false);
  static RefreshController projects = RefreshController(initialRefresh: false);
  static RefreshController requests = RefreshController(initialRefresh: false);
  static RefreshController user = RefreshController(initialRefresh: false);
  static RefreshController users = RefreshController(initialRefresh: false);
}
