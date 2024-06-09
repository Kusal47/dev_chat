import 'package:dev_chat/core/routes/app_pages.dart';
import 'package:dev_chat/core/widgets/common/buttons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IncomingCallAlert extends StatefulWidget {
  final String callerName;
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  const IncomingCallAlert({
    super.key,
    required this.callerName,
    required this.onAccept,
    required this.onDecline,
  });

  @override
  State<IncomingCallAlert> createState() => _IncomingCallAlertState();
}

class _IncomingCallAlertState extends State<IncomingCallAlert> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage(
                  'https://th.bing.com/th/id/OIP.DoOqWGjiYMVAlJTXrt-axwHaNK?rs=1&pid=ImgDetMain'),
              fit: BoxFit.cover,
              filterQuality: FilterQuality.high),
        ),
        child: Center(
          child: Card(
            child: Container(
              width: Get.width * 0.9,
              height: Get.height * 0.25,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                // image: DecorationImage(
                // image: NetworkImage(
                //     'https://th.bing.com/th/id/OIP.nuWvKB_Hjm54ghTEuonzJQHaGG?w=240&h=198&c=7&r=0&o=5&dpr=2&pid=1.7'),
                // fit: BoxFit.fill),
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.grey[200],
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
                border: Border.all(
                  color: Colors.grey,
                  width: 1.0,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        child: Text(
                          widget.callerName[0].toUpperCase(),
                          style: const TextStyle(fontSize: 24),
                        ),
                      ),
                      SizedBox(width: Get.width * 0.04),
                      Expanded(
                        child: Text(
                          widget.callerName,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: PrimaryButton(
                            label: 'Decline',
                            onPressed: widget.onDecline,
                            backgroundColor: Colors.red,
                          ),
                        ),
                        SizedBox(width: Get.width * 0.05),
                        Expanded(
                          child: PrimaryButton(
                              label: 'Accept',
                              onPressed: widget.onAccept,
                              backgroundColor: Colors.green),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   bool _showIncomingCall = false;

//   void _toggleIncomingCallAlert() {
//     setState(() {
//       _showIncomingCall = !_showIncomingCall;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Home Page'),
//       ),
//       body: Stack(
//         children: [
//           Center(
//             child: ElevatedButton(
//               onPressed: _toggleIncomingCallAlert,
//               child: const Text('Toggle Incoming Call Alert'),
//             ),
//           ),
//           if (_showIncomingCall)
//             IncomingCallAlert(
//               callerName: 'John Doe',
//               onAccept: () {
//                 // Handle accept action
//                 _toggleIncomingCallAlert();
//               },
//               onDecline: () {
//                 // Handle decline action
//                 _toggleIncomingCallAlert();
//               },
//             ),
//         ],
//       ),
//     );
//   }
// }

// void main() {
//   runApp(MaterialApp(
//     home: MyHomePage(),
//   ));
// }
