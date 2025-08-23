import 'package:collaborative_shopping_list/controllers/auth_controller.dart';
import 'package:collaborative_shopping_list/controllers/lists_controller.dart';
import 'package:collaborative_shopping_list/models/shopping_list.dart';
import 'package:collaborative_shopping_list/screens/list_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();
    final ListsController listsController = Get.find<ListsController>();
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descController = TextEditingController();
    final TextEditingController codeController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: authController.logout,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'List Title'),
                ),
                TextField(
                  controller: descController,
                  decoration: const InputDecoration(labelText: 'Description (optional)'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await listsController.createList(titleController.text, descController.text);
                    titleController.clear();
                    descController.clear();
                  },
                  child: const Text('Create List'),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: codeController,
                    decoration: const InputDecoration(labelText: 'Enter List Code'),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => listsController.joinList(codeController.text),
                  child: const Text('Join List'),
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              if (listsController.userLists.isEmpty) {
                return const Center(child: Text('No lists yet. Create or join one!'));
              }
              return ListView.builder(
                itemCount: listsController.userLists.length,
                itemBuilder: (context, index) {
                  ShoppingList list = listsController.userLists[index];
                  bool isOwner = list.ownerUid == authController.user.value?.uid;
                  return ListTile(
                    title: Text(list.title),
                    subtitle: Text(list.description ?? 'No description'),
                    onTap: () => Get.to(() => ListScreen(listId: list.id, listTitle: list.title)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.exit_to_app),
                          onPressed: () => listsController.leaveList(list.id),
                          tooltip: 'Leave List',
                        ),
                        if (isOwner)
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => listsController.deleteList(list.id),
                            tooltip: 'Delete List',
                          ),
                      ],
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}