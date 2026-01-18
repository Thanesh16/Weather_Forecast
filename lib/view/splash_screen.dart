import 'dart:async';

import 'package:flutter/material.dart';
import 'package:weather_forecast/utils/colors.dart';
import 'package:weather_forecast/view/home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Timer _timer ;


  @override
  void initState() {
    _timer=Timer(Duration(seconds: 4), (){
      if(mounted){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> WeatherAppHomeScreen()));
      }
    });
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _timer.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 40),
          child: Column(
            children: [
              Center(child: Text("Discover The \n Weather In Your City",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 32,color: Theme.of(context).colorScheme.secondary,fontWeight: FontWeight.w800,letterSpacing: -0.5,height: 1.2),
              )
              ),

              Spacer(),
              Image.asset("assets/cloudy_img.png",height: 350,),     //image
              Spacer(),

              Center(child: Text("Get to know your weather maps and \n radar recipitations forecast",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 17,color: Theme.of(context).colorScheme.secondary,fontWeight: FontWeight.w400,letterSpacing: -0.5,height: 1.2),
              )
              ),

              Padding(
                padding:  EdgeInsets.only(top: 30.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttoncolor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(20),
                    )
                  ),
                 
                 onPressed: (){
                  _timer.cancel();
                   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> WeatherAppHomeScreen()));
                 }, 
                 
                 child: Padding(
                   padding:const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 15,
                   ),
                   child: Text("Get Started",style: TextStyle(fontSize: 18.0,color: Theme.of(context).colorScheme.secondary),),
                 ),
                ),
              )

            ],
          ),
        )
      ),

    );
  }
}