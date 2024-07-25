import 'package:flutter/material.dart';
import 'package:qr_covid/views/InserisciView.dart';
import 'package:qr_covid/views/RegistrationScreen.dart';
import 'package:qr_covid/views/dashboard.dart';
import 'package:qr_covid/views/login_view.dart';
import 'package:qr_covid/views/result_view.dart';

import 'views/link.dart';

class Application extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NOPAPER',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'TTNorms'),
      initialRoute: LoginView.routeName,
      //onGenerateInitialRoutes: ,
      onGenerateRoute: (settings) {
        print("Requesting: ${settings.name} ");
        if (settings.name == Dashboard.routeName) {
          return MaterialPageRoute(builder: (context) {
            return Dashboard(user: settings.arguments);
          });
        } else if (settings.name == RegistrationScreen.routeName) {
          return MaterialPageRoute(builder: (context) {
            return RegistrationScreen();
          });
        } else if (settings.name == Link.routeName ||
            settings.name.contains(Link.routeName + "?")) {
          final settingsUri = Uri.parse(settings.name);
          final postID = settingsUri.queryParameters['id'];
          return MaterialPageRoute(builder: (context) {
            return Link(userUid: postID);
          });
        } else if (settings.name == Inserisciview.routeName) {
          return MaterialPageRoute(builder: (context) {
            return Inserisciview(user: settings.arguments);
          });
        } else if (settings.name == LoginView.routeName) {
          return MaterialPageRoute(builder: (context) {
            return LoginView();
          });
        } else if (settings.name == ResultView.routeName) {
          Map<String, Object> data = settings.arguments;
          return MaterialPageRoute(builder: (context) {
            return ResultView(
              model: data == null ? null : data["model"],
              data: data == null ? null : data["data"],
            );
          });
        }
        return MaterialPageRoute(builder: (context) {
          return LoginView(
              // title: args.title,
              //  message: args.message,
              );
        });
      },
      // routes: {
      //   LoginView.routeName: (context) => LoginView(),
      //   RegistrationScreen.routeName: (context) => RegistrationScreen(),
      // },
      home: Dashboard(),
    );
  }
}
