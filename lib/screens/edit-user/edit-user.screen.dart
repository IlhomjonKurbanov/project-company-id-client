import 'package:company_id_new/common/helpers/app-converters.dart';
import 'package:company_id_new/common/helpers/app-helper.dart';
import 'package:company_id_new/common/helpers/app-validators.dart';
import 'package:company_id_new/common/widgets/app-button/app-button.widget.dart';
import 'package:company_id_new/common/widgets/app-input/app-input.widget.dart';
import 'package:company_id_new/store/actions/users.action.dart';
import 'package:company_id_new/store/models/user.model.dart';
import 'package:company_id_new/store/reducers/reducer.dart';
import 'package:company_id_new/store/store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class EditUserScreen extends StatefulWidget {
  const EditUserScreen(this.uid);
  final String uid;

  @override
  State<EditUserScreen> createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  final TextEditingController _evaluationController = TextEditingController();
  final TextEditingController _salaryController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, UserModel?>(
        converter: (Store<AppState> store) => store.state.currentUser,
        onInit: (Store<AppState> store) {
          store.dispatch(GetUserPending(widget.uid));
          if (store.state.currentUser?.evaluationDate != null) {
            _evaluationController.text = AppConverters.dateFromString(
                store.state.currentUser!.evaluationDate.toString());
            _selectedDate = store.state.currentUser!.evaluationDate!;
          }
        },
        onWillChange: (UserModel? prev, UserModel? curr) {
          if (prev?.evaluationDate != curr?.evaluationDate) {
            _evaluationController.text =
                AppConverters.dateFromString(curr!.evaluationDate.toString());
            _selectedDate = curr.evaluationDate!;
          }
          if (prev?.salary != curr?.salary) {
            _salaryController.text = curr?.salary?.toString() ?? '';
          }
        },
        builder: (BuildContext context, UserModel? user) {
          if (user == null) {
            return const SizedBox();
          }
          return Padding(
              padding: const EdgeInsets.all(12),
              child: Form(
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
                  Align(
                      alignment: Alignment.center,
                      child: AppButtonWidget(
                          width: 140,
                          title: 'Save',
                          onClick: () {
                            if (!_formKey.currentState!.validate()) {
                              return;
                            }
                            store.dispatch(ChangeEvaluationDatePending(
                                user.id,
                                _selectedDate,
                                int.parse(_salaryController.text)));
                          }))
                ]),
              ));
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
