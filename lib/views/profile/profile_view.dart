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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircleAvatar(
              radius: 50.0,
              backgroundImage: AssetImage('assets/profile_logo.png'),
            ),
            const SizedBox(height: 20.0),
            Text('Name: ${widget.client.name}'),
            Text('Email: ${widget.client.email}'),
            Text('Instagram: ${widget.client.instagram ?? "Not available"}'),
            Text('DoB: ${widget.client.dob}'),
            const SizedBox(height: 20.0),
            ElevatedButton(
              child: const Text('Update Profile'),
              onPressed: () {
                // Navigator.of(context).push(
                //   MaterialPageRoute(
                //   //  builder: (context) => UpdateProfileView(client: client),
                //   ),
                //);
              },
            ),
          ],
        ),
      ),
    );
  }
}
