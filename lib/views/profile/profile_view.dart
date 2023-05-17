import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projet_indus/DAOs/clientdao.dart';
import 'package:projet_indus/views/Handler.dart';

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
    final ScaffoldMessengerState scaffoldMessenger =
        ScaffoldMessenger.of(context);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: theme.copyWith(
            colorScheme: theme.colorScheme.copyWith(
              primary:
                  const Color.fromARGB(255, 0, 0, 0), // Changed primary color
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
        scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text('Vous devez avoir au moins 18 ans')),
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
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade600, Colors.blue.shade900],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(20.0),
        child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 50.0,
                  backgroundColor: Colors.purple.shade900,
                  child: const Icon(
                    Icons.person,
                    size: 50.0,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20.0),
                _buildTextField(_nameController, 'Nom'),
                const SizedBox(height: 10.0),
                _buildTextField(_emailController, 'Mail'),
                const SizedBox(height: 10.0),
                _buildTextField(_instaController, 'Instagram'),
                const SizedBox(height: 10.0),
                _buildDateField(_dobController, 'Date de naissance'),
                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple.shade900,
                          ),
                          onPressed: _saveProfile,
                          child: const Text('Mettre à jour'),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple.shade900,
                            ),
                            child: const Text('Se déconnecter'),
                            onPressed: () async {
                              await FirebaseAuth.instance.signOut();
                              if (mounted) {
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => Handler()),
                                  (Route<dynamic> route) => false,
                                );
                              }
                            }),
                      ),
                    ),
                  ],
                ),
              ],
            )),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText,
      {bool isOutlined = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(labelText, style: const TextStyle(color: Colors.grey)),
        TextFormField(
          controller: controller,
          decoration: isOutlined
              ? InputDecoration(
                  labelText: labelText,
                  labelStyle: const TextStyle(color: Colors.white),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.purple.shade900),
                  ),
                )
              : null,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return '$labelText ne peut pas être vide';
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
        Text(label, style: const TextStyle(color: Colors.grey)),
        GestureDetector(
          onTap: () => _selectDate(context),
          child: AbsorbPointer(
            child: TextFormField(
              controller: controller,
              readOnly: true,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return '$label ne peut pas être vide';
                }
                return null;
              },
            ),
          ),
        ),
      ],
    );
  }

  void _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      // Create a new Client instance with updated data
      Client updatedClient = Client(
        id: widget.client.id,
        firebase_id: widget.client.firebase_id,
        name: _nameController.text,
        email: _emailController.text,
        instagram: _instaController.text,
        dob: DateFormat('dd/MM/yyyy').parse(_dobController.text),
        has_active_session: widget.client.has_active_session,
        answered_questions: widget.client.answered_questions,
      );

      ClientDAO clientDao = ClientDAO();
      try {
        Client result = await clientDao.updateClient(updatedClient);
        if (result.id != null) {
          // check if the update was successful
          // Check if the widget is still in the tree
          if (mounted) {
            // Navigate away or show a success message
            Navigator.of(context).pop();
          }
        } else {
          // Show an error message
          print("Failed to update client");
        }
      } catch (err) {
        // Handle any errors here.
        print("Failed to update client: $err");
      }
    }
  }
}
