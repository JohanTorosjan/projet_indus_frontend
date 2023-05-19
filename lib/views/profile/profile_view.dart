// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:projet_indus/DAOs/clientdao.dart';
// import 'package:projet_indus/views/Handler.dart';

// import '../../models/client.dart';

// class ProfileView extends StatefulWidget {
//   final Client client;

//   const ProfileView({Key? key, required this.client}) : super(key: key);

//   @override
//   ProfileViewState createState() => ProfileViewState();
// }

// class ProfileViewState extends State<ProfileView> {
//   final _formKey = GlobalKey<FormState>();
//   late TextEditingController _nameController;
//   late TextEditingController _emailController;
//   late TextEditingController _instaController;
//   late TextEditingController _dobController;

//   @override
//   void initState() {
//     super.initState();
//     _nameController = TextEditingController(text: widget.client.name);
//     _emailController = TextEditingController(text: widget.client.email);
//     _instaController = TextEditingController(text: widget.client.instagram);
//     _dobController = TextEditingController(
//         text: widget.client.dob != null
//             ? DateFormat('dd/MM/yyyy').format(widget.client.dob!)
//             : '');
//   }

//   Future<void> _selectDate(BuildContext context) async {
//     final ThemeData theme = Theme.of(context);
//     final ScaffoldMessengerState scaffoldMessenger =
//         ScaffoldMessenger.of(context);

//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(1900),
//       lastDate: DateTime.now(),
//       builder: (BuildContext context, Widget? child) {
//         return Theme(
//           data: theme.copyWith(
//             colorScheme: theme.colorScheme.copyWith(
//               primary:
//                   const Color.fromARGB(255, 0, 0, 0), // Changed primary color
//             ),
//           ),
//           child: child!,
//         );
//       },
//     );

//     if (picked != null) {
//       final age = _calculateAge(picked);
//       if (age >= 18) {
//         _dobController.text = DateFormat('dd/MM/yyyy').format(picked);
//       } else {
//         scaffoldMessenger.showSnackBar(
//           const SnackBar(content: Text('Vous devez avoir au moins 18 ans')),
//         );
//       }
//     }
//   }

//   int _calculateAge(DateTime date) {
//     final now = DateTime.now();
//     int age = now.year - date.year;
//     if (now.month < date.month ||
//         (now.month == date.month && now.day < date.day)) {
//       age--;
//     }
//     return age;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
//       child: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Colors.blue.shade600, Colors.blue.shade900],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const CircleAvatar(
//               radius: 50.0,
//               backgroundImage: AssetImage('assets/profile_logo.png'),
//             ),
//             const SizedBox(height: 20.0),
//             Text('Name: ${client.name}'),
//             Text('Email: ${client.email}'),
//             Text('Instagram: ${client.instagram ?? "Not available"}'),
//             Text('DoB: ${client.dob}'),
//             const SizedBox(height: 20.0),
//             ElevatedButton(
//               child: const Text('Update Profile'),
//               onPressed: () {
//                 Navigator.of(context).push(
//                   MaterialPageRoute(
//                     builder: (context) => UpdateProfileView(client: client),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   void _saveProfile() async {
//     if (_formKey.currentState!.validate()) {
//       // Create a new Client instance with updated data
//       Client updatedClient = Client(
//         id: widget.client.id,
//         firebase_id: widget.client.firebase_id,
//         name: _nameController.text,
//         email: _emailController.text,
//         instagram: _instaController.text,
//         dob: DateFormat('dd/MM/yyyy').parse(_dobController.text),
//         has_active_session: widget.client.has_active_session,
//         answered_questions: widget.client.answered_questions,
//       );

//       ClientDAO clientDao = ClientDAO();
//       try {
//         Client result = await clientDao.updateClient(updatedClient);
//         if (result.id != null) {
//           // check if the update was successful
//           // Check if the widget is still in the tree
//           if (mounted) {
//             // Navigate away or show a success message
//             Navigator.of(context).pop();
//           }
//         } else {
//           // Show an error message
//           print("Failed to update client");
//         }
//       } catch (err) {
//         // Handle any errors here.
//         print("Failed to update client: $err");
//       }
//     }
//   }
// }
