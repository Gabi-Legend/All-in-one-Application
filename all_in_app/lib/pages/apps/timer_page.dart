import 'dart:async';
import 'package:all_in_app/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({super.key});

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage>
    with SingleTickerProviderStateMixin {
  int hours = 0;
  int minutes = 0;
  int seconds = 0;
  int totalSeconds = 0;
  int elapsedSeconds = 0;
  Timer? timer;
  bool isRunning = false;

  void startTimer() {
    if (totalSeconds == 0) return;

    // Oprește timer-ul anterior dacă există
    timer?.cancel();

    setState(() {
      elapsedSeconds = 0;
      isRunning = true;
    });

    // Creează și pornește timer-ul
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (elapsedSeconds < totalSeconds) {
        setState(() {
          elapsedSeconds++;
        });
      } else {
        stopTimer();
      }
    });
  }

  void stopTimer() {
    setState(() {
      isRunning = false;
    });
    timer?.cancel();
  }

  void resumeTimer() {
    setState(() {
      isRunning = true;
    });

    // Continuă timer-ul de unde a rămas
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (elapsedSeconds < totalSeconds) {
        setState(() {
          elapsedSeconds++;
        });
      } else {
        stopTimer();
      }
    });
  }

  void resetTimer() {
    setState(() {
      // Resetăm valorile pentru ore, minute și secunde
      hours = 0;
      minutes = 0;
      seconds = 0;
      elapsedSeconds = 0;
      totalSeconds = 0;
      isRunning = false;
    });

    // Oprește timer-ul dacă era în mișcare
    timer?.cancel();
  }

  String formatTime(int remainingSeconds) {
    int displayHours = remainingSeconds ~/ 3600;
    int displayMinutes = (remainingSeconds % 3600) ~/ 60;
    int displaySeconds = remainingSeconds % 60;
    return '${displayHours.toString().padLeft(2, '0')}:'
        '${displayMinutes.toString().padLeft(2, '0')}:'
        '${displaySeconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double progress = elapsedSeconds / (totalSeconds == 0 ? 1 : totalSeconds);

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Provider.of<ThemeProvider>(context).isDarkMode
            ? Colors.black
            : Colors.lightBlueAccent, // Culoare în funcție de temă
        title: const Text(
          'Timer',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Selector pentru ore, minute și secunde
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TimePicker(
                  label: 'Hours',
                  value: hours,
                  onChanged: (value) {
                    setState(() {
                      hours = value;
                      totalSeconds = (hours * 3600) + (minutes * 60) + seconds;
                    });
                  },
                ),
                const SizedBox(width: 16),
                TimePicker(
                  label: 'Minutes',
                  value: minutes,
                  onChanged: (value) {
                    setState(() {
                      minutes = value;
                      totalSeconds = (hours * 3600) + (minutes * 60) + seconds;
                    });
                  },
                ),
                const SizedBox(width: 16),
                TimePicker(
                  label: 'Seconds',
                  value: seconds,
                  onChanged: (value) {
                    setState(() {
                      seconds = value;
                      totalSeconds = (hours * 3600) + (minutes * 60) + seconds;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Cerc progresiv
            Expanded(
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 200,
                      height: 200,
                      child: CircularProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.black,
                        color: Colors.blue,
                        strokeWidth: 6, // Subțierea border-ului
                      ),
                    ),
                    Text(
                      formatTime(totalSeconds - elapsedSeconds),
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Butoane pentru Start, Stop și Reset
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: isRunning
                        ? stopTimer
                        : (elapsedSeconds == 0 ? startTimer : resumeTimer),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isRunning ? Colors.red : Colors.lightBlueAccent,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 16),
                    ),
                    child: Text(
                      isRunning
                          ? 'Stop'
                          : (elapsedSeconds == 0 ? 'Start' : 'Resume'),
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed:
                        (elapsedSeconds == 0 && !isRunning) ? null : resetTimer,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: (elapsedSeconds == 0 && !isRunning)
                          ? Colors.grey
                          : Colors.green, // Culoare activă sau inactivă
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 16),
                    ),
                    child: const Text(
                      'Reset',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget pentru selectorul de ore, minute sau secunde
class TimePicker extends StatelessWidget {
  final String label;
  final int value;
  final void Function(int) onChanged;

  const TimePicker({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 8),
        DropdownButton<int>(
          value: value,
          items: List.generate(60, (index) => index).map((val) {
            return DropdownMenuItem<int>(
              value: val,
              child: Text(val.toString().padLeft(2, '0')),
            );
          }).toList(),
          onChanged: (val) {
            if (val != null) onChanged(val);
          },
        ),
      ],
    );
  }
}
