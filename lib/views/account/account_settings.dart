import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Account_Settings extends StatefulWidget {
  const Account_Settings({super.key});

  @override
  State<Account_Settings> createState() => _Account_SettingsState();
}

class _Account_SettingsState extends State<Account_Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: FractionallySizedBox(
        heightFactor: 0.9,
        child: Column(
          children: [
            SizedBox(
              height: 20.0,
              child: AppBar(
                toolbarHeight: 30.0,
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Done',
                      style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
                automaticallyImplyLeading: false,
                backgroundColor: Colors.red,
              ),
            ),
            // Add your settings options here
            Expanded(
                child: Container(
                  child: Column(
                    children: <Widget> [
                      Icon(
                          Icons.person,
                          color: Colors.green
                      ),
                      Text('Account settings', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),

                      Card(
                          child: ListTile(
                              title: Text("Account Username"),
                            leading: CircleAvatar(
                           //add a background image
                            )
                              //need to add a trailing editor
                          )
                      ),


                      ListTile(
                        leading: Icon(Icons.lock_outline),
                        title: Text("Change Password"),
                        trailing: Icon(Icons.keyboard_arrow_right),
                        onTap: () {
                          //change password
                        },
                      ),
                      ListTile(
                        leading:Icon(Icons.location_on, color: Colors.purple),
                        title: Text("Change Language"),
                        trailing: Icon(Icons.keyboard_arrow_right),
                        onTap: () {
                          //change password
                        },

                      ),
                      ListTile(
                        leading:Icon(Icons.location_on, color: Colors.purple),
                        title: Text("Change Location"),
                        trailing: Icon(Icons.keyboard_arrow_right),
                        onTap: () {
                        //change location
                      },
                        ),
                      const SizedBox(height: 10.0),
                      Text("Notification Settings", style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo
                      ),),
                     SwitchListTile(
                    activeColor: Colors.purple,
                    contentPadding: const EdgeInsets.all(0),
                    value: true,
                    title: Text("Received notifications"),
                    onChanged: (val){},
                  ),

                      SwitchListTile(
                        activeColor: Colors.purple,
                        contentPadding: const EdgeInsets.all(0),
                        value: true,
                        title: Text("Received newsletter"),
                        onChanged: null,
                      ),

                      SwitchListTile(
                        activeColor: Colors.purple,
                        contentPadding: const EdgeInsets.all(0),
                        value: false,
                        title: Text("Received offer notifications"),
                        onChanged: (val){},
                      ),








                    ],
                  ),
                )),





          ],
        ),
      ),
    );
  }
}
