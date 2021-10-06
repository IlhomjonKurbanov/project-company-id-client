import 'package:company_id_new/common/helpers/app-converters.dart';
import 'package:company_id_new/common/helpers/app-enums.dart';
import 'package:company_id_new/common/widgets/app-list-tile/app-list-tile.widget.dart';
import 'package:company_id_new/common/widgets/stack/stack.widget.dart';
import 'package:company_id_new/store/models/project.model.dart';
import 'package:company_id_new/store/models/stack.model.dart';
import 'package:company_id_new/store/reducers/reducer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:redux/redux.dart';

class ProjectTileWidget extends StatelessWidget {
  const ProjectTileWidget(
      {required this.project,
      required this.secondaryActions,
      required this.onTap,
      required this.slidableController});
  final ProjectModel project;
  final List<Widget> secondaryActions;
  final SlidableController slidableController;
  final Function onTap;
  @override
  Widget build(BuildContext context) => StoreConnector<AppState, Positions>(
      converter: (Store<AppState> store) => store.state.user!.position!,
      builder: (BuildContext context, Positions position) => Opacity(
          opacity: project.isInternal! || project.endDate != null ? 0.6 : 1,
          child: Slidable(
              enabled: position == Positions.Owner && project.endDate == null,
              controller: slidableController,
              actionPane: const SlidableDrawerActionPane(),
              actionExtentRatio: 0.1,
              secondaryActions: secondaryActions,
              child: AppListTile(
                  onTap: () => onTap(),
                  leading: Container(
                      width: MediaQuery.of(context).size.width / 5,
                      child: Text(project.name,
                          style: const TextStyle(
                              fontSize: 16, color: Colors.white))),
                  title: Wrap(
                      children: project.stack!
                          .map((StackModel stack) =>
                              StackWidget(title: stack.name))
                          .toList()),
                  trailing: Container(
                      width: MediaQuery.of(context).size.width / 5.2,
                      child: Text('${AppConverters.dateFromString((project.startDate).toString())} - ${project.endDate != null ? AppConverters.dateFromString((project.endDate).toString()) : 'now'}', style: const TextStyle(color: Colors.white)))))));
}
