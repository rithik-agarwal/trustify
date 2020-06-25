import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import './MyMap.dart';
import './MyMap2.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {

  

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double lat;
  double long;
  List<String> codes=["pcf001","pcf002","pcf003","pcf004","pcf005","pcf006","pcf007"];
void location() async
  {
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    
    setState(() {
        lat=position.latitude;
    long=position.longitude;
    print(lat);
     
    });
}
@override
void initState()
{
  super.initState();
  location();
}
  @override
  Widget build(BuildContext context) {
 
    return Scaffold(
      appBar: AppBar(
    
        title: Text('Map Work'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: codes.length,
        itemBuilder: (ctx,i) => GestureDetector(child: Text(codes[i]),onTap: () {
           Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => MyMap(codes[i])));
        },),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
           Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => MyMap2()));
          },
        
        tooltip: 'Map view',
        child: Icon(Icons.map),
      ),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
