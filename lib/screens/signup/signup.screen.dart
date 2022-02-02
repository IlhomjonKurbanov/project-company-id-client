// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

// Project imports:
import 'package:company_id_new/common/helpers/app-colors.dart';
import 'package:company_id_new/common/helpers/app-converters.dart';
import 'package:company_id_new/common/helpers/app-helper.dart';
import 'package:company_id_new/common/helpers/app-validators.dart';
import 'package:company_id_new/common/widgets/app-button/app-button.widget.dart';
import 'package:company_id_new/common/widgets/app-input/app-input.widget.dart';
import 'package:company_id_new/store/actions/auth.action.dart';
import 'package:company_id_new/store/models/sign-up.model.dart';
import 'package:company_id_new/store/reducers/reducer.dart';
import 'package:company_id_new/store/store.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen(this.token);
  final String token;
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  File? _file;

  final TextEditingController _englishLevelController =
      TextEditingController(text: '');
  final TextEditingController _nameController = TextEditingController(text: '');
  final TextEditingController _lastNameController =
      TextEditingController(text: '');
  final TextEditingController _skypeController =
      TextEditingController(text: '');
  final TextEditingController _githubController =
      TextEditingController(text: '');
  final TextEditingController _phoneController =
      TextEditingController(text: '');
  final TextEditingController _slackIdController =
      TextEditingController(text: '');
  final TextEditingController _dobController = TextEditingController(text: '');
  final TextEditingController _passwordController =
      TextEditingController(text: '');
  final TextEditingController _cpasswordController =
      TextEditingController(text: '');

  DateTime _selectedDate = DateTime.now();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _errorAvatar = '';

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, bool>(
      converter: (Store<AppState> store) => store.state.isLoading,
      builder: (BuildContext context, bool isLoading) => Scaffold(
          body: Padding(
              padding: const EdgeInsets.only(left: 52, right: 52),
              child: ListView(children: <Widget>[
                const Center(
                    child: Text('Sign Up',
                        style: TextStyle(
                            color: AppColors.main,
                            fontSize: 24,
                            fontWeight: FontWeight.bold))),
                const SizedBox(height: 24),
                InkWell(
                    onTap: () => _imageUpload(),
                    child: Align(
                        alignment: Alignment.center,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(40),
                            child: Container(
                                color: AppColors.main,
                                width: 80,
                                height: 80,
                                child: _file != null
                                    ? Image.file(_file!)
                                    : const Icon(Icons.person_add,
                                        size: 40))))),
                if (_errorAvatar.isNotEmpty)
                  Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Center(
                          child: Text(_errorAvatar,
                              style: const TextStyle(
                                  color: AppColors.main, fontSize: 12)))),
                const SizedBox(height: 24),
                Form(
                    key: _formKey,
                    child: Column(children: <Widget>[
                      AppInput(
                          validator: (String? value) =>
                              AppValidators.validateIsEmpty(
                                  value, 'Please enter name'),
                          myController: _nameController,
                          labelText: 'Name'),
                      const SizedBox(height: 24),
                      AppInput(
                          validator: (String? value) =>
                              AppValidators.validateIsEmpty(
                                  value, 'Please enter last name'),
                          myController: _lastNameController,
                          labelText: 'Last name'),
                      const SizedBox(height: 24),
                      AppInput(
                          validator: (String? value) =>
                              AppValidators.validateIsEmpty(
                                  value, 'Please enter skype'),
                          myController: _skypeController,
                          labelText: 'Skype'),
                      const SizedBox(height: 24),
                      AppInput(
                          validator: (String? value) =>
                              AppValidators.validateIsEmpty(
                                  value, 'Please enter github'),
                          myController: _githubController,
                          labelText: 'Github'),
                      const SizedBox(height: 24),
                      AppInput(
                          validator: (String? value) =>
                              AppValidators.validateIsEmpty(
                                  value, 'Please enter your phone'),
                          myController: _phoneController,
                          labelText: 'Phone'),
                      const SizedBox(height: 24),
                      AppInput(
                          validator: (String? value) =>
                              AppValidators.validateIsEmpty(
                                  value, 'Please enter english level'),
                          myController: _englishLevelController,
                          labelText: 'English level'),
                      const SizedBox(height: 24),
                      AppInput(
                          validator: (String? value) =>
                              AppValidators.validateIsEmpty(
                                  value, 'Please enter slack id'),
                          myController: _slackIdController,
                          labelText: 'Slack Id'),
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
                      InkWell(
                          onTap: () => _chooseDate(),
                          child: AbsorbPointer(
                              child: AppInput(
                                  validator: (String? value) =>
                                      AppValidators.validateIsEmpty(
                                          value, 'Please enter date of birth'),
                                  myController: _dobController,
                                  labelText: 'Date of birth'))),
                      const SizedBox(height: 24)
                    ])),
                Align(
                    alignment: Alignment.center,
                    child: AppButtonWidget(
                        width: 140,
                        title: 'Sign up',
                        isLoading: isLoading,
                        onClick: () {
                          if (_file == null) {
                            _setErrorAvatar('Please enter avatar');
                          } else {
                            _setErrorAvatar('');
                          }
                          if (!_formKey.currentState!.validate() ||
                              _errorAvatar.isNotEmpty) {
                            return;
                          }
                          final SignupModel signup = SignupModel(
                              password: _passwordController.text,
                              avatar: _file!,
                              token: widget.token,
                              slackId: _slackIdController.text,
                              name: _nameController.text,
                              lastName: _lastNameController.text,
                              github: _githubController.text,
                              skype: _skypeController.text,
                              date: _selectedDate,
                              phone: _phoneController.text,
                              englishLevel: _englishLevelController.text);
                          store.dispatch(SignupPending(signup));
                        }))
              ]))));

  Future<void> _imageUpload() async {
    _file = await AppHelper.getCroppedImage(context);
    if (_file != null) {
      _setErrorAvatar('');
    }
    setState(() {});
  }

  void _setErrorAvatar(String error) {
    setState(() {
      _errorAvatar = error;
    });
  }

  Future<void> _chooseDate() async {
    final DateTime? picked = await AppHelper.chooseDate(context);
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _dobController.text = AppConverters.dateFromString(picked.toString());
        _selectedDate = picked;
      });
    }
  }
}
