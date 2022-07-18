import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
      const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: ShowUsers()
      ));
}



class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final controllerName = TextEditingController();
  final controllerEmpid = TextEditingController();
  final controllerPhoneno = TextEditingController();

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text('Add User'),
    ),
    body: ListView(
      padding: EdgeInsets.all(16),
      children: <Widget>[
        TextField(
          controller: controllerName,
          decoration: decoration('Name'),
        ),

        const SizedBox(height: 24),
        TextField(
          controller: controllerEmpid,
          decoration: decoration('Emp Id'),
          keyboardType: TextInputType.number,
        ),

        const SizedBox(height: 32),
        TextField(
          controller: controllerPhoneno,
          decoration: decoration('Phone Number'),
          keyboardType: TextInputType.number,
        ),

        const SizedBox(height: 32),
        ElevatedButton(
          child:Text('Add to Database'),
          onPressed: (){
            final user = User_main(
              name: controllerName.text,
              Emp_id: int.parse(controllerEmpid.text),
              Phone_no: int.parse(controllerPhoneno.text),
            );
            createUser(user);
            // Navigator.pop(context);
          }
        )
      ],
    ),
  );

  InputDecoration decoration(String label) => InputDecoration(
    labelText: label,
    border: OutlineInputBorder(),
  );

  Future createUser(User_main user) async{
    final docUser = FirebaseFirestore.instance.collection('users').doc();
    user.id = docUser.id;

    final json = user.toJson();
    await docUser.set(json);
  }
}
class User_main {
  String id;
  final String name;
  final int Emp_id;
  final int Phone_no;

  User_main({
    this.id='',
    required this.name,
    required this.Emp_id,
    required this.Phone_no,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'Emp_id': Emp_id,
    'phone_no': Phone_no,
  };
  static User_main fromJson(Map<String, dynamic> json) => User_main(
      id: json['id'],
      name: json['name'],
      Emp_id: json['Emp_id'],
      Phone_no: (json['Phone number'])
  );
}





class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: TextField(controller: controller),
      actions: [
        IconButton(
          icon: Icon(Icons.add),
          onPressed: (){
            final name = controller.text;

            createUser(name: name);
          },
        )
      ],
    ),
  );

  Future createUser({required String name}) async{
    final docUser = FirebaseFirestore.instance.collection('users').doc();

    final user = User0(
      id: docUser.id,
      name: name,
      age:21,
    );
    final json = user.toJson();

    await docUser.set(json);
  }
}

class User0{
    String id;
    final String name;
    final int age;

    User0({
      this.id= '',
      required this.name,
      required this.age,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'age': age,
  };
}






class ShowUsers extends StatefulWidget {
  const ShowUsers({Key? key}) : super(key: key);

  @override
  State<ShowUsers> createState() => _ShowUsersState();
}

class _ShowUsersState extends State<ShowUsers> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) =>
      Scaffold(
          appBar: AppBar(
            title: Text('All Users Data'),
          ),

          body: StreamBuilder<List<User>>(
            stream: readUsers(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                // return Text('Something went wrong!' ${snapshot.error});
                return Text('Something went wrong!');
              } else if (snapshot.hasData) {
                final users = snapshot.data!;
                return ListView(
                  children: users.map(buildUser).toList(),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),

          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (constext) => MainPage(),
              ));
            },
          )
      );

  // Future createUser({required String name}) async {
  //   final docUser = FirebaseFirestore.instance.collection('users').doc();
  // }
  //   final json = {}
  // }

  Widget buildUser(User user) =>
      ListTile(
        leading: CircleAvatar(child: Text('${user.Emp_id}')),
        title: Text(user.name),
        subtitle: Text(user.phone_no.toString()),
      );

  Stream<List<User>> readUsers() =>
      FirebaseFirestore.instance
          .collection('users')
          .snapshots()
          .map((snapshot) =>
          snapshot.docs.map((doc) => User.fromJson(doc.data())).toList()
      );
}

class User{
  String id;
  final String name;
  final int Emp_id;
  final int phone_no;

  User({
    this.id ='',
    required this.name,
    required this.Emp_id,
    required this.phone_no,
  });

  Map<String, dynamic> toJson()=> {
    'id': id,
    'name': name,
    'Emp_id':Emp_id,
    'phone_no': phone_no,
  };

  static User fromJson(Map<String, dynamic> json) =>User(
    id: json['id'],
    name: json['name'],
    Emp_id: json['Emp_id'],
    phone_no: json['phone_no'],
  );
}







