import 'package:flutter/material.dart';
import 'appointmentTime.dart';

class PersonPage extends StatelessWidget {
  final int selectedOption;

  const PersonPage({required this.selectedOption, super.key});

  @override
  Widget build(BuildContext context) {
    return PatientFormatScreen(selectedOption: selectedOption);
  }
}

class PatientFormatScreen extends StatefulWidget {
  final int selectedOption;
  const PatientFormatScreen({required this.selectedOption, super.key});

  @override
  State<PatientFormatScreen> createState() => _PatientFormatScreenState();
}

class _PatientFormatScreenState extends State<PatientFormatScreen> {
  bool isSelfSelected = true;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Handle back button
        Navigator.pop(context); // Navigate back to the previous screen
        return false; // Prevent default back button behavior
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(56),
          child: SafeArea(
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildProgressTab(isActive: true),
                        SizedBox(width: 8),
                        _buildProgressTab(isActive: true),
                        SizedBox(width: 8),
                        _buildProgressTab(isActive: false),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  right: 16,
                  top: 0,
                  child: IconButton(
                    icon: Icon(Icons.close, color: Colors.black),
                    onPressed: () {
                      Navigator.pop(context); // Close the current screen
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
              const SizedBox(height: 16),
              Text(
                'Выберите кого хотите записать',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildToggleButton("Себя", isSelfSelected),
                  SizedBox(width: 8),
                  _buildToggleButton("Другого", !isSelfSelected),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: isSelfSelected ? _buildSelfDetails() : _buildOtherForm(),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[200],
                    foregroundColor: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.pop(context); // Navigate back
                  },
                  child: const Text('Назад'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4435FF),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AppointmentTimePage(selectedOption: widget.selectedOption),
                      ),
                    );
                  },
                  child: const Text('Дальше'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressTab({required bool isActive}) {
    return Container(
      width: 40,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF4435FF) : const Color(0xFFEFF2F5),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildToggleButton(String text, bool isSelected) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            isSelfSelected = text == "Себя";
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF4435FF) : Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSelfDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text('Имя и фамилия:', style: TextStyle(fontWeight: FontWeight.bold)),
        Text('Иванов Иван'),
        SizedBox(height: 8),
        Text('ИИН:', style: TextStyle(fontWeight: FontWeight.bold)),
        Text('041115486195'),
        SizedBox(height: 8),
        Text('Номер телефона:', style: TextStyle(fontWeight: FontWeight.bold)),
        Text('+7 707 748 4815'),
        SizedBox(height: 8),
        Text('Адрес прописки:', style: TextStyle(fontWeight: FontWeight.bold)),
        Text('ул. Гани Иляева 15'),
      ],
    );
  }

  Widget _buildOtherForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField("Имя и фамилия"),
        _buildTextField("ИИН"),
        _buildTextField("Номер телефона"),
        _buildTextField("Адрес"),
      ],
    );
  }

  Widget _buildTextField(String hint) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }
}
