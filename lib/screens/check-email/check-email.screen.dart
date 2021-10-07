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

class CheckEmailScreen extends StatefulWidget {
  @override
  State<CheckEmailScreen> createState() => _CheckEmailScreenState();
}

class _CheckEmailScreenState extends State<CheckEmailScreen> {
  final TextEditingController _emailController =
      TextEditingController(text: '');

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, bool>(
      converter: (Store<AppState> store) => store.state.isLoading,
      builder: (BuildContext context, bool isLoading) => Scaffold(
          body: Padding(
              padding: const EdgeInsets.only(left: 52, right: 52),
              child: Form(
                key: _formKey,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Image.asset(AppImages.jsdaddy),
                      Column(children: <Widget>[
                        const Text('Sign Up',
                            style: TextStyle(
                                color: AppColors.main,
                                fontSize: 24,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(height: 24),
                        AppInput(
                            validator: (String? value) =>
                                AppValidators.validateEmailForlink(value),
                            myController: _emailController,
                            labelText: 'Email'),
                        const SizedBox(height: 16),
                        Align(
                            alignment: Alignment.center,
                            child: AppButtonWidget(
                                width: 140,
                                title: 'Grt signup link',
                                isLoading: isLoading,
                                onClick: () {
                                  if (_formKey.currentState!.validate()) {
                                    return;
                                  }
                                  store.dispatch(GetSignUpLinkPending(
                                      _emailController.text));
                                }))
                      ])
                    ]),
              ))));
}
