import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:time_tracker_flutter_course/app/sign_in/email_sign_in_change_model.dart';
import 'package:time_tracker_flutter_course/custom_widgets/form_submit_button.dart';
import 'package:time_tracker_flutter_course/custom_widgets/platform_exception_alert_dialog.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

class EmailSignInFormChangeNotifier extends StatefulWidget {
  EmailSignInFormChangeNotifier({@required this.model});
  final EmailSignInChangeModel model;

  static Widget create(BuildContext context) {
    final AuthBase auth = Provider.of<AuthBase>(context, listen: false);
    return ChangeNotifierProvider<EmailSignInChangeModel>(
      create: (context) => EmailSignInChangeModel(auth: auth),
      child: Consumer<EmailSignInChangeModel>(
        builder: (context, model, _) =>
            EmailSignInFormChangeNotifier(model: model),
      ),
    );
  }

  @override
  _EmailSignInFormState createState() => _EmailSignInFormState();
}

class _EmailSignInFormState extends State<EmailSignInFormChangeNotifier> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  List<Widget> _buildChildren() {
    return [
      TextField(
        controller: _emailController,
        focusNode: _emailFocusNode,
        decoration: InputDecoration(
          labelText: 'Email',
          hintText: 'test@gmsil.com',
          errorText: widget.model.emailErrorText,
          enabled: widget.model.isLoading == false,
        ),
        autocorrect: false,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        onEditingComplete: () => _emailEditingComplete(),
        onChanged: widget.model.updateEmail,
      ),
      SizedBox(height: 8.0),
      TextField(
        controller: _passwordController,
        focusNode: _passwordFocusNode,
        decoration: InputDecoration(
          labelText: 'Password',
          errorText: widget.model.passwordErrorText,
          enabled: widget.model.isLoading == false,
        ),
        obscureText: true,
        textInputAction: TextInputAction.done,
        onEditingComplete: _submit,
        onChanged: widget.model.updatePassword,
      ),
      SizedBox(height: 8.0),
      FormSubmitButton(
        text: widget.model.primaryButtonText,
        onPressed: widget.model.canSubmit ? _submit : null,
      ),
      SizedBox(height: 8.0),
      FlatButton(
        onPressed: !widget.model.isLoading ? _toggleFormType : null,
        child: Text(widget.model.secondaryButtonText),
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
      await widget.model.submit();
      Navigator.of(context).pop();
    } catch (e) {
      print(e.message);
      PlatformExceptionAlertDialog(
        title: 'SIgn in failed',
        exception: e,
      ).show(context);
    }
  }

  void _toggleFormType() {
    widget.model.toggleFormType();

    _emailController.clear();
    _passwordController.clear();
  }

  void _emailEditingComplete() {
    final newFocus = widget.model.emailValidator.isValid(widget.model.email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: _buildChildren(),
      ),
    );
  }
}
