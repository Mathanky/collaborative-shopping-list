import 'package:flutter/material.dart';

class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  _ShoppingListScreenState createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  final List<Map<String, dynamic>> items = [
    {'name': 'Milk', 'quantity': 2, 'checked': false},
    {'name': 'Bread', 'quantity': 1, 'checked': false},
  ];
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  void addItem(String name, int quantity) {
    setState(() {
      items.add({'name': name, 'quantity': quantity, 'checked': false});
    });
    _itemController.clear();
    _quantityController.clear();
  }

  void toggleCheck(int index) {
    setState(() {
      items[index]['checked'] = !items[index]['checked'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Shopping List', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal,
      ),
      body: Container(
        color: Colors.teal[50],
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _itemController,
                      decoration: const InputDecoration(labelText: 'Item Name'),
                    ),
                    TextField(
                      controller: _quantityController,
                      decoration: const InputDecoration(labelText: 'Quantity'),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        if (_itemController.text.isNotEmpty && _quantityController.text.isNotEmpty) {
                          addItem(_itemController.text, int.parse(_quantityController.text));
                        }
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                      child: const Text('Add Item', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) => Card(
                  elevation: 2,
                  child: ListTile(
                    leading: Checkbox(
                      value: items[index]['checked'],
                      onChanged: (value) => toggleCheck(index),
                    ),
                    title: Text('${items[index]['name']} - ${items[index]['quantity']}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => setState(() => items.removeAt(index)),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}