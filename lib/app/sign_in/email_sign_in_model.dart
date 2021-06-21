import 'package:time_tracker_flutter_course/app/sign_in/validator.dart';

enum EmailSignInFormType { signIn, register }

class EmailSignInModel with EmailAndPasswordValidators{
  EmailSignInModel(
      {
        this.email = '',
      this.password = '',
      this.formType = EmailSignInFormType.signIn,
      this.isLoading = false,
      this.isSubmitted = false,
      });
  final String email;
  final String password;
  final EmailSignInFormType formType;
  final bool isLoading;
  final bool isSubmitted;
  EmailSignInModel copyWith({
    String email,
    String password,
    EmailSignInFormType formType,
    bool isLoading,
    bool isSubmitted,
}) {
return EmailSignInModel(
  email: email ?? this.email,
  password: password ?? this.password,
  formType: formType ?? this.formType,
  isLoading: isLoading ?? this.isLoading,
  isSubmitted:  isSubmitted ?? this.isSubmitted,
);
}
String get primaryButtonText {
    return formType == EmailSignInFormType.signIn
        ? 'signIn'
        : 'Create an account';
}
String get secondaryButtonText {
return formType == EmailSignInFormType.signIn
    ? 'Need an account ? register'
    : 'Have an Account SignIn';
}
bool get canSubmit {
return emailValidator.isValid(email) &&
  passwordValidator.isValid(password) &&
  !isLoading;
}
String get passwordErorText {
  bool showErrorText =
      isSubmitted && !passwordValidator.isValid(password);
  return showErrorText ? invalidPasswordText : null;
}
String get emailErrorText {
  bool showErrorText = isSubmitted && emailValidator.isValid(email);
  return showErrorText ? invalidEmailText : null;
}
}
