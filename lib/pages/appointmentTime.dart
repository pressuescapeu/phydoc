import 'package:flutter/material.dart';
import 'appointmentPayment.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AppointmentTimePage extends StatelessWidget {
  final int selectedOption;

  const AppointmentTimePage({required this.selectedOption, super.key});

  @override
  Widget build(BuildContext context) {
    return AppointmentTimeScreen(selectedOption: selectedOption);
  }
}

class AppointmentTimeScreen extends StatefulWidget {
  final int selectedOption;

  const AppointmentTimeScreen({required this.selectedOption, super.key});

  @override
  State<AppointmentTimeScreen> createState() => _AppointmentTimeScreenState();
}

class _AppointmentTimeScreenState extends State<AppointmentTimeScreen> {
  int? selectedTimeIndex;
  List<Map<String, dynamic>> timeSlots = [];
  bool isLoading = true;
  String? appointment;

  @override
  void initState() {
    super.initState();
    fetchAvailableSlots();
  }

  Future<void> fetchAvailableSlots() async {

    if (widget.selectedOption == 1 || widget.selectedOption == 2) {
      appointment = 'offline';
    } else {
      appointment = 'online';
    }

    final url =
        'https://phydoc-test-2d45590c9688.herokuapp.com/get_schedule?type=${appointment}';
    try {
      final response = await http.get(Uri.parse(url));

      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data is Map<String, dynamic> && data.containsKey("slots")) {
          final slots = data["slots"] as List<dynamic>;
          print('Slots Data: $slots');

          setState(() {
            timeSlots = _parseScheduleData(slots);
            isLoading = false;
          });
        } else {
          throw Exception('Unexpected data format: Missing "slots" key.');
        }
      } else {
        throw Exception('Failed to load: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching schedule: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  List<Map<String, dynamic>> _parseScheduleData(List<dynamic> slots) {
    final Map<String, List<dynamic>> groupedByDate = {};

    for (final slot in slots) {
      final datetime = DateTime.parse(slot["datetime"]);
      final date =
          "${datetime.year}-${datetime.month.toString().padLeft(2, '0')}-${datetime.day.toString().padLeft(2, '0')}";

      if (!groupedByDate.containsKey(date)) {
        groupedByDate[date] = [];
      }
      groupedByDate[date]!.add({
        "time": "${datetime.hour.toString().padLeft(2, '0')}:${datetime.minute.toString().padLeft(2, '0')}",
        "price": "${slot["price"]}₸",
        "slot_id": slot["id"],
      });
    }

    return groupedByDate.entries
        .map((entry) => {
      "date": entry.key,
      "slots": entry.value,
    })
        .toList();
  }

  Widget build(BuildContext context) {
    Map<String, dynamic>? _getSelectedSlot() {
      if (selectedTimeIndex == null) return null;
      int groupIndex = selectedTimeIndex! ~/ 10;
      int slotIndex = selectedTimeIndex! % 10;
      return timeSlots[groupIndex]["slots"][slotIndex];
    }


    return Scaffold(
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
                      _buildProgressTab(isActive: true), // First tab
                      SizedBox(width: 8),
                      _buildProgressTab(isActive: true), // Second tab
                      SizedBox(width: 8),
                      _buildProgressTab(isActive: true), // Third tab
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
                    Navigator.pop(context);
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
              'Выберите дату и время',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildWarningSection(),
            const SizedBox(height: 16),
            Expanded(child: _buildTimeSlots()),
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
                  Navigator.pop(context);
                },
                child: const Text('Назад'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedTimeIndex != null
                      ? const Color(0xFF4435FF)
                      : Colors.grey,
                  foregroundColor: Colors.white,
                ),
                onPressed: selectedTimeIndex != null
                ? () {
                  final selectedDateGroup = timeSlots[selectedTimeIndex! ~/ 10];
                  final selectedSlot = selectedDateGroup['slots'][selectedTimeIndex! % 10];

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AppointmentPaymentPage(
                        date: selectedDateGroup['date'],
                        time: selectedSlot['time'],
                        price: selectedSlot['price'],
                        slotId: selectedSlot['slot_id'], // Pass slot_id
                      ),
                    ),
                  );
                }
        : null,


                child: const Text('Дальше'),
              ),
            ),
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
        color: isActive ? const Color(0xFF4435FF) : const Color(0xFFEFF2F5),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildWarningSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFEE8D0),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.warning, color: Colors.orange, size: 24),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Отмена и изменение времени приема может стоить денег.',
              style: TextStyle(color: Colors.black, fontSize: 14),
            ),
          ),
          TextButton(
            onPressed: () {
              // Handle "Подробнее"
            },
            child: Text(
              'Подробнее',
              style: TextStyle(color: Colors.blue, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSlots() {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    if (timeSlots.isEmpty) {
      return Center(
        child: Text(
          'Нет доступных слотов',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: timeSlots.length,
      itemBuilder: (context, index) {
        final dateGroup = timeSlots[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              dateGroup["date"],
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(
                dateGroup["slots"].length,
                    (slotIndex) {
                  final slot = dateGroup["slots"][slotIndex];
                  final globalIndex = index * 10 + slotIndex;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedTimeIndex = globalIndex;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: selectedTimeIndex == globalIndex
                            ? const Color(0xFF4435FF)
                            : Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            slot["time"],
                            style: TextStyle(
                              color: selectedTimeIndex == globalIndex
                                  ? Colors.white
                                  : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            slot["price"],
                            style: TextStyle(
                              color: selectedTimeIndex == globalIndex
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }
}
