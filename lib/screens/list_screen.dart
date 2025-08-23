import 'package:collaborative_shopping_list/controllers/lists_controller.dart';
import 'package:collaborative_shopping_list/models/list_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListScreen extends StatelessWidget {
  final String listId;
  final String listTitle;

  const ListScreen({super.key, required this.listId, required this.listTitle});

  @override
  Widget build(BuildContext context) {
    final ListsController listsController = Get.find<ListsController>();
    final TextEditingController nameController = TextEditingController();
    final TextEditingController quantityController = TextEditingController();
    RxList<ListItem> items = <ListItem>[].obs;
    items.bindStream(listsController.getItemsStream(listId));

    return Scaffold(
      appBar: AppBar(
        title: Text(listTitle),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Item Name'),
                  ),
                ),
                SizedBox(
                  width: 100,
                  child: TextField(
                    controller: quantityController,
                    decoration: const InputDecoration(labelText: 'Quantity'),
                    keyboardType: TextInputType.number,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    int quantity = int.tryParse(quantityController.text) ?? 1;
                    listsController.addItem(listId, nameController.text, quantity);
                    nameController.clear();
                    quantityController.clear();
                  },
                  child: const Text('Add Item'),
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() => ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    ListItem item = items[index];
                    return ListTile(
                      title: Text('${item.name} (x${item.quantity})'),
                      subtitle: Text('Added by: ${item.addedBy}'),
                      leading: Checkbox(
                        value: item.isBought,
                        onChanged: (value) {
                          if (value != null) {
                            listsController.toggleBought(listId, item.id, item.isBought);
                          }
                        },
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => listsController.deleteItem(listId, item.id),
                      ),
                    );
                  },
                )),
          ),
        ],
      ),
    );
  }
}