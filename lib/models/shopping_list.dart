class ShoppingList {
  final String id;
  final String title;
  final String? description;
  final String ownerUid;
  final List<String> members;

  ShoppingList({
    required this.id,
    required this.title,
    this.description,
    required this.ownerUid,
    required this.members,
  });

  factory ShoppingList.fromMap(Map<String, dynamic> map, String id) {
    return ShoppingList(
      id: id,
      title: map['title'] ?? '',
      description: map['description'],
      ownerUid: map['ownerUid'] ?? '',
      members: List<String>.from(map['members'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'ownerUid': ownerUid,
      'members': members,
    };
  }
}