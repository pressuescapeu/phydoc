import 'package:flutter/material.dart';
import 'pages/person.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AppointmentFormatScreen(),
    );
  }
}

class AppointmentFormatScreen extends StatefulWidget {
  @override
  _AppointmentFormatScreenState createState() =>
      _AppointmentFormatScreenState();
}

class _AppointmentFormatScreenState extends State<AppointmentFormatScreen> {
  int selectedOption = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: SafeArea(
          child: Stack(
            children: [
              // Progress Tabs centered
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildProgressTab(isActive: true), // First tab is active
                      SizedBox(width: 8),
                      _buildProgressTab(isActive: false),
                      SizedBox(width: 8),
                      _buildProgressTab(isActive: false),
                    ],
                  ),
                ),
              ),
              // Close button aligned to top-right
              Positioned(
                right: 16,
                top: 0,
                child: IconButton(
                  icon: Icon(Icons.close, color: Colors.black),
                  onPressed: () {
                    // Handle close button
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Выберите формат приема',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 24),
            OptionTile(
              title: 'Онлайн-консультация',
              description:
              'Врач созвонится с вами и проведет консультацию в приложении.',
              isSelected: selectedOption == 0,
              onTap: () {
                setState(() {
                  selectedOption = 0;
                });
              },
            ),
            OptionTile(
              title: 'Записаться в клинику',
              description:
              'Врач будет ждать вас в своем кабинете в клинике.',
              isSelected: selectedOption == 1,
              onTap: () {
                setState(() {
                  selectedOption = 1;
                });
              },
            ),
            OptionTile(
              title: 'Вызвать на дом',
              description:
              'Врач сам приедет к вам домой в указанное время и дату.',
              isSelected: selectedOption == 2,
              onTap: () {
                setState(() {
                  selectedOption = 2;
                });
              },
            ),
            Spacer(),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // Handle back button action
                    },
                    child: Text('Назад'),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PersonPage(selectedOption: selectedOption),
                      ),
                    );
                    },
                    child: Text('Дальше'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressTab({required bool isActive}) {
    return Container(
      width: 40,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? Color(0xFF4435FF) : Color(0xFFEFF2F5),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class OptionTile extends StatelessWidget {
  final String title;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;

  const OptionTile({
    required this.title,
    required this.description,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(color: Theme.of(context).primaryColor, width: 2)
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : Colors.black,
              ),
            ),
            SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}