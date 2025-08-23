class ListItem {
  final String id;
  final String name;
  final int quantity;
  final bool isBought;
  final String addedBy;

  ListItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.isBought,
    required this.addedBy,
  });

  factory ListItem.fromMap(Map<String, dynamic> map, String id) {
    return ListItem(
      id: id,
      name: map['name'] ?? '',
      quantity: map['quantity'] ?? 1,
      isBought: map['isBought'] ?? false,
      addedBy: map['addedBy'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'quantity': quantity,
      'isBought': isBought,
      'addedBy': addedBy,
    };
  }
}