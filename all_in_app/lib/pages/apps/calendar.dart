import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:all_in_app/themes/theme_provider.dart'; // Asigură-te că importi ThemeProvider

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  final DateTime _lastDay = DateTime.now()
      .add(const Duration(days: 365)); // Extindem până la un an viitor
  final DateTime _firstDay = DateTime.utc(2000, 1, 1); // Prima zi posibilă
  DateTime _focusedDay = DateTime.now(); // Ziua curentă
  DateTime? _selectedDay; // Ziua selectată

  // Lista de evenimente
  Map<DateTime, List<String>> _events = {};

  final TextEditingController _eventController =
      TextEditingController(); // Controller pentru TextField
  final EventStorage _eventStorage =
      EventStorage(); // Instanță pentru gestionarea evenimentelor

  @override
  void initState() {
    super.initState();
    _loadEvents(); // Încarcă evenimentele la început
  }

  // Încarcă evenimentele salvate local
  Future<void> _loadEvents() async {
    _events = await _eventStorage.loadEvents();
    setState(() {});
  }

  // Salvează evenimentele local
  Future<void> _saveEvents() async {
    await _eventStorage.saveEvents(_events);
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        Provider.of<ThemeProvider>(context).isDarkMode; // Verificăm tema activă

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Calendar",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: isDarkMode
            ? Colors.black
            : Colors.orangeAccent, // Modificăm culoarea în funcție de temă
      ),
      body: Column(
        children: [
          // Calendarul
          TableCalendar(
            headerStyle: const HeaderStyle(
              titleCentered: true,
              formatButtonVisible: false,
            ),
            focusedDay: _focusedDay,
            firstDay: _firstDay,
            lastDay: _lastDay,
            selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
            calendarStyle: CalendarStyle(
              selectedDecoration: BoxDecoration(
                color: isDarkMode
                    ? Colors.grey
                    : Colors.orangeAccent, // Culoare în funcție de temă
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: isDarkMode
                    ? Colors.orange
                    : Colors.orangeAccent, // Culoare pentru ziua curentă
                shape: BoxShape.circle,
              ),
            ),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
          ),
          const Divider(
              color: Colors.grey), // Divider între calendar și evenimente
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              _selectedDay != null
                  ? "Selected Day: ${_selectedDay!.day} ${_monthName(_selectedDay!.month)}"
                  : "Select a day",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          // Afișarea evenimentelor
          Expanded(
            child: _selectedDay == null ||
                    _events[_selectedDay] == null ||
                    _events[_selectedDay]!.isEmpty
                ? const Center(
                    child: Text(
                      "No events",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: _events[_selectedDay]!.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(_events[_selectedDay]![index]),
                      );
                    },
                  ),
          ),
          // Adăugarea unui eveniment nou
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _eventController,
                    decoration: InputDecoration(
                      hintText: "Add Event",
                      border: OutlineInputBorder(),
                      fillColor: isDarkMode
                          ? Colors.grey[700]
                          : Colors.white, // Culoare background TextField
                      filled: true,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () {
                    if (_selectedDay != null &&
                        _eventController.text.isNotEmpty) {
                      setState(() {
                        // Adaugă evenimentul la ziua selectată
                        _events[_selectedDay!] = _events[_selectedDay] ?? [];
                        _events[_selectedDay]!.add(_eventController.text);
                        _eventController.clear(); // Golește câmpul de text
                      });
                      _saveEvents(); // Salvează evenimentele local
                    }
                  },
                  icon: const Icon(Icons.add),
                  color: isDarkMode
                      ? Colors.white
                      : Colors.orangeAccent, // Culoare iconita
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Obține numele lunii
  String _monthName(int month) {
    const months = [
      "Jan.",
      "Feb.",
      "Mar.",
      "Apr.",
      "May",
      "Jun.",
      "Jul.",
      "Aug.",
      "Sep.",
      "Oct.",
      "Nov.",
      "Dec."
    ];
    return months[month - 1];
  }
}

class EventStorage {
  static const _eventsKey = 'events_key';

  // Salvează evenimentele
  Future<void> saveEvents(Map<DateTime, List<String>> events) async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, String> eventsToSave = {};

    events.forEach((key, value) {
      // Convertim DateTime în string pentru a putea salva
      String dateKey = key.toIso8601String();
      eventsToSave[dateKey] =
          jsonEncode(value); // Salvăm lista de evenimente în format JSON
    });

    for (var key in eventsToSave.keys) {
      await prefs.setString(
          key, eventsToSave[key]!); // Salvăm fiecare eveniment
    }
  }

  // Încarcă evenimentele
  Future<Map<DateTime, List<String>>> loadEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final Map<String, String> eventsMap = {};

    // Recuperăm toate cheile care sunt legate de evenimente
    for (var key in prefs.getKeys()) {
      if (key != _eventsKey) {
        eventsMap[key] = prefs.getString(key)!;
      }
    }

    Map<DateTime, List<String>> events = {};
    eventsMap.forEach((key, value) {
      DateTime date = DateTime.parse(key);
      events[date] = List<String>.from(jsonDecode(value));
    });

    return events;
  }
}
