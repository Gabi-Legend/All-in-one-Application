import 'package:flutter/material.dart';

class TodoTile extends StatelessWidget {
  final bool taskCompleted;
  final void Function(bool?)? onChanged;
  final String taskName;
  final void Function()? onDelete; // Funcția pentru ștergere

  const TodoTile({
    super.key,
    required this.taskName,
    required this.onChanged,
    required this.taskCompleted,
    required this.onDelete, // Parametru pentru ștergere
  });

  @override
  Widget build(BuildContext context) {
    // Obținem tema curentă
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    // Alegem culorile pe baza temei active
    Color tileBackgroundColor = isDarkMode
        ? (taskCompleted ? Colors.green.shade700 : Colors.purple.shade700)
        : (taskCompleted ? Colors.greenAccent : Colors.purple.shade300);
    Color textColor = isDarkMode ? Colors.white : Colors.black;
    Color iconColor = isDarkMode ? Colors.white : Colors.black;
    Color deleteIconColor = Colors.redAccent;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: GestureDetector(
        onTap: () {}, // Poți adăuga o funcție pentru interacțiuni suplimentare
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                tileBackgroundColor,
                taskCompleted
                    ? tileBackgroundColor
                    : tileBackgroundColor.withOpacity(0.8)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: isDarkMode
                    ? Colors.black.withOpacity(0.3)
                    : Colors.black.withOpacity(0.2),
                blurRadius: 6,
                offset: const Offset(2, 3),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Row(
              children: [
                // Icon pentru task-uri
                Icon(
                  taskCompleted ? Icons.check_circle : Icons.circle_outlined,
                  color: iconColor,
                  size: 28,
                ),
                const SizedBox(width: 15),

                // Task Name
                Expanded(
                  child: Text(
                    taskName,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      decoration: taskCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                ),

                // Icon de ștergere
                IconButton(
                  icon: Icon(Icons.delete, color: deleteIconColor),
                  onPressed: onDelete, // Apelarea funcției de ștergere
                ),

                // Checkbox personalizat
                Transform.scale(
                  scale: 1.2,
                  child: Checkbox(
                    value: taskCompleted,
                    onChanged: onChanged,
                    activeColor: Colors.white,
                    checkColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
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
