import 'dart:async';

import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const baseTimeList = [10, 900, 1200, 1500, 1800, 2100];
  static const restTime = 300;
  int baseTimeIndex = 0;
  late int totalSeconds = baseTimeList[baseTimeIndex];
  bool isRunning = false;
  bool isResting = false;
  bool isSuccessRound = false;
  int totalPomodoros = 0;
  Timer? timer;

  void onTickRun(Timer timer) {
    if (totalSeconds == 0) {
      setState(() {
        totalPomodoros = totalPomodoros + 1;
        isSuccessRound = true;
        isRunning = false;
        isResting = false;
        totalSeconds = baseTimeList[baseTimeIndex];
      });
      timer.cancel();
    } else {
      setState(() {
        totalSeconds = totalSeconds - 1;
      });
    }
  }

  void onTickRest(Timer timer) {
    if (totalSeconds == 0) {
      setState(() {
        isRunning = false;
        isResting = false;
        totalSeconds = baseTimeList[baseTimeIndex];
      });
      timer.cancel();
    } else {
      setState(() {
        totalSeconds = totalSeconds - 1;
      });
    }
  }

  void onPressedStart() {
    timer = Timer.periodic(
      const Duration(
        seconds: 1,
      ),
      onTickRun,
    );
    setState(() {
      isRunning = true;
      isSuccessRound = false;
    });
  }

  void onPressedPause() {
    timer?.cancel();
    setState(() {
      isRunning = false;
    });
  }

  void onPressedReset() {
    setState(() {
      isRunning = false;
      totalSeconds = baseTimeList[baseTimeIndex];
    });
    timer?.cancel();
  }

  void onPressedTimeUp() {
    setState(() {
      baseTimeIndex += 1;
      if (baseTimeIndex == baseTimeList.length) {
        baseTimeIndex = 0;
      }
      totalSeconds = baseTimeList[baseTimeIndex];
    });
  }

  void onPressedTimeDown() {
    setState(() {
      baseTimeIndex -= 1;
      if (baseTimeIndex == -1) {
        baseTimeIndex = baseTimeList.length - 1;
      }
      totalSeconds = baseTimeList[baseTimeIndex];
    });
  }

  void onPressBreak() {
    timer = Timer.periodic(
      const Duration(
        seconds: 1,
      ),
      onTickRest,
    );
    setState(() {
      totalSeconds = restTime;
      isSuccessRound = false;
      isResting = true;
    });
  }

  void onPressSkipRest() {
    timer?.cancel();
    setState(() {
      isResting = false;
      totalSeconds = baseTimeList[baseTimeIndex];
    });
  }

  String format(int seconds) {
    var duration = Duration(seconds: seconds);
    return duration.toString().substring(2, 7);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        children: [
          Flexible(
            flex: 2,
            child: Container(
              alignment: Alignment.bottomCenter,
              child: Column(
                children: [
                  IconButton(
                    enableFeedback: false,
                    onPressed: isRunning || isResting ? null : onPressedTimeUp,
                    icon: const Icon(Icons.arrow_drop_up_rounded),
                    iconSize: 58.0,
                  ),
                  Text(
                    format(totalSeconds),
                    style: TextStyle(
                      color: Theme.of(context).cardColor,
                      fontSize: 85,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    enableFeedback: false,
                    onPressed:
                        isRunning || isResting ? null : onPressedTimeDown,
                    icon: const Icon(Icons.arrow_drop_down_rounded),
                    iconSize: 58.0,
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            flex: 2,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          color: Theme.of(context).cardColor,
                          iconSize: 80,
                          onPressed: isResting
                              ? null
                              : isRunning
                                  ? onPressedPause
                                  : onPressedStart,
                          icon: Icon(
                            isRunning
                                ? Icons.pause_circle_outline
                                : Icons.play_circle_outline,
                          ),
                        ),
                        IconButton(
                          color: Theme.of(context).cardColor,
                          iconSize: 80,
                          onPressed: isRunning
                              ? null
                              : isResting
                                  ? onPressSkipRest
                                  : isSuccessRound
                                      ? onPressBreak
                                      : null,
                          icon: Icon(
                            isResting
                                ? Icons.fast_forward
                                : Icons.free_breakfast_outlined,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    color: Theme.of(context).cardColor,
                    iconSize: 30,
                    icon: const Icon(Icons.replay_outlined),
                    onPressed: onPressedReset,
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
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'ROUND',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context)
                                    .textTheme
                                    .displayLarge!
                                    .color),
                          ),
                          Text(
                            '$totalPomodoros',
                            style: TextStyle(
                                fontSize: 60,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context)
                                    .textTheme
                                    .displayLarge!
                                    .color),
                          ),
                        ],
                      )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
