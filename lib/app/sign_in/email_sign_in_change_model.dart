import 'package:flutter/cupertino.dart';
import 'package:time_tracker_flutter_course/app/sign_in/email_sign_in_model.dart';
import 'package:time_tracker_flutter_course/app/sign_in/validator.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';



class EmailSignInChangeModel with EmailAndPasswordValidators, ChangeNotifier{
  EmailSignInChangeModel(
      {
        @required this.auth,
        this.email = '',
        this.password = '',
        this.formType = EmailSignInFormType.signIn,
        this.isLoading = false,
        this.isSubmitted = false,
      });
  final AuthBase auth;
   String email;
   String password;
   EmailSignInFormType formType;
   bool isLoading;
   bool isSubmitted;
  Future<void> submit() async {
    updateWith(isSubmitted: true, isLoading: true);
    try {
      await Future.delayed(Duration(seconds: 3));
      if (formType == EmailSignInFormType.signIn) {
        await auth.signInWithEmailAndPassword(email, password);
      } else {
        await auth.createUserWithEmailAndPassword(
            email, password);
      }
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }
  }

  void toggleFormType() {
    updateWith(
      email: '',
      password: '',
      formType: this.formType == EmailSignInFormType.signIn
          ? EmailSignInFormType.register
          : EmailSignInFormType.signIn,
      isSubmitted: false,
      isLoading: false,
    );
  }

  void updateEmail(String email) => updateWith(email: email);
  void updatePassword(String password) => updateWith(password: password);
  void updateWith({
    String email,
    String password,
    EmailSignInFormType formType,
    bool isLoading,
    bool isSubmitted,
  }) {

      this.email= email ?? this.email;
    this.password= password ?? this.password;
    this.formType= formType ?? this.formType;
    this.isLoading= isLoading ?? this.isLoading;
    this.isSubmitted=  isSubmitted ?? this.isSubmitted;
    notifyListeners();

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
  String get passwordErrorText {
    bool showErrorText =
        isSubmitted && !passwordValidator.isValid(password);
    return showErrorText ? invalidPasswordText : null;
  }
  String get emailErrorText {
    bool showErrorText = isSubmitted && emailValidator.isValid(email);
    return showErrorText ? invalidEmailText : null;
  }
}
