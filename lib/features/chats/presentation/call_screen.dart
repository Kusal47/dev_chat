import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dev_chat/core/routes/app_pages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart' as stream;
import '../../dashboard/presentation/home_screen/model/chat_user_model._response.dart';
import '../controller/chat_controller.dart';

class CallScreen extends StatefulWidget {
  final stream.Call call;
  final ChatUserResponseModel? user;
  final bool? isIncommingCall;

  const CallScreen({Key? key, required this.call, this.user, this.isIncommingCall = false})
      : super(key: key);

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    Get.put(
      ChatController(),
    );
    // Set a timer to leave the call after 45 seconds
    // _timer = Timer(Duration(seconds: 45), () async {
    //   await widget.call.leave();
    //   if (mounted) {
    //     Navigator.pop(context);
    //   }
    // });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(builder: (context) {
      return Scaffold(
        body: stream.StreamCallContainer(
          callConnectOptions: const stream.CallConnectOptions(speakerDefaultOn: false),
          enablePictureInPicture: true,
          call: widget.call,
          callContentBuilder: (
            BuildContext context,
            stream.Call call,
            stream.CallState callState,
          ) {
            return stream.StreamCallContent(
              call: call,
              callState: callState,
              callAppBarBuilder: (context, call, callState) => stream.CallAppBar(
                call: call,
                showLeaveCallAction: false,
                onBackPressed: () async {
                  updateUserStatus();
                },
                actions: [
                  stream.LeaveCallOption(
                    call: call,
                    onLeaveCallTap: () async {
                      updateUserStatus();
                    },
                  ),
                ],
              ),
              callControlsBuilder: (
                BuildContext context,
                stream.Call call,
                stream.CallState callState,
              ) {
                final localParticipant = callState.localParticipant!;
                return stream.StreamCallControls(
                  options: [
                    stream.FlipCameraOption(
                      call: call,
                      localParticipant: localParticipant,
                    ),
                    stream.ToggleMicrophoneOption(
                      call: call,
                      localParticipant: localParticipant,
                    ),
                    stream.ToggleCameraOption(
                      call: call,
                      localParticipant: localParticipant,
                    ),
                    stream.ToggleSpeakerphoneOption(
                      call: call,
                    ),
                  ],
                );
              },
            );
          },
        ),
      );
    });
  }

  Future<bool> _doesDocumentExist(String docId) async {
    try {
      var doc = await FirebaseFirestore.instance.collection('callData').doc(docId).get();
      return doc.exists;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> updateUserStatus() async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    String? documentId = userId;

    if (documentId != null && documentId.isNotEmpty) {
      bool documentExists = await _doesDocumentExist(documentId);

      if (documentExists) {
        await FirebaseFirestore.instance
            .collection('callData')
            .doc(documentId)
            .update({'status': 'inactive'});
        if (widget.isIncommingCall == true) {
          widget.call.end();

          Get.offAllNamed(Routes.dashboard);
        } else {
          widget.call.end();

          Navigator.of(context).pop();
        }
      } else {
        widget.call.end();
      }
    }
  }
}

// class CallScreen extends StatefulWidget {
//   final stream.Call call;

//   const CallScreen({
//     Key? key,
//     required this.call,
//   }) : super(key: key);

//   @override
//   State<CallScreen> createState() => _CallScreenState();
// }

// class _CallScreenState extends State<CallScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: stream.StreamCallContainer(
//         call: widget.call,
//         onLeaveCallTap: () async {
//           await widget.call.leave();
//           Navigator.pop(context);
//         },
//         onBackPressed: () {
//           Get.back();
//         },
//         callContentBuilder: (
//           BuildContext context,
//           stream.Call call,
//           stream.CallState callState,
//         ) {
//           return stream.StreamCallContent(
//             call: call,
//             callState: callState,
//             callControlsBuilder: (
//               BuildContext context,
//               stream.Call call,
//               stream.CallState callState,
//             ) {
//               final localParticipant = callState.localParticipant!;
//               return stream.StreamCallControls(
//                 options: [
//                   stream.FlipCameraOption(
//                     call: call,
//                     localParticipant: localParticipant,
//                   ),
//                   stream.ToggleMicrophoneOption(
//                     call: call,
//                     localParticipant: localParticipant,
//                   ),
//                   stream.ToggleCameraOption(
//                     call: call,
//                     localParticipant: localParticipant,
//                   ),
//                 ],
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
