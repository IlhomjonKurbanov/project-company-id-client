// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:redux/redux.dart';

// Project imports:
import 'package:company_id_new/common/helpers/app-colors.dart';
import 'package:company_id_new/common/helpers/app-converters.dart';
import 'package:company_id_new/common/helpers/app-converting.dart';
import 'package:company_id_new/common/helpers/app-enums.dart';
import 'package:company_id_new/common/helpers/app-refreshers.dart';
import 'package:company_id_new/common/widgets/app-list-tile/app-list-tile.widget.dart';
import 'package:company_id_new/common/widgets/avatar/avatar.widget.dart';
import 'package:company_id_new/common/widgets/confirm-dialog/confirm-dialog.widget.dart';
import 'package:company_id_new/screens/user/user.screen.dart';
import 'package:company_id_new/store/actions/logs.action.dart';
import 'package:company_id_new/store/actions/route.action.dart';
import 'package:company_id_new/store/actions/vacations.action.dart';
import 'package:company_id_new/store/models/log.model.dart';
import 'package:company_id_new/store/reducers/reducer.dart';
import 'package:company_id_new/store/store.dart';

class _ViewModel {
  _ViewModel({required this.requests, required this.isLoading});
  List<LogModel> requests;
  bool isLoading;
}

class RequestsScreen extends StatefulWidget {
  @override
  _RequestsScreenState createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  final SlidableController _slidableController = SlidableController();
  @override
  void initState() {
    store.dispatch(GetRequestsPending());
    super.initState();
  }

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, _ViewModel>(
      converter: (Store<AppState> store) => _ViewModel(
          isLoading: store.state.isLoading, requests: store.state.requests),
      onWillChange: (_ViewModel? prev, _ViewModel curr) {
        if (prev!.requests.length != curr.requests.length &&
            curr.requests.isEmpty) {
          store.dispatch(const PopAction(changeTitle: true));
        }
      },
      builder: (BuildContext context, _ViewModel state) => SmartRefresher(
          controller: AppRefreshers.requests,
          onRefresh: () => store.dispatch(GetRequestsPending()),
          enablePullDown: true,
          child: state.requests.isEmpty
              ? const Center(
                  child: Text('No requests', style: TextStyle(fontSize: 24)))
              : _buildRequests(state.requests)));

  Widget _buildRequests(List<LogModel> requests) => ListView.builder(
      shrinkWrap: true,
      itemCount: requests.length,
      itemBuilder: (BuildContext context, int index) {
        final LogModel request = requests[index];
        return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: Slidable(
                controller: _slidableController,
                actionPane: const SlidableDrawerActionPane(),
                actionExtentRatio: 0.1,
                secondaryActions: <Widget>[
                  IconSlideAction(
                      color: AppColors.bg,
                      iconWidget: IconButton(
                          icon: const Icon(Icons.check),
                          color: Colors.green,
                          onPressed: () => _changeStatus(
                              request.id!,
                              context,
                              RequestStatus.Approved,
                              'Are you sure about approving?'))),
                  IconSlideAction(
                      color: AppColors.bg,
                      iconWidget: IconButton(
                          icon: const Icon(Icons.close),
                          color: AppColors.main,
                          onPressed: () => _changeStatus(
                              request.id!,
                              context,
                              RequestStatus.Rejected,
                              'Are you sure about rejecting?')))
                ],
                child: AppListTile(
                    onTap: () => store.dispatch(PushAction(
                        UserScreen(uid: request.user!.id),
                        '${request.user!.name} ${request.user!.lastName}')),
                    leading:
                        AvatarWidget(avatar: request.user!.avatar, sizes: 50),
                    textSpan: TextSpan(
                        text: AppConverters.dateFromString(
                                request.date.toString()) +
                            ' - ' +
                            request.desc!,
                        style: const TextStyle(color: Colors.white)),
                    trailing: Text(AppConverting.getVacationTypeString(
                        request.vacationType!)))));
      });

  Future<void> _changeStatus(String id, BuildContext context,
      RequestStatus status, String titleText) async {
    final bool? isConfirm = await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) =>
            ConfirmDialogWidget(title: 'Request', text: titleText));
    if (isConfirm != null && !isConfirm) {
      _slidableController.activeState?.close();
      return;
    }
    store.dispatch(ChangeStatusVacationPending(id, status));
    _slidableController.activeState?.close();
  }
}
