import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/home/home_page.dart';
import 'package:time_tracker_flutter_course/services/database.dart';

import 'package:time_tracker_flutter_course/app/sign_in/sign_in_page.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return StreamBuilder(
      stream: auth.onAuthStateChanged,
      // ignore: missing_return
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            User user = snapshot.data;
            if (user.uid.length > 0) {
              return Provider<User>.value(
                value: user,
                child: Provider<Database>(
                    create: (_) => FirestoreDatabase(uid: user.uid),
                    child: HomePage()),
              );
            }
          }
          return SignInPage.create(context);
        }
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
