
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../DataService/dataservice.dart';
import '../WeatherModel/weather model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {Map<String,dynamic>weatherData={};


bool _isLoaded=false;











@override
void initState() {
  super.initState();
  getWeather();
  weatherService();
  _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) => _update());

}

    String WeatherUrl = 'https://api.openweathermap.org/data/2.5/weather?q=dhaka&units=metric&appid=a17c1d48df0e47e968f31a998ec25ab4';



WeatherResponse? _response;

var min,max;

Future getWeather() async {
  final response = await http.get(Uri.parse(WeatherUrl));

  var showData = jsonDecode(response.body);

  setState(() {
    this.min = showData['main']['temp_min'];
    this.max = showData['main']['temp_max'];
  });
}

late var temp = (((_response?.tempInfo.temperature)! - 32) * 5) / 9;
///Weather Datq

final DataService _dataService = DataService();

bool buttonselect = false;
bool buttonbackcolor = true;

dynamic todaysDate = DateFormat("dd MMM yy").format(DateTime.now());

 DateTime _time = DateTime.now();
dynamic currentTime = DateFormat.jm().format(DateTime.now());


void weatherService() async {
  final response = await _dataService.getWeather("Dhaka");
  setState(() => _response = response);
}


String formattedTime = DateFormat('hh:mm:ss').format(DateTime.now());
String hour = DateFormat('a').format(DateTime.now());
late Timer _timer;


void _update() {
  setState(() {
    formattedTime = DateFormat('hh:mm a').format(DateTime.now());
    hour = DateFormat('a').format(DateTime.now());
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title:  Text('Flutter Weather', style: const TextStyle(
            fontSize: 20,
            fontFamily: 'Poppins',
            color: Colors.white

        ),),

        actions: [
          Icon(Icons.settings,color: Colors.white,),
          SizedBox(width: 10,),
          Icon(Icons.add,color: Colors.white,),

        ],

      ),
      body:_isLoaded?CircularProgressIndicator() :
      Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.1, 0.5,],
            colors: [
              Colors.deepPurple,


              Colors.deepPurple.shade400,


            ],
          ),),
        child: Padding(
          padding: const EdgeInsets.only(top: 180),
          child: Column(

            children: [

              Column(
                children: [
                  Text(
                    'Hobigang',
                    style: const TextStyle(
                        fontSize: 25,
                        fontFamily: 'Poppins',
                        color: Colors.white,
                      fontWeight: FontWeight.bold

                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Update: ',
                        style: const TextStyle(
                            fontSize: 18,
                            fontFamily: 'Poppins',
                            color: Colors.white

                        ),
                      ),
                      Text(
                        formattedTime,
                        style: const TextStyle(
                            fontSize: 18,
                            fontFamily: 'Poppins',
                            color: Colors.white

                        ),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(height: 5,),

              Padding(
                padding: const EdgeInsets.only(top: 20,left: 20,right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[

                    Image.network(
                      _response!.iconUrl,color: Colors.white,
                    ),

                    Text(
                      "${temp.ceil()}°",
                      style: const TextStyle(
                          fontSize: 30,
                          fontFamily: 'Poppins',
                          color: Colors.white

                      ),
                    ),

                    Column(
                      children: [


                        Row(
                          children: <Widget>[
                            Padding(
                              padding:
                              EdgeInsets.only(top: 8, left: 15),
                              child: Text(
                                "Max".toUpperCase(),
                                style: const TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'Poppins',
                                    color: Colors.white
                                ),
                              ),
                            ),

                            Padding(
                              padding:
                              EdgeInsets.only(top: 8, left: 15),
                              child: Text(
                                max != null
                                    ? "${max.ceil()+3}° C"
                                    : '36° C',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'Poppins',
                                    color: Colors.white

                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Padding(
                              padding:
                              EdgeInsets.only(top: 8, left: 15),
                              child: Text(
                                "min".toUpperCase(),
                                style: const TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'Poppins',
                                    color: Colors.white

                                ),
                              ),
                            ),

                            Padding(
                              padding:
                              EdgeInsets.only(top: 8, left: 15),
                              child: Text(
                                min != null
                                    ? "${min.ceil()-2}° C"
                                    : '29° C',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'Poppins',
                                    color: Colors.white

                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 5,)
                      ],
                    ),

                  ],
                ),
              ),

              Padding(
                padding:
                EdgeInsets.only(top: 8, left: 15),
                child: Text(
                  '${_response?.weatherInfo.description.toUpperCase()}',
                  style: const TextStyle(
                      fontSize: 20,
                      fontFamily: 'Poppins',
                      color: Colors.white

                  ),
                ),
              ),
            ],
          ),
        ),
      ),

    );
  }
}
