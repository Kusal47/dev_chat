import 'package:dev_chat/core/resources/colors.dart';
import 'package:dev_chat/core/widgets/common/base_widget.dart';
import 'package:dev_chat/features/dashboard/presentation/home_screen/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../core/routes/app_pages.dart';
import '../../../core/widgets/custom/chat_tiles.dart';
import '../../../core/widgets/custom/search_bar.dart';
import '../../dashboard/presentation/home_screen/model/chat_user_model._response.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, required this.userLists});
  final List<ChatUserResponseModel> userLists;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (controller) {
      return BaseWidget(builder: (context, config, theme) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                    onTap: () {
                      Get.offAllNamed(Routes.dashboard);
                    },
                    child: Padding(
                      padding: EdgeInsets.only(top: config.appVerticalPaddingLarge(), left: 8.0),
                      child: const Row(
                        children: [
                          Icon(Icons.arrow_back_ios, color: primaryColor),
                          Text('Back'),
                        ],
                      ),
                    )),
                Row(
                  children: [
                    Expanded(
                      child: SearchBarWidget(
                        controller: controller.searchController,
                        // onClearTap: () {
                        //   controller.searchController.clear();
                        //   controller.searchedUsers = [];
                        //   setState(() {});
                        // },
                        // icon: Icons.clear,
                        onSaved: (value) {
                          // controller.searchController.text = value;
                          // controller.searchUser(controller.searchController.text, widget.userLists);
                        },
                        onChanged: (value) {
                          controller.searchController.text = value;
                          controller.searchUser(controller.searchController.text, widget.userLists);
                          controller.isSearching = true;
                          setState(() {});
                        },
                        title: 'Search by name...',
                      ),
                    ),
                    Visibility(
                      visible: controller.isSearching == true,
                      child: InkWell(
                          onTap: () {
                            controller.searchController.clear();
                            controller.searchedUsers = [];
                            controller.isSearching = false;
                            setState(() {});
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(Icons.clear, color: primaryColor),
                          )),
                    ),
                  ],
                ),
                Expanded(
                  child: StreamBuilder(
                      stream: controller.getUserDatafromfirebase(),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                          case ConnectionState.none:
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          case ConnectionState.active:
                          case ConnectionState.done:
                            DateTime now = DateTime.now();
                            String formattedDateTime = DateFormat(' hh:mm a').format(now);
                            // print("Searcher uers :${controller.searchedUsers.length}");
                            if (controller.searchedUsers.isNotEmpty) {
                              return ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: controller.searchedUsers.length,
                                  itemBuilder: (context, index) {
                                    final user = controller.searchedUsers[index];
                                    return CustomChatTiles(
                                      user: user,
                                    );
                                  });
                            } else {
                              return const Center(child: Text('Searching For Friends.....'));
                            }
                        }
                      }),
                ),
              ],
            ),
          ),
        );
      });
    });
  }
}
