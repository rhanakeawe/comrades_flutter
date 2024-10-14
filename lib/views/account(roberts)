import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  // Todo: Add userIcon for Icon
  String userPhone = "+1234567890";
  String userEmail = "example@gmail.com";
  String userName = "Username";
  String userDesc =
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque id nunc iaculis, convallis dolor in, hendrerit est. Mauris imperdiet ipsum nec felis dapibus molestie. Nulla semper ipsum a tempus porta. ";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(
          'Account',
          style: GoogleFonts.teko(color: Colors.white, fontSize: 48),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Row( children: [Container(
                margin: const EdgeInsetsDirectional.fromSTEB(0, 5, 0, 5),
                child: const Center(
                    child: Icon(
                      // Todo: Add userIcon here
                      Icons.person,
                      size: 70,
                    )),
              ),
                Text(
                  userName,
                  style: GoogleFonts.teko(fontSize: 30),
                ),],),
              Container(
                margin: const EdgeInsetsDirectional.fromSTEB(0, 2, 0, 0),
                child: Text(
                  'Phone: $userPhone',
                  style: GoogleFonts.teko(color: Colors.black, fontSize: 20),
                ),
              ),
              Container(
                margin: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                child: Text(
                  'Email: $userEmail',
                  style: GoogleFonts.teko(color: Colors.black, fontSize: 20),
                ),
              ),
              SizedBox(
                width: 250,
                height: 2,
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.redAccent)),
                ),
              ),
              Container(
                margin: const EdgeInsetsDirectional.fromSTEB(10, 20, 10, 10),
                child: Text(
                  userDesc,
                  style: GoogleFonts.teko(fontSize: 20, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
