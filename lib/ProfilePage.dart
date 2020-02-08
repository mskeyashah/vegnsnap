import 'package:flutter/material.dart';
import 'package:VeggieBuddie/loginPage.dart';
import 'package:firebase_database/firebase_database.dart';

final databaseReference = FirebaseDatabase.instance.reference();

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

Map<String, bool> values = {
  'Soybeans': false,
  'Crustacean shellfish': false,
  'Peanuts': false,
  'Tree nuts': false,
  'Fish': false,
  'Wheat': false,
  'Eggs': false,
  'Milk': false,
};

Future test() async{
  databaseReference.once().then((DataSnapshot snapshot) {
    var em1 = email.substring(0,email.indexOf('@'));
    values=Map<String,bool>.from(snapshot.value[em1]['food']);
  });
}

class Profile extends StatefulWidget {
  Profile({Key key, this.title}) : super(key: key);
  final String title;
  ProfilePage createState() => ProfilePage();
}

class ProfilePage extends State<Profile> {
  var _result;
  @override
  void initState() {
    /* WidgetsBinding.instance.addPostFrameCallback((_) async {
            await test();
          }); */
    test().then((result){
      setState(() {
        _result = result;
      });
      print("Data retrived");
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    if(_result==null)
    {
      print("Fetching");
    }
    return Stack(children: <Widget>[
      Scaffold(
          key: _scaffoldKey,
          body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [Colors.blue[400], Colors.blue[100]],
                ),
              ),

              child: Container(
                  child: Column(

                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[

                        SizedBox(height: 20),
                        Row(
                            children: [
                              SizedBox(width: 10),
                              Column(
                                  children: [

                                    CircleAvatar(
                                      backgroundImage: NetworkImage(
                                        imageUrl,
                                      ),
                                      radius: 45,
                                      backgroundColor: Colors.transparent,

                                    )
                                  ] ),
                              SizedBox(width: 10),
                              Column(

                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 10),
                                    Text(
                                      'NAME: ',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black54),
                                    ),
                                    Text(
                                      name,
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.deepPurple,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'EMAIL: ',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black54),
                                    ),
                                    Text(
                                      email,
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.deepPurple,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 5),

                                    RaisedButton(
                                      onPressed: () {
                                        signOutGoogle();
                                        runApp(LoginPage());
                                      },
                                      color: Colors.deepPurple,
                                      child: Padding(
                                        padding: const EdgeInsets.all(1.0),
                                        child: Text(
                                          'Sign Out',
                                          style: TextStyle(fontSize: 18, color: Colors.white),
                                        ),
                                      ),
                                      elevation: 5,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(40)),
                                    )
                                  ])
                            ]),
                        SizedBox(height: 15),
                        Text(
                          '  Scroll down and select the ingredients you      ',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        Text(
                          'are allergic to.',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),

                        Expanded(
                            child: Stack(children: <Widget>[
                              ListView(
                                children: values.keys.map(
                                      (String key) {
                                    return new CheckboxListTile(
                                      activeColor: Colors.deepPurple,
                                      title: new Text(key),
                                      value: values[key],
                                      onChanged: (bool value) {
                                        setState(() {
                                          values[key] = value;
                                        });
                                      },
                                    );
                                  },
                                ).toList(),

                              ),
                            ])),
                        Padding(
                            padding: EdgeInsets.all(10),
                            child: SizedBox(
                                width: 35.0,
                                height: 35.0,
                            child: FloatingActionButton(
                              backgroundColor: Colors.deepPurple,
                              onPressed: () async {
                                await createRecord();
                              },
                              child: Icon(Icons.check),
                            )
                        ))])))),
    ]);
  }

  Future createRecord() async {
    databaseReference.child(index).update({'food': values});
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Changes saved!")));
  }
}
