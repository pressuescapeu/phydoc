import 'package:flutter/material.dart';
import 'appointmentDone.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AppointmentPaymentPage extends StatelessWidget {
  final String date;
  final String time;
  final String price;
  final int slotId;

  AppointmentPaymentPage({
    required this.date,
    required this.time,
    required this.price,
    required this.slotId,
  });

  Future<void> createAppointment(BuildContext context) async {
    final url = 'https://phydoc-test-2d45590c9688.herokuapp.com/api/appoint';
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({
      "slot_id": slotId,
      "type": "online",
    });

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Appointment created successfully: $data');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Appointment confirmed!')),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AppointmentDonePage()),
        );
      } else {
        print('Failed to create appointment: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to confirm appointment.')),
        );
      }
    } catch (e) {
      print('Error creating appointment: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
                      _buildProgressTab(isActive: true),
                      SizedBox(width: 8),
                      _buildProgressTab(isActive: true),
                      SizedBox(width: 8),
                      _buildProgressTab(isActive: true),
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
              'Подтвердите запись',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildWarningSection(),
            const SizedBox(height: 16),
            _buildAppointmentDetails(),
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
                  backgroundColor: const Color(0xFF4435FF),
                  foregroundColor: Colors.white,
                ),
                onPressed: () async {
                  await createAppointment(context);
                },
                child: const Text('Подтвердить и оплатить'),
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

  Widget _buildAppointmentDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDoctorDetails(),
        const SizedBox(height: 16),
        _buildAppointmentInfo(),
        const SizedBox(height: 16),
        _buildPaymentMethod(),
      ],
    );
  }

  Widget _buildDoctorDetails() {
    return Row(
      children: [
        CircleAvatar(
          radius: 32,
          backgroundImage: NetworkImage(
            'https://via.placeholder.com/150', // Replace with actual image URL
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Оксана Михайловна',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text('Офтальмолог', style: TextStyle(color: Colors.grey)),
              Text('⭐ 4.9 - Шымкент', style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
        Icon(Icons.message, color: Colors.blue),
      ],
    );
  }

  Widget _buildAppointmentInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildInfoBox('ВРЕМЯ', time),
        _buildInfoBox('ДАТА', date),
        _buildInfoBox('ЦЕНА', price),
      ],
    );
  }

  Widget _buildInfoBox(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    );
  }

  Widget _buildPaymentMethod() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[200]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.credit_card, color: Colors.blue, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              '**** 4515  $price',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
