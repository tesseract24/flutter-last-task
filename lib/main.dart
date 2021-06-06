import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';

class API {
  final String name;
  final String age;
  final String gender;
  final String email;
  final String phone;
  final String img;

  API(this.name, this.age, this.gender, this.email, this.phone, this.img);
}

void main() async {
  var dio = Dio();
  final response = await dio.get('https://randomuser.me/api/?results=15');
  var Users = response.data['results'];
  // print(Users);
  runApp(
    MaterialApp(
      title: 'API',
      home: APIsScreen(
        apis: List.generate(
          15,
          (i) => API(
            Users[i]['name']['title'] + ' ' + Users[i]['name']['first'] + ' ' + Users[i]['name']['last'],
            Users[i]['dob']['age'].toString(),
            Users[i]['gender'],
            Users[i]['email'],
            Users[i]['phone'].toString(),
            Users[i]['picture']['large'],
          ),
        ),
      ),
    ),
  );
}

class APIsScreen extends StatelessWidget {
  final List<API> apis;

  APIsScreen({Key? key, required this.apis}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Users List'),
      ),
      body: ListView.builder(
        // padding: EdgeInsets.all(10),
        padding: EdgeInsets.fromLTRB(2, 15, 2, 15),

        itemCount: apis.length,
        itemBuilder: (context, index) {
          return ListTile(
            // padding: EdgeInsets.fromLTRB(2, 5, 2, 5),
            leading: CircleAvatar(radius: 30, backgroundImage: NetworkImage(apis[index].img)),
            title: Text(apis[index].name, style: TextStyle(fontSize: 22)),
            contentPadding: EdgeInsets.symmetric(vertical: 10.0),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailScreen(),
                  settings: RouteSettings(
                    arguments: apis[index],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final api = ModalRoute.of(context)!.settings.arguments as API;
    return Scaffold(
      appBar: AppBar(
        title: Text(api.name),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CircleAvatar(radius: 100, backgroundImage: NetworkImage(api.img)),
          Text("Name: " + api.name, style: TextStyle(fontSize: 20)),
          Text("Gender: " + api.gender, style: TextStyle(fontSize: 20)),
          Text("Age: " + api.age, style: TextStyle(fontSize: 20)),
          Text("Email: " + api.email, style: TextStyle(fontSize: 20)),
          Text("Phone: " + api.phone, style: TextStyle(fontSize: 20))
        ],
      ),
    );
  }
}
