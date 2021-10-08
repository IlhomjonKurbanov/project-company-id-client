import 'package:company_id_new/common/helpers/app-colors.dart';
import 'package:company_id_new/common/helpers/app-images.dart';
import 'package:company_id_new/common/helpers/app-validators.dart';
import 'package:company_id_new/common/widgets/app-button/app-button.widget.dart';
import 'package:company_id_new/common/widgets/app-input/app-input.widget.dart';
import 'package:company_id_new/store/actions/auth.action.dart';
import 'package:company_id_new/store/reducers/reducer.dart';
import 'package:company_id_new/store/store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class _ViewModel {
  _ViewModel({required this.isLoading});
  bool isLoading;
}

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen(this.token);
  final String token;

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _passwordController =
      TextEditingController(text: '');
  final TextEditingController _cpasswordController =
      TextEditingController(text: '');

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isRemember = false;

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, _ViewModel>(
      converter: (Store<AppState> store) => _ViewModel(
            isLoading: store.state.isLoading,
          ),
      builder: (BuildContext context, _ViewModel state) => Scaffold(
          body: Padding(
              padding: const EdgeInsets.only(left: 52, right: 52),
              child: Form(
                key: _formKey,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Image.asset(AppImages.jsdaddy),
                      Column(children: <Widget>[
                        const Text('Change password',
                            style: TextStyle(
                                color: AppColors.main,
                                fontSize: 24,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(height: 24),
                        AppInput(
                            validator: (String? value) =>
                                AppValidators.validateSize(value, 6,
                                    'Password has match 6 and more symbols'),
                            myController: _passwordController,
                            obscureText: true,
                            labelText: 'Password'),
                        const SizedBox(height: 24),
                        AppInput(
                            obscureText: true,
                            validator: (String? value) =>
                                AppValidators.compareValidate(
                                    value,
                                    _passwordController,
                                    'Passwords does not matches'),
                            myController: _cpasswordController,
                            labelText: 'Confirm password'),
                        const SizedBox(height: 24),
                        Align(
                            alignment: Alignment.center,
                            child: AppButtonWidget(
                                width: 140,
                                title: 'Change password',
                                isLoading: state.isLoading,
                                onClick: () {
                                  if (_formKey.currentState!.validate()) {
                                    store.dispatch(ChangePasswordPending(
                                        _passwordController.text,
                                        widget.token));
                                  }
                                })),
                      ])
                    ]),
              ))));
}
