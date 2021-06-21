import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/sign_in/email_sign_in_form_stateful.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

class MockAuth extends Mock implements AuthBase {}

void main() {
  MockAuth mockAuth;
  setUp(() {
    mockAuth = MockAuth();
  });

  Future<void> pumpEmailSIgnInForm(WidgetTester tester) async {
    await tester.pumpWidget(Provider<AuthBase>(
      create: (_) => mockAuth,
      child: MaterialApp(
        home: Scaffold(
          body: EmailSignInFormStateful(),
        ),
      ),
    ));
  }
group('sign in', (){
  testWidgets(' Testing with empty email and password', (WidgetTester tester) async {
    await pumpEmailSIgnInForm(tester);
    final signInButton = find.text('Sign in');
    await tester.tap(signInButton);
    verifyNever(mockAuth.signInWithEmailAndPassword(any, any));
  });
  testWidgets(' Testing with  email and password', (WidgetTester tester) async {
    await pumpEmailSIgnInForm(tester);
    const email = 'test@gmail.com';
    const password = 'password';
    final emailField = find.byKey(Key('email'));
    expect(emailField, findsOneWidget);
    await tester.enterText(emailField, email);
    final passwordField = find.byKey(Key('password'));
    expect(passwordField, findsOneWidget);
    await tester.enterText(passwordField, password);
   await tester.pump();
    final signInButton = find.text('Sign in');
    await tester.tap(signInButton);
    verify(mockAuth.signInWithEmailAndPassword(email, password)).called(1);
  });

});

  group('sign in', (){
    testWidgets(' tapping on secondary button', (WidgetTester tester) async {
      await pumpEmailSIgnInForm(tester);
      final registerButton = find.text('Need an account ? register');
      await tester.tap(registerButton);
      await tester.pump();
      final createAccountButton = find.text('Create an account');
      expect(createAccountButton, findsOneWidget);
      //verifyNever(mockAuth.signInWithEmailAndPassword(any, any));
    });
    testWidgets(' Creating an account with email and password', (WidgetTester tester) async {
      await pumpEmailSIgnInForm(tester);
      const email = 'test@gmail.com';
      const password = 'password';
      final registerButton = find.text('Need an account ? register');
      await tester.tap(registerButton);
      await tester.pump();
      final emailField = find.byKey(Key('email'));
      expect(emailField, findsOneWidget);
      await tester.enterText(emailField, email);
      final passwordField = find.byKey(Key('password'));
      expect(passwordField, findsOneWidget);
      await tester.enterText(passwordField, password);
      await tester.pump();
      final createAccountButton = find.text('Create an account');
      expect(createAccountButton, findsOneWidget);
      verify(mockAuth.createUserWithEmailAndPassword(email, password)).called(1);
    });
  });
}
