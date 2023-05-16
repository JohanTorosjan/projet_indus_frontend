import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/client.dart';

class ProfileView extends StatefulWidget {
  final Client client;

  const ProfileView({Key? key, required this.client}) : super(key: key);

  @override
  ProfileViewState createState() => ProfileViewState();
}

class ProfileViewState extends State<ProfileView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _instaController;
  late TextEditingController _dobController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.client.name);
    _emailController = TextEditingController(text: widget.client.email);
    _instaController = TextEditingController(text: widget.client.instagram);
    _dobController = TextEditingController(
        text: widget.client.dob != null
            ? DateFormat('dd/MM/yyyy').format(widget.client.dob!)
            : '');
  }

  Future<void> _selectDate(BuildContext context) async {
    final ThemeData theme = Theme.of(context);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: theme.copyWith(
            colorScheme: theme.colorScheme.copyWith(
              primary: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      final age = _calculateAge(picked);
      if (age >= 18) {
        _dobController.text = DateFormat('dd/MM/yyyy').format(picked);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Vous devez avoir au moins 18 ans')),
        );
      }
    }
  }

  int _calculateAge(DateTime date) {
    final now = DateTime.now();
    int age = now.year - date.year;
    if (now.month < date.month ||
        (now.month == date.month && now.day < date.day)) {
      age--;
    }
    return age;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 50.0,
                backgroundColor: Colors.purple.shade400,
                child: const Icon(
                  Icons.person,
                  size: 50.0,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20.0),
              _buildTextField(_nameController, 'Name'),
              _buildTextField(_emailController, 'Email'),
              _buildTextField(_instaController, 'Instagram'),
              _buildDateField(_dobController, 'DoB'),
              const SizedBox(height: 20.0),
              ElevatedButton(
                child: const Text('Update Profile'),
                onPressed: () {
                  // TODO: Implement update profile functionality
                },
              ),
              ElevatedButton(
                child: const Text('Se déconnecter'),
                onPressed: () {
                  // TODO: Implement logout functionality
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.grey)),
        TextFormField(
          controller: controller,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return '$label cannot be empty';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildDateField(TextEditingController controller, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.grey)),
        TextFormField(
          controller: controller,
          readOnly: true,
          onTap: () => _selectDate(context),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return '$label cannot be empty';
            }
            return null;
          },
        ),
      ],
    );
  }
}
