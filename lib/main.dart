import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MyHomePage(title: 'FIREBASE'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    var users = FirebaseFirestore.instance.collection('idebaby');

    Future<void> addUser() {
      return users
          .add({'name': 'name4', 'votes': 1, 'age': 2})
          .then((value) => print('User Added'))
          .catchError((error) => print('Failed to add user: $error'));
    }

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(onPressed: addUser, child: Text('입력 add')),
                ElevatedButton(onPressed: () {}, child: Text('삭제')),
                OutlinedButton(onPressed: () {}, child: Text('수정')),
                FloatingActionButton(onPressed: () {}, mini: true, child: Text('읽기목록', textAlign: TextAlign.center))
              ],
            ),
            GetUserName('docidwhat', users),
          ],
        ),
      ),
    );
  }
}

//One-time Read
class GetUserName extends StatelessWidget {
  final String documentId;
  final CollectionReference babyuser;

  GetUserName(this.documentId, this.babyuser);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: babyuser.doc(documentId).get(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }
        if (snapshot.connectionState == ConnectionState.done) {
          var data = snapshot.data!.data();
          return Text('Name: $data');
        }

        return Text('loading');
      },
    );
  }
}

// Realtime changes
// class UserInformation extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     var users = FirebaseFirestore.instance.collection('users');
//     return StreamBuilder<QuerySnapshot>(
//       stream: users.snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.hasError) return Text('Something went wrong');
//         if (snapshot.connectionState == ConnectionState.waiting) return Text('Loading');
//         return ListView(
//           children: snapshot.data!.docs.map((DocumentSnapshot document) {
//             return ListTile(
//               title: Text(document.data()!['full_name']),
//               subtitle: Text(document.data()!['company']),
//             );
//           }).toList(),
//         );
//       },
//     );
//   }
// }
