import 'package:company_id_new/store/models/sign-up.model.dart';
import 'package:company_id_new/store/models/user.model.dart';

class CheckTokenPending {}

class CheckTokenSuccess {
  const CheckTokenSuccess(this.user);
  final UserModel user;
}

class SignInPending {
  const SignInPending(this.email, this.password);
  final String email;
  final String password;
}

class SignInSuccess {
  const SignInSuccess(this.user);
  final UserModel user;
}

class SignInError {}

class LogoutPending {}

class LogoutSuccess {}

class GetSignUpLinkPending {
  const GetSignUpLinkPending(this.email);
  final String email;
}

class GetSignUpLinkSuccess {}

class GetSignUpLinkError {}

class SignupPending {
  const SignupPending(this.signup);
  final SignupModel signup;
}

class SignupSuccess {}

class SignupError {}
