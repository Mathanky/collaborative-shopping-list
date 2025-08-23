import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collaborative_shopping_list/controllers/auth_controller.dart';
import 'package:collaborative_shopping_list/models/shopping_list.dart';
import 'package:collaborative_shopping_list/models/list_item.dart';
import 'package:get/get.dart';

class ListsController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthController _authController = Get.find<AuthController>();
  RxList<ShoppingList> userLists = <ShoppingList>[].obs;

  @override
  void onInit() {
    super.onInit();
    _bindUserLists();
  }

  void _bindUserLists() {
    if (_authController.user.value == null) return;
    userLists.bindStream(
      _firestore
          .collection('lists')
          .where('members', arrayContains: _authController.user.value!.uid)
          .snapshots()
          .map((snapshot) => snapshot.docs.map((doc) => ShoppingList.fromMap(doc.data(), doc.id)).toList()),
    );
  }

  Future<String> createList(String title, String? description) async {
    if (_authController.user.value == null) return '';
    try {
      String listId = _firestore.collection('lists').doc().id;
      await _firestore.collection('lists').doc(listId).set({
        'title': title,
        'description': description,
        'ownerUid': _authController.user.value!.uid,
        'members': [_authController.user.value!.uid],
      });
      Get.snackbar('Success', 'List created! Share code: $listId');
      return listId;
    } catch (e) {
      Get.snackbar('Error', 'Failed to create list: $e');
      return '';
    }
  }

  Future<void> joinList(String listCode) async {
    if (_authController.user.value == null) return;
    try {
      DocumentReference listRef = _firestore.collection('lists').doc(listCode);
      DocumentSnapshot snapshot = await listRef.get();
      if (!snapshot.exists) {
        Get.snackbar('Error', 'Invalid list code');
        return;
      }
      await listRef.update({
        'members': FieldValue.arrayUnion([_authController.user.value!.uid]),
      });
      Get.snackbar('Success', 'Joined list!');
    } catch (e) {
      Get.snackbar('Error', 'Failed to join: $e');
    }
  }

  Future<void> leaveList(String listId) async {
    if (_authController.user.value == null) return;
    try {
      await _firestore.collection('lists').doc(listId).update({
        'members': FieldValue.arrayRemove([_authController.user.value!.uid]),
      });
      Get.snackbar('Success', 'Left list');
    } catch (e) {
      Get.snackbar('Error', 'Failed to leave: $e');
    }
  }

  Future<void> deleteList(String listId) async {
    if (_authController.user.value == null) return;
    try {
      await _firestore.collection('lists').doc(listId).delete();
      Get.snackbar('Success', 'List deleted');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete: $e');
    }
  }

  Stream<List<ListItem>> getItemsStream(String listId) {
    return _firestore
        .collection('lists')
        .doc(listId)
        .collection('items')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => ListItem.fromMap(doc.data(), doc.id)).toList());
  }

  Future<void> addItem(String listId, String name, int quantity) async {
    if (_authController.user.value == null) return;
    try {
      String itemId = _firestore.collection('lists').doc(listId).collection('items').doc().id;
      await _firestore.collection('lists').doc(listId).collection('items').doc(itemId).set({
        'name': name,
        'quantity': quantity,
        'isBought': false,
        'addedBy': _authController.user.value!.displayName ?? _authController.user.value!.email.split('@')[0],
      });
      Get.snackbar('Success', 'Item added!');
    } catch (e) {
      Get.snackbar('Error', 'Failed to add item: $e');
    }
  }

  Future<void> toggleBought(String listId, String itemId, bool isBought) async {
    try {
      await _firestore.collection('lists').doc(listId).collection('items').doc(itemId).update({
        'isBought': !isBought,
      });
    } catch (e) {
      Get.snackbar('Error', 'Failed to update item: $e');
    }
  }

  Future<void> deleteItem(String listId, String itemId) async {
    try {
      await _firestore.collection('lists').doc(listId).collection('items').doc(itemId).delete();
      Get.snackbar('Success', 'Item deleted!');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete item: $e');
    }
  }
}