import 'package:flutter/material.dart';
import 'package:sqlite_example/DatabaseHelper/database_helper.dart';
import 'package:sqlite_example/Table/database.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  var _user = User();

  List<User> list = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameController.dispose();
    descriptionController.dispose();
  }

  void delete(int id){
    DatabaseHelper.databaseHelper.delete(id);
    setState(() {
      getdata();
    });
  }

  void getdata() {
    list.clear();
    DatabaseHelper.databaseHelper.getallrecord().then((value) {
      setState(() {
        value.forEach((element) {
          list.add(User(
              id: element['id'],
              name: element['name'],
              description: element['description']));
        });
      });
    });
  }

  void add_data() async {
    String name = nameController.text;
    String description = descriptionController.text;

    int res = await DatabaseHelper.databaseHelper
        .insert(User(name: name, description: description));
    setState(() {
      list.add(User(id: res, name: name, description: description));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Home Page'),
        ),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: SingleChildScrollView(
                        child: Container(
                          child: Form(
                            key: formKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: nameController,
                                  decoration: InputDecoration(
                                      hintText: "Name",
                                      border: OutlineInputBorder()),
                                ),
                                TextFormField(
                                  controller: descriptionController,
                                  decoration: InputDecoration(
                                      hintText: "Description",
                                      border: OutlineInputBorder()),
                                ),
                                RaisedButton(
                                  child: Text('Done'),
                                  onPressed: () {
                                    if (formKey.currentState.validate()) {
                                      formKey.currentState.save();
                                      _user.name = nameController.text;
                                      _user.description =
                                          descriptionController.text;
                                      add_data();
                                      Navigator.of(context).pop();
                                      nameController.clear();
                                      descriptionController.clear();
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  });
            }),
        body: Column(
          children: [
            Expanded(
              child: Container(
                child: ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context,int index) {
                      return ListTile(
                        leading: CircleAvatar(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(list[index].name[0].toUpperCase()),
                              Text(list[index].description[0].toUpperCase()),
                            ],
                          ),
                        ),
                        title: Text(
                          list[index].name,
                          style: TextStyle(fontSize: 25),
                        ),
                        subtitle: Text(list[index].description),
                        trailing: IconButton(icon: Icon(Icons.delete_forever,color: Colors.deepPurple[200],size: 25.0,),
                          onPressed: () {
                          setState(() {
                            delete(list[index].id);
                          });
                        }),
                      );
                    }),
              ),
            )
          ],
        ));
  }
}
