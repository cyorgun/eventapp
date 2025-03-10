import 'package:event_app/app/view/admin_specific/user_update.dart';
import 'package:flutter/material.dart';

import '../../../base/color_data.dart';
import '../../modal/users_model.dart';

class UserDetail extends StatefulWidget {
  UserModel? user;
  UserDetail({super.key, this.user});

  @override
  State<UserDetail> createState() => _UserDetailState();
}

class _UserDetailState extends State<UserDetail> {
  @override
  Widget build(BuildContext context) {
    final UserModel user = widget.user!;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'User Detail',
          style: TextStyle(
            fontFamily: "Sofia",
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        actions: [Padding(
          padding: const EdgeInsets.only(right:10.0),
          child: InkWell(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>UserUpdate(user: user)));
            },
            child: Text("Update",style: TextStyle(
                fontFamily: "Sofia",
                fontSize: 15,
                fontWeight: FontWeight.w900,
                color: accentColor,
              
            ),),
          ),
        )],
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 25.0, right: 25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10.0,
              ),
              Center(
                child: CircleAvatar(
                  radius: 70,
                  backgroundImage: NetworkImage(user.imageurl ?? ''),
                ),
              ),
              const SizedBox(
                height: 30.0,
              ),
              const Text(
                "Name",
                style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.normal,
                    fontFamily: "Sofia"),
              ),
              Text(user.name ?? "-",
               style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Sofia"),
                    ),
                        const SizedBox(
                height: 20.0,
              ),
              const Text(
                "Email",
                style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.normal,
                    fontFamily: "Sofia"),
              ),
              Text(user.email ?? "-",
               style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Sofia"),
                    ),
                                const SizedBox(
                height: 20.0,
              ),
              const Text(
                "Phone Number",
                style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.normal,
                    fontFamily: "Sofia"),
              ),
              Text(user.phone ?? "-",
               style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Sofia"),
                    ),
                                    const SizedBox(
                height: 20.0,
              ),
              const Text(
                "Role",
                style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.normal,
                    fontFamily: "Sofia"),
              ),
              Text(user.role ?? "User",
               style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Sofia"),
                    ),
              
                                    const SizedBox(
                height: 20.0,
              ),
              const Text(
                "ID",
                style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.normal,
                    fontFamily: "Sofia"),
              ),
              Text(user.id ?? "-",
               style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Sofia"),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

