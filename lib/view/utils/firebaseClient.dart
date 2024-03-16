// ignore_for_file: file_names

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:money_bank/model/user_model.dart';
import 'package:money_bank/view/utils/database_provider.dart';

class FirebaseClient {
  DatabaseProvider db = DatabaseProvider();
  // get data from firebase firestore
  Future<dynamic> getData(path, limit, context) async {
    try {
      final CollectionReference quizCollection =
          FirebaseFirestore.instance.collection(path);
      int size = limit;
      if (limit == 0) {
        size = 1000;
      }

      QuerySnapshot<Map<String, dynamic>> snapshot = await quizCollection
          .limit(size)
          .get() as QuerySnapshot<Map<String, dynamic>>;
      return snapshot;
    } catch (e) {
      if (kDebugMode) {
        print("-------------------------------- error ----- $e");
      }
    }
  }

// add data to firebase firestore
  addData(path, body) async {
    try {
      await FirebaseFirestore.instance.collection(path).add(body).then((value) {
        return true;
      });
    } catch (e) {
      return false;
    }
  }

  // check if user exist

  Future<bool> getUserBy(String uid, context) async {
    try {
      CollectionReference usersCollection =
          FirebaseFirestore.instance.collection('users');

      QuerySnapshot querySnapshot =
          await usersCollection.where('uid', isEqualTo: uid).get();

      if (querySnapshot.docs.isNotEmpty || querySnapshot.docs.first.exists) {
        await db.cleanUserTable();
        final user = querySnapshot.docs.first.data() as Map<String, dynamic>;
        await db.insertUser(UserModel.fromJson(user));
        // final statusSnapshot = await getStatusBy(uid, context);
        // if (statusSnapshot.isNotEmpty && statusSnapshot['userId'] == uid) {
        //   return true;
        // }
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  // Future<Map<String, dynamic>> getStatusBy(String uid, context) async {
  //   try {
  //     CollectionReference statusCollection =
  //         FirebaseFirestore.instance.collection('userstatus');
  //     QuerySnapshot statusSnapshot =
  //         await statusCollection.where('userId', isEqualTo: uid).get();

  //     if (statusSnapshot.docs.isNotEmpty || statusSnapshot.docs.first.exists) {
  //       final status = statusSnapshot.docs.first.data() as Map<String, dynamic>;

  //       await db.insertUserStatus(UserStatus.fromMap(status));

  //       return status;
  //     }
  //     return {"status": false};
  //   } catch (e) {
  //     return {"status": false};
  //   }
  // }

  Future<bool> deleteUser(uid, collection) async {
    try {
      await FirebaseFirestore.instance
          .collection(collection)
          .where('userId',
              isEqualTo: uid) // Assuming 'userId' is a field in your documents
          .get()
          .then((QuerySnapshot querySnapshot) {
        for (var doc in querySnapshot.docs) {
          doc.reference.delete();
        }
      });
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error while deleting user & user status $e');
      }
      // Handle the error as needed
      return false;
    }
  }
}
