import 'package:company_id_new/common/helpers/app-converters.dart';
import 'package:company_id_new/common/helpers/app-helper.dart';
import 'package:company_id_new/common/helpers/app-validators.dart';
import 'package:company_id_new/common/widgets/app-button/app-button.widget.dart';
import 'package:company_id_new/common/widgets/app-input/app-input.widget.dart';
import 'package:company_id_new/common/wrappers/popup.wrapper.dart';
import 'package:company_id_new/store/actions/users.action.dart';
import 'package:company_id_new/store/models/user.model.dart';
import 'package:company_id_new/store/reducers/reducer.dart';
import 'package:company_id_new/store/store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class EvalSalaryPopup extends StatefulWidget {
  @override
  _EvalSalaryPopupState createState() => _EvalSalaryPopupState();
}

class _EvalSalaryPopupState extends State<EvalSalaryPopup> {
  final TextEditingController _evaluationController = TextEditingController();
  final TextEditingController _salaryController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, UserModel?>(
        converter: (Store<AppState> store) => store.state.currentUser,
        onInit: (Store<AppState> store) {
          if (store.state.currentUser?.evaluationDate != null) {
            _evaluationController.text = AppConverters.dateFromString(
                store.state.currentUser!.evaluationDate.toString());
            _selectedDate = store.state.currentUser!.evaluationDate!;
            if (store.state.currentUser?.evaluationDate != null) {
              _evaluationController.text = AppConverters.dateFromString(
                  store.state.currentUser!.evaluationDate.toString());
              _selectedDate = store.state.currentUser!.evaluationDate!;
            }
            if (store.state.currentUser?.salary != null) {
              _salaryController.text =
                  store.state.currentUser!.salary!.toString();
            }
          }
        },
        builder: (BuildContext context, UserModel? user) {
          if (user == null) {
            return const SizedBox();
          }
          return PopupWrapper(
            buttonSection: AppButtonWidget(
                width: 140,
                title: 'Save',
                onClick: () {
                  if (!_formKey.currentState!.validate()) {
                    return;
                  }
                  store.dispatch(ChangeEvaluationDatePending(user.id,
                      _selectedDate, int.parse(_salaryController.text)));
                }),
            widgets: <Widget>[
              Form(
                key: _formKey,
                child: Column(children: <Widget>[
                  GestureDetector(
                      onTap: () => _chooseDate(),
                      child: AbsorbPointer(
                          child: AppInput(
                              validator: (String? val) =>
                                  AppValidators.validateIsEmpty(
                                      val, 'Please provide date'),
                              myController: _evaluationController,
                              labelText: 'Next evaluate date'))),
                  const SizedBox(height: 12),
                  AppInput(
                      validator: (String? val) =>
                          AppValidators.onlyNumbers(val),
                      myController: _salaryController,
                      labelText: 'New Salary'),
                  const SizedBox(height: 12),
                ]),
              )
            ],
            title: 'Evaluation',
          );
        });
  }

  Future<void> _chooseDate() async {
    final DateTime lastDate = DateTime(DateTime.now().year + 3,
        DateTime.now().month, DateTime.now().day, 0, 0);
    final DateTime? picked =
        await AppHelper.chooseDate(context, lastDate: lastDate);
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _evaluationController.text =
            AppConverters.dateFromString(picked.toString());
        _selectedDate = picked;
      });
    }
  }
}
