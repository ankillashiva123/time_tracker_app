import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/sign_in/email_sign_in_bloc.dart';
import 'package:time_tracker_flutter_course/custom_widgets/form_submit_button.dart';
import 'package:time_tracker_flutter_course/custom_widgets/platform_exception_alert_dialog.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';
import 'email_sign_in_model.dart';

class EmailSignInFormBlocBased extends StatefulWidget {
  EmailSignInFormBlocBased({@required this.bloc});
  final EmailSIgnInBloc bloc;

  static Widget create(BuildContext context) {
    final AuthBase auth = Provider.of<AuthBase>(context, listen: false);
    return Provider<EmailSIgnInBloc>(
      create: (context) => EmailSIgnInBloc(auth: auth),
      child: Consumer<EmailSIgnInBloc>(
        builder: (context, bloc, _) => EmailSignInFormBlocBased(bloc: bloc),
      ),
      dispose: (context, bloc) => bloc.dispose(),
    );
  }

  @override
  _EmailSignInFormState createState() => _EmailSignInFormState();
}

class _EmailSignInFormState extends State<EmailSignInFormBlocBased> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();



  List<Widget> _buildChildren(EmailSignInModel model) {




    return [
      TextField(
        controller: _emailController,
        focusNode: _emailFocusNode,
        decoration: InputDecoration(
          labelText: 'Email',
          hintText: 'test@gmsil.com',
          errorText: model.emailErrorText,
          enabled: model.isLoading == false,
        ),
        autocorrect: false,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        onEditingComplete: () => _emailEditingComplete(model),
        onChanged:  widget.bloc.updateEmail,
      ),
      SizedBox(height: 8.0),
      TextField(
        controller: _passwordController,
        focusNode: _passwordFocusNode,
        decoration: InputDecoration(
          labelText: 'Password',
          errorText: model.passwordErorText,
          enabled: model.isLoading == false,
        ),
        obscureText: true,
        textInputAction: TextInputAction.done,
        onEditingComplete: _submit,
        onChanged:  widget.bloc.updatePassword,
      ),
      SizedBox(height: 8.0),
      FormSubmitButton(
        text: model.primaryButtonText,
        onPressed: model.canSubmit ? _submit : null,
      ),
      SizedBox(height: 8.0),
      FlatButton(
        onPressed: !model.isLoading ?  _toggleFormType : null,
        child: Text(model.secondaryButtonText),
      ),
    ];
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _submit() async {

    try {
      await widget.bloc.submit();
      Navigator.of(context).pop();
    } catch (e) {
      print(e.message);
      PlatformExceptionAlertDialog(
        title: 'SIgn in failed',
        exception: e,
      ).show(context);
    } finally {

    }
  }

  void _toggleFormType() {
    widget.bloc.toggleFormType();

    _emailController.clear();
    _passwordController.clear();
  }

  void _emailEditingComplete(EmailSignInModel model) {
    final newFocus = model.emailValidator.isValid(model.email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }



  @override
  Widget build(BuildContext context) {
    return StreamBuilder<EmailSignInModel>(
        stream: widget.bloc.modelStream,
        initialData: EmailSignInModel(),
        builder: (context, snapshot) {
          final EmailSignInModel model = snapshot.data;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: _buildChildren(snapshot.data),
            ),
          );
        });
  }
}
