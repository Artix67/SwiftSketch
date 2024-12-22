// import 'package:flutter/material.dart';
// import 'package:swift_sketch/screens/settingsscreen.dart';
// import '../FirebaseAuthService.dart';
//
// class PrivacySecurityScreen extends StatelessWidget{
//   const PrivacySecurityScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//         home: Scaffold(
//           backgroundColor: Colors.orange[100],
//           appBar: AppBar(
//             centerTitle: true,
//             backgroundColor: Colors.orange[100],
//             title: const Text('Privacy and Security'),
//             leading: IconButton(onPressed: (){
//               Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context){
//                     return const SettingsScreen();
//                   })
//               );
//             },
//                 icon: const Icon(Icons.arrow_back)),
//           ),
//           body: Center(
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Text("Biometric Authentication: "),
//                   const Enable(),
//                 ],
//               )
//           ),
//         )
//     );
//   }
// }
//
// class Enable extends StatefulWidget {
//   const Enable({super.key});
//
//   @override
//   State<Enable> createState() => _EnableState();
// }
//
// class _EnableState extends State<Enable> {
//   bool light = true;
//   final FirebaseAuthService _authService = FirebaseAuthService();
//   final DatabaseHelper _dbHelper = DatabaseHelper();
//
//   @override
//   void initState() {
//     super.initState();
//     _loadBiometricState();
//   }
//
//   void _loadBiometricState() async {
//     final user = _authService.auth.currentUser;
//     if (user != null) {
//       final settings = await _dbHelper.getSettings(user.email!);
//       if (settings != null) {
//         setState(() {
//           light = settings['biometricEnabled'] == 1;
//         });
//       }
//     }
//   }
//
//   void _updateBiometricState(bool value) async {
//     final user = _authService.auth.currentUser;
//     if (user != null) {
//       await _dbHelper.updateSettings({
//         'userEmail': user.email,
//         'biometricEnabled': value ? 1 : 0,
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Switch(
//       value: light,
//       activeColor: Colors.red,
//       onChanged: (bool value) {
//         setState(() {
//           light = value;
//           _updateBiometricState(value);
//         });
//       },
//     );
//   }
// }
//
//
//
//
//
