import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeeklyForecast extends StatefulWidget {
  final Map<String, dynamic> currentValue;
  final List<dynamic> pastweek;
  final String city;
  final List<dynamic> next7days;

  WeeklyForecast({
    super.key,
    required this.city,
    required this.currentValue,
    required this.pastweek,
    required this.next7days,
  });

  @override
  State<WeeklyForecast> createState() => _WeeklyForecastState();
}

class _WeeklyForecastState extends State<WeeklyForecast> {
  String formatApiData(String dataString) {
    try {
      DateTime date = DateTime.parse(dataString);
      return DateFormat('d MMM, EEEE').format(date);
    } catch (_) {
      return '--';
    }
  }

  @override
  Widget build(BuildContext context) {
    final condition = widget.currentValue['condition'] ?? {};

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// HEADER
              Center(
                child: Column(
                  children: [
                    Text(
                      widget.city,
                      style: const TextStyle(
                        fontSize: 42,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "${widget.currentValue['temp_c'] ?? '--'}°C",
                      style: const TextStyle(
                        fontSize: 36,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      condition['text'] ?? '',
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white70,
                      ),
                    ),
                    Image.network(
                      "https:${widget.currentValue['condition']?['icon'] ?? ''}",
                      height: 180,
                      width: 180,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const SizedBox(height: 130),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              /// LAST 7 DAYS
              const Text(
                "Last 7 Days Forecast",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              widget.pastweek.isEmpty
                  ? const Text(
                      "No past data available",
                      style: TextStyle(color: Colors.white70),
                    )
                  : Column(
                      children: widget.pastweek.map((item) {
                        
                        final forecastDay =
                            item['forecast']?['forecastday']?[0];

                        if (forecastDay == null) {
                          return const SizedBox();
                        }

                        final date = forecastDay['date'];
                        final dayInfo = forecastDay['day'];
                        final dayCondition = dayInfo['condition'];

                        return Card(
                          color: Colors.grey.shade900,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            leading: Image.network(
                              "https:${dayCondition['icon']}",
                              width: 45,
                              errorBuilder: (_, __, ___) =>
                                  const Icon(Icons.cloud, color: Colors.white),
                            ),
                            title: Text(
                              formatApiData(date),
                              style: const TextStyle(color: Colors.white),
                            ),
                            subtitle: Text(
                              "${dayCondition['text']}  "
                              "${dayInfo['mintemp_c']}°C - "
                              "${dayInfo['maxtemp_c']}°C",
                              style: const TextStyle(color: Colors.white70),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
