import 'dart:typed_data';
import 'package:amir_optic/exceptions/online_db_service_exceptions.dart';
import 'package:image_picker/image_picker.dart';
import 'package:amir_optic/models/client.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class OnlineDBSerivce {
  static final _firebaseFirestore = FirebaseFirestore.instance;
  static final _clientsCollection = _firebaseFirestore.collection("clients");

  static Future addClient(Client client) async {
    /*
    Adds client to firestore

    param 1: client data
    */

    late bool _doesClientExist;

    // The default value on the online data base of the id property is "". so if there is no id, the value of the id property
    // will be "". So if client doesn't have id it's id will be "". so if we will ask for all the clients with the id value of "" - it will return
    // us all the clients without the id's.
    if (client.id != "") {
      _doesClientExist = await doesClientExist(byId: client.id);
    } else {
      _doesClientExist = false;
    }

    // Checks if the client is already exists
    if (_doesClientExist) {
      throw ClientAlreadyExistsException();
    }

    await _clientsCollection.doc(client.uid).set(client.toMap());
  }

  static Future updateClient(Client client) async {
    /*
    Updates client data

    param 1: the new data of the client
    */

    // Checks if the client exists
    if (!(await doesClientExist(byUid: client.uid))) {
      throw ClientDoesNotExistsException();
    }

    // Checks if the id is already in use

    // The default value on the online data base of the id property is "". so if there is no id, the value of the id property
    // will be "". So if client doesn't have id it's id will be "". so if we will ask for all the clients with the id value of "" - it will return
    // us all the clients without the id's.
    if (client.id != "") {
      try {
        var _client = await getClientById(client.id);

        // If the id is already in use
        if (client.uid != _client.uid) {
          throw ClientIdDoesAlreadyInUse();
        }
        // If the client is already in the system (so the returns client it's this client...)
        else {}
      } // If the id is free (does not already in use)
      on ClientDoesNotExistsException {}
    }

    await _clientsCollection.doc(client.uid).set(client.toMap());
  }

  static Future deleteClient(String clientUid) async {
    /*
    - Deletes the client data from firestore
    - Deletes all the client media from firebase storage

    param 1: the client unique id
    */

    // Checks if the client exists
    bool _doesClientExist = await doesClientExist(byUid: clientUid);
    if (!_doesClientExist) {
      throw ClientDoesNotExistsException();
    }

    // Deletes the purchases collection from the client doc
    for (var element in (await _clientsCollection
            .doc(clientUid)
            .collection("purchases")
            .get())
        .docs) {
      // Deletes each purchase alone (because there is no option to delete whole collection together)
      await deletePurchase(element.get("uid"), clientUid);
    }

    // Deletes the client's document
    await _clientsCollection.doc(clientUid).delete();
  }

  static Future<bool> doesClientExist({String? byId, String? byUid}) async {
    /*
    Returns if client exists

    param 1: client's unique id
    */

    try {
      if (byId != null) {
        await getClientById(byId);
      } else if (byUid != null) {
        await getClientByUid(byUid);
      }

      return true;
    } on ClientDoesNotExistsException {
      return false;
    }
  }

  static Future<Client> getClientByUid(String uid) async {
    /*
    Returns client by his unique id

    param 1: client's unique id
    */

    var client = await _clientsCollection.doc(uid).get();

    if (!client.exists) {
      throw ClientDoesNotExistsException();
    }

    return Client.fromMap(client.data()!);
  }

  static Future<Client> getClientById(String id) async {
    /*
    Returns client by his id

    param 1: client's id
    */

    var client = (await _clientsCollection.where("id", isEqualTo: id).get());

    if (client.docs.isEmpty) {
      throw ClientDoesNotExistsException();
    }

    return Client.fromMap(client.docs.first.data());
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getClientsByNameSnapshots(
      String firstName, String lastName) {
    /*
    Returns stream of all the clients with the first and last name as given on the online db

    param 1: the first name of the client
    param 2: the last name of the client
    */

    if(lastName == ""){
      return _clientsCollection
        .where("firstName", isEqualTo: firstName)
        .snapshots();
    }
    
  
    return _clientsCollection
        .where("firstName", isEqualTo: firstName).where("lastName", isEqualTo: lastName)
        .snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>>
      getClientsByPhoneNumbersSnapshots(String phoneNumber) {
    /*
    Returns stream of all the clients with the phone number : [phoneNumber] on the online db

    param 1: the phone number to search
    */

    return _clientsCollection
        .where("phoneNumbers", arrayContains: phoneNumber)
        .snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getClientsByIdSnapshots(
      String id) {
    /*
    Returns stream of all the clients with the id : [id] on the online db

    param 1: the id to search
    */

    return _clientsCollection.where("id", isEqualTo: id).snapshots();
  }

  static Future addPurchase(dynamic purchase, String clientUid,
      {XFile? purchaseImage}) async {
    /*
    Adds a new purchase to the client

    param 1: the purchase
    param 2: the client's unique id
    param 3: the purchase's image
    */

    if (await doesClientExist(byUid: clientUid) == false) {
      throw ClientDoesNotExistsException();
    }

    // Uploads the purchase image (if there is one) to firebase storage
    if (purchaseImage != null) {
      purchase.imageUrl =
          await _uploadPurchaseImage(purchaseImage, clientUid, purchase.uid);
    }

    // Uplodas the client data
    await _clientsCollection
        .doc(clientUid)
        .collection("purchases")
        .doc(purchase.uid)
        .set(purchase.toMap());
  }

  static Future<dynamic> updatePurchase(
    dynamic purchase,
    String clientUid,
    XFile? purchaseImage,
  ) async {
    /*
    Updates the purchase on the online DB

    param 1: the purchase 
    param 2: the client unique id
    param 3: the purchaes image
   
    return: the purchase object
    */

    if (await doesClientExist(byUid: clientUid) == false) {
      throw ClientDoesNotExistsException();
    }

    // If new image
    if (purchase.imageUrl == null && purchaseImage != null) {
      purchase.imageUrl =
          await _uploadPurchaseImage(purchaseImage, clientUid, purchase.uid);
    }
    // If image has been removed
    else if (purchase.imageUrl != null && purchaseImage == null) {
      await deletePurchase(purchase.uid, clientUid);
      purchase.imageUrl = null;
    }
    // If has been updated or has nothing has happend
    else if (purchase.imageUrl != null && purchaseImage != null) {
      // If has been updated
      if (await purchaseImage.readAsBytes() !=
          await getPurchaeImageData(purchase.imageUrl)) {
        purchase.imageUrl = await _updatePurchaeImage(
            purchaseImage, clientUid, purchase.uid, purchase.imageUrl);
      }
      // If nothing has happend
      else {}
    }

    // Updates the firebase fields
    await _clientsCollection
        .doc(clientUid)
        .collection("purchases")
        .doc(purchase.uid)
        .set(purchase.toMap());

    return purchase;
  }

  static Future deletePurchase(String purchaseId, String clientUid) async {
    /*
    Deletes purchase from firestore and firebase storage

    param 1: purchase unique id
    param 1: the client unique id
    */

    if (await doesClientExist(byUid: clientUid) == false) {
      throw ClientDoesNotExistsException();
    }

    var ref = _clientsCollection
        .doc(clientUid)
        .collection("purchases")
        .doc(purchaseId);

    // Gets the path to the purchase image
    var imageUrl = (await ref.get()).get("imageUrl");

    // Deletes the purchase doc
    await ref.delete();
    // Deletes the purchase image
    if (imageUrl != null) await FirebaseStorage.instance.ref(imageUrl).delete();
  }

  static Future<String> _uploadPurchaseImage(
      XFile pickedImage, String clientUid, String purchaseId) async {
    /*
        Upload image of the purchase to firebase storage

        param 1: the bytes of the image
        param 2: the client unique id
        param 3: the id of the purchaes

        return: the path to the file on firebase storage 
    */

    String _extension = extension(pickedImage.name);

    String refToImage = "$clientUid/$purchaseId/image$_extension";
    var ref = FirebaseStorage.instance.ref(refToImage);

    await ref.putData(await pickedImage.readAsBytes(),
        SettableMetadata(contentType: pickedImage.mimeType));

    return refToImage;
  }

  static Future<String> _updatePurchaeImage(XFile purchaseImage,
      String clientUid, String purchaseId, String purchaseImageUrl) async {
    /*
        Updates the image of the purchase in firebase storage

        param 1: the purchaes image
        param 2: the client unique id
        param 3: the id of the purchase
        parma 4: the url of the purchase image

        return: the path to the file on the firebase storage service
    */

    // Deletes the old image
    await _deletePurchaseImage(purchaseImageUrl);

    // Uploads the new image
    purchaseImageUrl =
        await _uploadPurchaseImage(purchaseImage, clientUid, purchaseId);

    // Returns the new url
    return purchaseImageUrl;
  }

  static Future _deletePurchaseImage(String purchaseImageUrl) async {
    /*
    Deletes the image of the purchae from the firebase storage servicve

    param 1: the path to the image on the firebase storage service
    */
    var ref = FirebaseStorage.instance.ref(purchaseImageUrl);
    await ref.delete();
  }

  static Future<Uint8List> getPurchaeImageData(String imageUrl) async {
    /*
    Returns the data (Uint8List) of the purchase image 

    param 1: the path to the purchase image in firebase storage

    */
    return (await FirebaseStorage.instance.ref(imageUrl).getData())!;
  }
}
