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

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController =
      TextEditingController(text: '');
  final TextEditingController _passwordController =
      TextEditingController(text: '');
  bool isRemember = false;
  @override
  @override
  Widget build(BuildContext context) => StoreConnector<AppState, _ViewModel>(
      converter: (Store<AppState> store) => _ViewModel(
            isLoading: store.state.isLoading,
          ),
      builder: (BuildContext context, _ViewModel state) => Scaffold(
          body: Padding(
              padding: const EdgeInsets.only(left: 52, right: 52),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Image.asset(AppImages.jsdaddy),
                    Column(children: <Widget>[
                      const Text('Login',
                          style: TextStyle(
                              color: AppColors.main,
                              fontSize: 24,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 24),
                      AppInput(
                          validator: (String? value) =>
                              AppValidators.validateIsEmpty(
                                  value, 'Please enter email'),
                          myController: _emailController,
                          labelText: 'Email'),
                      const SizedBox(height: 16),
                      AppInput(
                          obscureText: true,
                          validator: (String? value) =>
                              AppValidators.validateIsEmpty(
                                  value, 'Please enter password'),
                          myController: _passwordController,
                          labelText: 'Password'),
                      const SizedBox(height: 24),
                      Align(
                          alignment: Alignment.center,
                          child: AppButtonWidget(
                            width: 140,
                            title: 'Login',
                            isLoading: state.isLoading,
                            onClick: () => store.dispatch(SignInPending(
                                'xakeppok10@gmail.com', 'Huywsraku1')),
                            // onClick: () => store.dispatch(SignInPending(
                            //     _emailController.text.trim(),
                            //     _passwordController.text)),
                          ))
                    ])
                  ]))));
}
