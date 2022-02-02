// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

// Project imports:
import 'package:company_id_new/common/helpers/app-colors.dart';
import 'package:company_id_new/common/helpers/app-images.dart';
import 'package:company_id_new/common/widgets/app-button/app-button.widget.dart';
import 'package:company_id_new/common/widgets/app-input/app-input.widget.dart';
import 'package:company_id_new/store/actions/auth.action.dart';
import 'package:company_id_new/store/reducers/reducer.dart';
import 'package:company_id_new/store/store.dart';

class ForgotPasswordLinkScreen extends StatefulWidget {
  @override
  State<ForgotPasswordLinkScreen> createState() =>
      ForgotPasswordLinkScreenState();
}

class ForgotPasswordLinkScreenState extends State<ForgotPasswordLinkScreen> {
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
                        const Text('Forgot password',
                            style: TextStyle(
                                color: AppColors.main,
                                fontSize: 24,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(height: 24),
                        AppInput(
                            myController: _emailController, labelText: 'Email'),
                        const SizedBox(height: 16),
                        Align(
                            alignment: Alignment.center,
                            child: AppButtonWidget(
                                width: 140,
                                title: 'Get link',
                                isLoading: isLoading,
                                onClick: () {
                                  store.dispatch(ForgotPasswordSendLinkPending(
                                      _emailController.text));
                                }))
                      ])
                    ]),
              ))));
}
