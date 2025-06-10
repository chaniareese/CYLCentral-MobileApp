// import 'package:flutter/material.dart';
// import 'package:cylcentral/constants.dart';

// class AlreadyHaveAnAccountCheck extends StatelessWidget {
//   final bool login;
//   final Function? press;
//   const AlreadyHaveAnAccountCheck({
//     super.key,
//     this.login = true,
//     required this.press,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: <Widget>[
//         Text(
//           login ? "Don’t have an Account ? " : "Already have an Account ? ",
//           style: const TextStyle(color: kMint),
//         ),
//         GestureDetector(
//           onTap: press as void Function()?,
//           child: Text(
//             login ? "Sign Up" : "Sign In",
//             style: const TextStyle(
//               color: kMint,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         )
//       ],
//     );
//   }
// }
