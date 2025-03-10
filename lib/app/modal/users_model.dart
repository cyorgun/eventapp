import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserModel {
String? email;
String? imageurl;
String? photoProfile;
String? name;
String? phone;
String? role;
String? id;

  UserModel({
    this.email,
    this.imageurl,
    this.name,
    this.phone,
    this.photoProfile,
    this.role,
    this.id,
  });

  factory UserModel.fromFirestore(DocumentSnapshot snapshot){
    Map data = snapshot.data() as Map<dynamic, dynamic>;
    
    
    return UserModel(
       email : data['email'],
    imageurl  : data['image url'],
    photoProfile  : data['photoProfile'],
    name: data['name'],
    phone  : data['phone'],
    role  : data['role'],
    id  : data['uid'],
    );
  }


}

