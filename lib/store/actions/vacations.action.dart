// Project imports:
import 'package:company_id_new/common/helpers/app-enums.dart';

class ChangeStatusVacationPending {
  ChangeStatusVacationPending(
    this.vacationId,
    this.status,
  );
  String vacationId;
  RequestStatus status;
}

class ChangeStatusVacationSuccess {
  ChangeStatusVacationSuccess(this.vacationId, this.status);
  String vacationId;
  RequestStatus status;
}

class ChangeStatusVacationError {}
