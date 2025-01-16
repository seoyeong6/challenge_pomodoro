import 'package:flutter/material.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const fifteenMinutes = 15;
  static const twentyMinutes = 1200;
  static const twentyFiveMinutes = 1500;
  static const thirtyMinutes = 1800;
  static const thirtyFiveMinutes = 2100;
  static const fiveMinutesBreak = 300;

  int totalSeconds = twentyFiveMinutes;
  bool isRunning = false;
  int totalPomodoros = 0;
  int goals = 0;
  Timer? timer;
  bool isBreakTime = false;

  void onTick() {
    if (totalSeconds == 0) {
      setState(() {
        if (!isBreakTime) {
          totalPomodoros = totalPomodoros + 1;
          if (totalPomodoros % 4 == 0) {
            goals = goals + 1;
          }
          isRunning = false;
          isBreakTime = true;
          totalSeconds = fiveMinutesBreak;
        } else {
          isBreakTime = false;
          totalSeconds = twentyFiveMinutes;
          isRunning = false;
        }
      });
      timer?.cancel();
    } else {
      setState(() {
        totalSeconds = totalSeconds - 1;
      });
    }
  }

  void onPausePressed() {
    timer?.cancel();
    setState(() {
      isRunning = false;
    });
  }

  void onStartPressed() {
    timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      onTick();
    });
    setState(() {
      isRunning = true;
    });
  }

  String format(int seconds) {
    var duration = Duration(seconds: seconds);
    return duration.toString().split('.').first.substring(2, 7);
  }

  void selectTime(int seconds) {
    setState(() {
      totalSeconds = seconds;
      isRunning = false;
    });
    if (timer != null && timer!.isActive) {
      timer!.cancel();
    }
  }

  void resetRound() {
    setState(() {
      totalPomodoros = 0;
      goals = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          Flexible(
            flex: 1,
            child: Container(
              padding: EdgeInsets.only(left: 40, top: 70),
              alignment: Alignment.centerLeft,
              child: Text(
                isBreakTime ? "Break Time" : "PomoTimer",
                style: TextStyle(
                  color: Theme.of(context).cardColor,
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Flexible(
            flex: 2,
            child: Container(
              alignment: Alignment.center,
              child: Text(
                format(totalSeconds),
                style: TextStyle(
                  color: Theme.of(context).cardColor,
                  fontSize: 89,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Flexible(
            flex: 2,
            child: Center(
              child: IconButton(
                iconSize: 120,
                color: Theme.of(context).cardColor,
                onPressed: isRunning ? onPausePressed : onStartPressed,
                icon: Icon(
                  isRunning
                      ? Icons.pause_circle_outline
                      : Icons.play_circle_outline,
                ),
              ),
            ),
          ),
          Flexible(
            flex: 2,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TimeButton(
                    time: '15',
                    onTap: () => selectTime(fifteenMinutes),
                  ),
                  SizedBox(width: 30),
                  TimeButton(
                    time: '20',
                    onTap: () => selectTime(twentyMinutes),
                  ),
                  SizedBox(width: 30),
                  TimeButton(
                    time: '25',
                    onTap: () => selectTime(twentyFiveMinutes),
                  ),
                  SizedBox(width: 30),
                  TimeButton(
                    time: '30',
                    onTap: () => selectTime(thirtyMinutes),
                  ),
                  SizedBox(width: 30),
                  TimeButton(
                    time: '35',
                    onTap: () => selectTime(thirtyFiveMinutes),
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'ROUND',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).cardColor,
                              ),
                            ),
                            Text(
                              "${totalPomodoros % 4} / 4",
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).cardColor,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: resetRound,
                          icon: Icon(
                            Icons.refresh,
                            color: Theme.of(context).cardColor,
                            size: 30,
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'GOAL',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).cardColor,
                              ),
                            ),
                            Text(
                              "$totalPomodoros / 12",
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).cardColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TimeButton extends StatelessWidget {
  final String time;
  final VoidCallback onTap;

  const TimeButton({required this.time, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          border: Border.all(color: Theme.of(context).cardColor, width: 2),
        ),
        child: Text(
          time,
          style: TextStyle(
            color: Theme.of(context).cardColor,
            fontSize: 25,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
