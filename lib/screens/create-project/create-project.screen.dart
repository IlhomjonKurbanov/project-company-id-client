import 'package:company_id_new/common/helpers/app-colors.dart';
import 'package:company_id_new/common/helpers/app-converters.dart';
import 'package:company_id_new/common/helpers/app-enums.dart';
import 'package:company_id_new/common/helpers/app-validators.dart';
import 'package:company_id_new/common/widgets/app-input/app-input.widget.dart';
import 'package:company_id_new/common/widgets/stack/stack.widget.dart';
import 'package:company_id_new/store/actions/projects.action.dart';
import 'package:company_id_new/store/actions/stack.action.dart';
import 'package:company_id_new/store/actions/users.action.dart';
import 'package:company_id_new/store/models/project.model.dart';
import 'package:company_id_new/store/models/stack.model.dart';
import 'package:company_id_new/store/models/user.model.dart';
import 'package:company_id_new/store/reducers/reducer.dart';
import 'package:company_id_new/store/store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class _ViewModel {
  _ViewModel({required this.stack, required this.users, required this.user});
  List<StackModel> stack;
  List<UserModel> users;
  UserModel user;
}

class CreateProjectScreen extends StatefulWidget {
  @override
  _CreateProjectScreenState createState() => _CreateProjectScreenState();
}

class _CreateProjectScreenState extends State<CreateProjectScreen> {
  final TextEditingController _nameController = TextEditingController(text: '');
  final TextEditingController _customerController =
      TextEditingController(text: '');
  final TextEditingController _industryController =
      TextEditingController(text: '');
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DateTime _selectedDate = DateTime.now();
  final TextEditingController _startDateController =
      TextEditingController(text: '');
  List<StackModel> savedStack = <StackModel>[];
  List<UserModel> savedUsers = <UserModel>[];
  bool _isActivity = false;
  bool _isInternal = false;
  String error = '';

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, _ViewModel>(
      converter: (Store<AppState> store) => _ViewModel(
          stack: store.state.stack,
          users: store.state.usersForCreatingProject,
          user: store.state.user!),
      onInit: (Store<AppState> store) {
        store.dispatch(
            GetUsersPending(false, usersType: UsersType.CreateProject));
        store.dispatch(GetStackPending());
      },
      builder: (BuildContext context, _ViewModel state) => Scaffold(
          floatingActionButton: FloatingActionButton(
              onPressed: () => _addProject(state),
              child: const Icon(Icons.add)),
          body: Padding(
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
              child: Form(
                  key: _formKey,
                  child: ListView(children: <Widget>[
                    AppInput(
                        myController: _nameController,
                        labelText: 'Name',
                        validator: (String? value) =>
                            AppValidators.validateIsEmpty(
                                value, 'Please enter name')),
                    const SizedBox(height: 16),
                    AppInput(
                        myController: _customerController,
                        validator: (String? value) =>
                            AppValidators.validateIsEmpty(
                                value, 'Please enter customer'),
                        labelText: 'Customer'),
                    const SizedBox(height: 16),
                    AppInput(
                        validator: (String? value) =>
                            AppValidators.validateIsEmpty(
                                value, 'Please enter industry'),
                        myController: _industryController,
                        labelText: 'Industry'),
                    const SizedBox(height: 16),
                    _isActivityProject(),
                    _isInternalProject(),
                    const SizedBox(height: 16),
                    const Text('Select stack',
                        style: TextStyle(color: Colors.white)),
                    const SizedBox(height: 16),
                    _buildStack(state.stack),
                    const SizedBox(height: 16),
                    const Text('Select users',
                        style: TextStyle(color: Colors.white)),
                    const SizedBox(height: 16),
                    _buildUsers(state.users),
                    const SizedBox(height: 16),
                    GestureDetector(
                        onTap: () => _chooseDate(),
                        child: AbsorbPointer(
                            child: AppInput(
                                validator: (String? value) =>
                                    AppValidators.validateIsEmpty(
                                        value, 'Please enter start date'),
                                myController: _startDateController,
                                labelText: 'Start date'))),
                    const SizedBox(height: 16)
                  ])))));

  Widget _isActivityProject() =>
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
        const Text('Is activity project ?', style: TextStyle(fontSize: 16)),
        Switch(
            activeTrackColor: AppColors.main,
            activeColor: AppColors.main,
            value: _isActivity,
            onChanged: (bool value) {
              setState(() => _isActivity = value);
            })
      ]);

  Widget _isInternalProject() =>
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
        const Text('Is internal project ?', style: TextStyle(fontSize: 16)),
        Switch(
            activeTrackColor: AppColors.main,
            activeColor: AppColors.main,
            value: _isInternal,
            onChanged: (bool value) {
              setState(() => _isInternal = value);
            })
      ]);

  void _addProject(_ViewModel state) {
    if (savedStack.isEmpty) {
      setState(() {
        error = 'Please choose at list one stack';
      });
    }
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (savedStack.isEmpty) {
      setState(() {
        error = 'Please choose at list one stack';
      });
      return;
    } else {
      setState(() {
        error = '';
      });
    }
    store.dispatch(CreateProjectPending(ProjectModel(
        industry: _industryController.text,
        name: _nameController.text,
        stack: savedStack,
        customer: _customerController.text,
        isInternal: _isInternal,
        isActivity: _isActivity,
        startDate: _selectedDate,
        onboard: savedUsers)));
  }

  Widget _buildUsers(List<UserModel> users) => Wrap(
      children: users
          .map((UserModel user) => GestureDetector(
              onTap: () => _onTapUser(user),
              child: StackWidget(
                  title: '${user.name} ${user.lastName}',
                  color: savedUsers.contains(user)
                      ? AppColors.main
                      : AppColors.main.withOpacity(0.5))))
          .toList());

  void _onTapUser(UserModel user) {
    setState(() {
      if (savedUsers.contains(user)) {
        savedUsers
            .removeWhere((UserModel savedUser) => user.id == savedUser.id);
      } else {
        savedUsers.add(user);
      }
    });
  }

  Widget _buildStack(List<StackModel> stack) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
        Wrap(
          children: stack
              .map((StackModel stack) => GestureDetector(
                  onTap: () => _onTapStack(stack),
                  child: StackWidget(
                      title: stack.name,
                      color: savedStack.contains(stack)
                          ? AppColors.main
                          : AppColors.main.withOpacity(0.5))))
              .toList(),
        ),
        error.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.only(top: 8),
                child:
                    Text(error, style: const TextStyle(color: AppColors.main)))
            : const SizedBox()
      ]);

  void _onTapStack(StackModel stack) {
    setState(() {
      if (savedStack.contains(stack)) {
        savedStack
            .removeWhere((StackModel savedStack) => stack.id == savedStack.id);
        if (savedStack.isEmpty) {
          error = 'Please choose at list one stack';
        }
      } else {
        savedStack.add(stack);
        error = '';
      }
    });
  }

  Future<void> _chooseDate() async {
    final DateTime today = DateTime.now();
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: today,
        firstDate: DateTime(1950, 8),
        lastDate: today,
        builder: (BuildContext context, Widget? child) => Theme(
            data: Theme.of(context).copyWith(
              primaryColor: AppColors.semiGrey,
              colorScheme: const ColorScheme.light(
                  primary: AppColors.main, onSurface: Colors.white),
            ),
            child: child!));
    if (picked != null && picked != _selectedDate)
      setState(() {
        _startDateController.text =
            AppConverters.dateFromString(picked.toString());
        _selectedDate = picked;
      });
  }
}
