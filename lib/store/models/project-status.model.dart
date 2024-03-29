// Project imports:
import 'package:company_id_new/common/helpers/app-enums.dart';

class ProjectStatusModel {
  ProjectStatusModel(this.title, this.status);
  String title;
  ProjectStatus status;

  String getStatusQuery() {
    const String queryStart = 'status=';
    switch (status) {
      case ProjectStatus.Finished:
        return '${queryStart}finished';
      case ProjectStatus.Rejected:
        return '${queryStart}rejected';
      case ProjectStatus.Ongoing:
        return '${queryStart}ongoing';
      default:
        return '';
    }
  }
}
