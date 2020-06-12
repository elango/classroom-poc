import 'package:class_room/services/api_services.dart';
import 'package:class_room/services/mobile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final signIn = useMemoized(
      () => setupGoogleSignIn(
        scopes: [],
      ),
    );

    final accessToken = useState('');
    final username = useState('');
    final courses = useState([]);

    final onSignIn = () async {
      ApiService apiService = ApiService();

      final credentials = await signIn.signIn();
      final user = await signIn.getCurrentUser();

      accessToken.value = credentials.accessToken;
      username.value = user.displayName;

      await apiService.updateClientInfo('Bearer ${credentials.accessToken}');
      List courses_ = await apiService.getCourseList();

      if (courses_.length > 0) {
        courses.value = courses_;
      }
    };

    Widget courseList(BuildContext context) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: courses.value.length,
        itemBuilder: (context, index) {
          return Container(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(courses.value[index]['name'], style: TextStyle(color: Colors.blue, fontSize: 20, fontWeight: FontWeight.bold)),
                Text('Section: ${courses.value[index]['section']}', style: TextStyle(fontSize: 14)),
                SizedBox(
                  height: 4,
                )
              ],
            ),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('My Classroom'),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: accessToken.value == ''
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    child: Text('Sign In with Google'),
                    onPressed: onSignIn,
                  )
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(12),
                    child: Text('Student: ${username.value}', style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                  courseList(context)
                ],
              ),
      ),
    );
  }
}
