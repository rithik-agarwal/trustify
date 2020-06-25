import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_map_polyline/google_map_polyline.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission/permission.dart';
class MyMap extends StatefulWidget {
  final String pcfid;
  MyMap(this.pcfid);
  @override
  _MyMapState createState() => _MyMapState();

}

class _MyMapState extends State<MyMap> {
  List<LatLng> routecord=[];
  GoogleMapPolyline googleMapPolyline=new GoogleMapPolyline(apiKey: 'AIzaSyCS90XB-jQMIhQbA2C9vzfWKETNaxpjWJo');
  var locdata;
  Set<Polyline> polyline={};
  Completer<GoogleMapController> _controller=Completer();
  GoogleMapController _controller1;
  String pcfid;
  Set<Marker> markers={};
  List<Map<String,dynamic>> rightpath= [{'pcfcode':'pcf007','lat':'34.398','lng':'45.3243'},
  {'pcfcode':'pcf007','lat':'35.789','lng':'46.5654'},
  {'pcfcode':'pcf007','lat':'37.8993','lng':'46.70694'},
  {'pcfcode':'pcf007','lat':'39.93343','lng':'48.787844'}
  ];
  List<Map<String,dynamic>> wrongpath= [{'pcfcode':'pcf007','lat':'34.398','lng':'45.3243'},
  {'pcfcode':'pcf007','lat':'35.728','lng':'46.636'},
  {'pcfcode':'pcf007','lat':'37.866','lng':'46.706'},
  {'pcfcode':'pcf007','lat':'39.933','lng':'48.787'}
  ];
  void pathTaken() async
{ var permission=await Permission.getPermissionsStatus([PermissionName.Location]);
  if(permission[0].permissionStatus == PermissionStatus.notAgain)
  {
    var ask=await Permission.requestPermissions([PermissionName.Location]);
  }
  else
  {
    for(int i=0;i<wrongpath.length-1;i++)
    {
    routecord=await googleMapPolyline.getCoordinatesWithLocation(origin:LatLng(double.parse(wrongpath[i]['lat']),double.parse(wrongpath[i]['lng'])) , destination: LatLng(double.parse(wrongpath[i+1]['lat']),double.parse(wrongpath[i+1]['lng'])),mode: RouteMode.walking);
    print(routecord);
    polyline.clear();
      polyline.add(Polyline(
        polylineId: PolylineId('route1'+i.toString()),
        visible: true,
        points:routecord,
        width:4,
        color:Colors.red,
        startCap: Cap.roundCap,
        endCap:Cap.buttCap
      ));
    }
    
       final GoogleMapController controller=await _controller.future;
   controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(double.parse(rightpath[0]['lat']),double.parse(rightpath[0]['lng'])),zoom: 10,tilt: 50,bearing: 45)));

    setState(() {
      print(routecord);
      
    });
 
     
  }
}
  void assignedpath() async
{ var permission=await Permission.getPermissionsStatus([PermissionName.Location]);
  if(permission[0].permissionStatus == PermissionStatus.notAgain)
  {
    var ask=await Permission.requestPermissions([PermissionName.Location]);
  }
  else
  {
    for(int i=0;i<rightpath.length-1;i++)
    {
    routecord=await googleMapPolyline.getCoordinatesWithLocation(origin:LatLng(double.parse(rightpath[i]['lat']),double.parse(rightpath[i]['lng'])) , destination: LatLng(double.parse(rightpath[i+1]['lat']),double.parse(rightpath[i+1]['lng'])),mode: RouteMode.walking);
    print(routecord);
    polyline.clear();
      polyline.add(Polyline(
        polylineId: PolylineId('route1'+i.toString()),
        visible: true,
        points:routecord,
        width:4,
        color:Colors.blue,
        startCap: Cap.roundCap,
        endCap:Cap.buttCap
      ));
    }
    
       final GoogleMapController controller=await _controller.future;
   controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(double.parse(rightpath[0]['lat']),double.parse(rightpath[0]['lng'])),zoom: 10,tilt: 50,bearing: 45)));

    setState(() {
      print(routecord);
      
    });
 
     
  }
}
  @override
  void initState()
  {
    super.initState();
    //make the api call here to get the genuine locations
    for(int i=0;i<rightpath.length;i++)
    {
      if(i==0)
      markers.add(Marker(markerId: MarkerId('marker1'+i.toString()),position: LatLng(double.parse(rightpath[i]['lat']),double.parse(rightpath[i]['lng'])),infoWindow: InfoWindow(title:'Source'),icon:BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue)));
      else if(i==rightpath.length-1)
       markers.add(Marker(markerId: MarkerId('marker1'+i.toString()),position: LatLng(double.parse(rightpath[i]['lat']),double.parse(rightpath[i]['lng'])),infoWindow: InfoWindow(title:'Destination'),icon:BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue)));
      else 
       markers.add(Marker(markerId: MarkerId('marker1'+i.toString()),position: LatLng(double.parse(rightpath[i]['lat']),double.parse(rightpath[i]['lng'])),infoWindow: InfoWindow(title:'Scanned at '+ (i+1).toString()),icon:BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue)));
    }
    for(int i=0;i<wrongpath.length;i++)
    {
       if(i!=0 && i != wrongpath.length-1)    
       markers.add(Marker(markerId: MarkerId('marker2'+i.toString()),position: LatLng(double.parse(wrongpath[i]['lat']),double.parse(wrongpath[i]['lng'])),infoWindow: InfoWindow(title:'Scan number '+(i+1).toString()),icon:BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed)));
    }
  }
  @override
  Widget build(BuildContext context) {
    pcfid=widget.pcfid;
    
     return Scaffold(appBar: AppBar(title: Text('Map overview'),),body:  Stack(children:<Widget>[GoogleMap(
      onMapCreated: onMapcreated,
      polylines:polyline,
      initialCameraPosition: CameraPosition(target:LatLng(double.parse(rightpath[0]['lat']),double.parse(rightpath[0]['lng'])),zoom: 14.0),
      mapType: MapType.normal,
      markers: markers,
      

    ),buildContainer()]));
  }
  void onMapcreated(GoogleMapController controller)
  {print('Onmaopcrtagbudj');
    _controller.complete(controller);
    setState(() {
      _controller1=controller;
     
      
    });
}

Widget buildContainer()
{
  return Align(
      alignment: Alignment.bottomLeft,
      child:Container(margin: EdgeInsets.symmetric(vertical:20),
      height: 150,
      width:double.infinity,
      child: Container(height:150,width:double.infinity,child:Center(
        child:Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  children: <Widget>[
    Padding(padding: const EdgeInsets.only(left: 8.0),
    child:Container(child: Text('Product id:'+pcfid,style: TextStyle(color: Colors.black54,
    fontSize: 24,
    fontWeight: FontWeight.bold),),))
    ,
    SizedBox(height:5.0),
    Container(child: FlatButton(child: Text('GET ASSIGNED PATH',style: TextStyle(color: Colors.blueAccent,fontSize: 18),),onPressed: () {
     assignedpath();
    },),),
    SizedBox(height: 5.0,),
    Container(child: FlatButton(child: Text('GET PATH TAKEN',style: TextStyle(color: Colors.redAccent,fontSize: 18),),onPressed: () {
      pathTaken();
    },),),
    
   
  ],),
      ),
      ),));
}
}