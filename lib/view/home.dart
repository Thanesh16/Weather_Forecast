import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:weather_forecast/provider/theme_provider.dart';
import 'package:weather_forecast/services/api_service.dart';
import 'package:weather_forecast/view/weekly_forecast.dart';

class WeatherAppHomeScreen extends ConsumerStatefulWidget {
  const WeatherAppHomeScreen({super.key});

  @override
  ConsumerState<WeatherAppHomeScreen> createState() =>
      _WeatherAppHomeScreenState();
}

class _WeatherAppHomeScreenState
    extends ConsumerState<WeatherAppHomeScreen> {
  final WeatherApiService _weatherService = WeatherApiService();

  String city = "Nagercoil";
  String country = "";
  Map<String, dynamic> currentValue = {};
  List<dynamic> pastweek = [];
  List<dynamic> hourly = [];
  List<dynamic> next7days = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  Future<void> _fetchWeather() async {
    setState(() => isLoading = true);

    try {
      final forecast = await _weatherService.getHourlyForecast(city);
      debugPrint("Forecast API response: $forecast");

      setState(() {
        currentValue = forecast['current'] ?? {};
        city = forecast['location']['name'];
        country = forecast['location']['country'];

        
        hourly = forecast['forecast']['forecastday'][0]['hour'];

        isLoading = false;
      });
    } catch (e) {
      debugPrint("Error fetching weather: $e");
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to load current weather")),
      );
      return;
    }

    try {
      final past = await _weatherService.getLastSevenDaysWeather(city);
      setState(() => pastweek = past);
    } catch (e) {
      debugPrint("Failed to fetch past 7 days: $e");
    }
  }

  String formatedTime(String timeString) {
    DateTime time = DateTime.parse(timeString);
    return DateFormat.j().format(time);
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = ref.read(themeNotifierProvider.notifier);
    final isDark = ref.watch(themeNotifierProvider) == ThemeMode.dark;

    String iconPath = currentValue['condition']?['icon'] ?? '';
    String imageUrl = iconPath.isNotEmpty ? "https:$iconPath" : "";

    Widget imageWidgets = imageUrl.isNotEmpty
        ? Image.network(
            imageUrl,
            height: 150,
            width: 150,
            fit: BoxFit.cover,
          )
        : const SizedBox();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0,
        title: SizedBox(
          width: 300,
          height: 45,
          child: TextField(
            onSubmitted: (value) {
              if (value.trim().isEmpty) return;
              setState(() => city = value.trim());
              _fetchWeather();
            },
            decoration: InputDecoration(
              hintText: "Search city",
              prefixIcon: Icon(
                Icons.search,
                color: Theme.of(context).colorScheme.surface,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: themeNotifier.toggleTheme,
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: isLoading
              ? const CircularProgressIndicator()
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),

                      Text(
                        "$city${country.isNotEmpty ? ', $country' : ''}",
                        style: TextStyle(
                          fontSize: 36,
                          color:
                              Theme.of(context).colorScheme.onBackground,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      const SizedBox(height: 12),

                      Text(
                        currentValue['temp_c'] != null
                            ? "${currentValue['temp_c']}°C"
                            : "--°C",
                        style: TextStyle(
                          fontSize: 56,
                          color:
                              Theme.of(context).colorScheme.onBackground,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Text(
                        "${currentValue['condition']?['text'] ?? ''}",
                        style: TextStyle(
                          fontSize: 22,
                          color:
                              Theme.of(context).colorScheme.onBackground,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      imageWidgets,

                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Container(
                          height: 100,
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary,
                                offset: const Offset(1, 1),
                                blurRadius: 10,
                                spreadRadius: 1,
                              ),
                            ],
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceAround,
                            children: [
                              // Humidity
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/Humidity.png",
                                    height: 30,
                                    width: 30,),

                                  Text(
                                    "${currentValue['humidity']}%",
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "Humidity",
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                  ),
                                ],
                              ),

                              // Wind
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                children: [
                                   Image.asset(
                                    "assets/wind#.png",
                                    height: 30,
                                    width: 30,),
                                  Text(
                                    "${currentValue['wind_kph']} kph",
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "Wind",
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                  ),
                                ],
                              ),

                              // Max Temp
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                children: [
                                   Image.asset(
                                    "assets/Max_temp_img.png",
                                    height: 30,
                                    width: 30,),
                                  Text(
                                    hourly.isNotEmpty
                                        ? "${hourly.map((h) => h['temp_c']).reduce((a, b) => a > b ? a : b)}°C"
                                        : "N/A",
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "Max Temp",
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      

                       SizedBox(height: 15),

                      Container(
                        height: 250,
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(color: Theme.of(context).colorScheme.secondary)
                          ),
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(40)
                          )
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: 10,),
                            Padding(padding: 
                            EdgeInsetsGeometry.symmetric(horizontal: 20,vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Today Forecast",style: TextStyle(fontSize: 18,color: Theme.of(context).colorScheme.secondary,fontWeight: FontWeight.bold),),
                                GestureDetector(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>WeeklyForecast(city: city, 
                                    currentValue: currentValue, 
                                    pastweek: pastweek, 
                                    next7days: next7days,
                                    )));

                                  },
                                  child:Text("Weekly Forecast",style: TextStyle(fontSize: 18,color: const Color(0xFF00E5FF),fontWeight: FontWeight.bold,),) ,

                                ),
                              ],
                            ),
                            ),
                            Divider(color: Theme.of(context).colorScheme.secondary,),

                            //todays forecast

                            SizedBox(
                        height: 150,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: hourly.length,
                          itemBuilder: (context, index) {
                            final hour = hourly[index];
                            final now = DateTime.now();
                            final hourTime =
                                DateTime.parse(hour['time']);
                            final isCurrentHour =
                                now.hour == hourTime.hour &&
                                    now.day == hourTime.day;

                            return Padding(
                              padding: const EdgeInsets.all(8),
                              child: Container(
                                height: 70,
                                padding:  EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: isCurrentHour
                                      ? Colors.orangeAccent
                                      : Colors.grey.shade700,
                                  borderRadius:
                                      BorderRadius.circular(40),
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      isCurrentHour
                                          ? "Now"
                                          : formatedTime(
                                              hour['time']),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Image.network(
                                      "https:${hour['condition']?['icon']}",
                                      width: 40,
                                      height: 40,
                                      fit: BoxFit.cover,
                                    ),
                                    Text(
                                      "${hour['temp_c']}°C",
                                      style: const TextStyle(
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ), // todays
                          ],
                        ),
                      ),

                      
                      
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
