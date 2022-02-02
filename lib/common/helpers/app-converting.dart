// Project imports:
import 'package:company_id_new/common/helpers/app-constants.dart';
import 'package:company_id_new/common/helpers/app-enums.dart';

mixin AppConverting {
  static VacationType getVacationType(int type) {
    switch (type) {
      case 0:
        return VacationType.VacNonPaid;
      case 1:
        return VacationType.VacPaid;
      case 2:
        return VacationType.SickNonPaid;
      case 3:
        return VacationType.SickPaid;
      default:
        return VacationType.VacPaid;
    }
  }

  static String getVacationTypeQuery(VacationType type) {
    switch (type) {
      case VacationType.VacPaid:
        return AppConstants.VacationPaid;
      case VacationType.VacNonPaid:
        return AppConstants.VacationNonPaid;
      case VacationType.SickPaid:
        return AppConstants.SickPaid;
      case VacationType.SickNonPaid:
        return AppConstants.SickNonPaid;
      default:
        return '';
    }
  }

  static String getVacationTypeString(VacationType type) {
    switch (type) {
      case VacationType.VacPaid:
        return 'Vacation - paid';
      case VacationType.VacNonPaid:
        return 'Vacation - non-paid';
      case VacationType.SickPaid:
        return 'Sick - paid';
      case VacationType.SickNonPaid:
        return 'Sick - non-paid';
      default:
        return '';
    }
  }

  static String getTypeLogQuery(LogType? logType) {
    switch (logType) {
      case LogType.Vacation:
        return AppConstants.vacations;
      case LogType.Timelog:
        return AppConstants.timelogs;
      default:
        return AppConstants.all;
    }
  }

  static Positions getPositionFromEnum(String? position) {
    switch (position) {
      case AppConstants.owner:
        return Positions.Owner;
      case AppConstants.developer:
        return Positions.Developer;
      default:
        return Positions.Developer;
    }
  }

  static String getPositionFromString(Positions? position) {
    switch (position) {
      case Positions.Owner:
        return AppConstants.Owner;
      case Positions.Developer:
        return AppConstants.Developer;
      default:
        return AppConstants.Developer;
    }
  }

  static String getStringFromProjectStatus(ProjectStatus status) {
    switch (status) {
      case ProjectStatus.Finished:
        return AppConstants.finished;
      case ProjectStatus.Rejected:
        return AppConstants.rejected;
      default:
        return '';
    }
  }

  static String getStringFromRequestStatus(RequestStatus status) {
    switch (status) {
      case RequestStatus.Approved:
        return AppConstants.approved;
      case RequestStatus.Rejected:
        return AppConstants.rejected;
      case RequestStatus.Pending:
        return AppConstants.pending;
      default:
        return '';
    }
  }

  static RequestStatus requestStatusFromString(String? status) {
    switch (status) {
      case AppConstants.approved:
        return RequestStatus.Approved;
      case AppConstants.rejected:
        return RequestStatus.Rejected;
      case AppConstants.pending:
        return RequestStatus.Pending;
      default:
        return RequestStatus.Pending;
    }
  }

  static ProjectStatus projectStatusFromString(String? status) {
    switch (status) {
      case AppConstants.finished:
        return ProjectStatus.Finished;
      case AppConstants.rejected:
        return ProjectStatus.Rejected;
      case AppConstants.ongoing:
        return ProjectStatus.Ongoing;
      case AppConstants.all:
        return ProjectStatus.All;
      default:
        return ProjectStatus.All;
    }
  }
}
