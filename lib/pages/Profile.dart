import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:trackmate/pages/AccountPage.dart';
import 'package:trackmate/pages/UnderConstruction.dart';
import 'package:trackmate/pages/login_page.dart';

class Profile extends StatefulWidget {
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool showProgressIndicator = false;

  bool isLoading = false;
  Future<void> _handleLogout() async {
    await signUserOut();
    // Navigator.pop(context); // Close the drawer

    // Navigate to the login page or any other relevant page after signing out
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => LoginPage(
                onTap: () {},
              )), // Replace LoginPage with the actual login page
    );
  }

  Future<void> signUserOut() async {
    setState(() {
      showProgressIndicator = true;
    });

    await Future.delayed(Duration(seconds: 2)); // Introduce a 2-second delay

    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print("Sign out error: $e");
    } finally {
      setState(() {
        showProgressIndicator = false;
      });
    }
  }

  void onItemPressed(BuildContext context, {required int index}) {
    Navigator.pop(context);

    switch (index) {
      case 0:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => UnderConstructionPage()));
        break;
      case 1:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => UnderConstructionPage()));
        break;
      case 2:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => UnderConstructionPage()));
        break;
      case 3:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => UnderConstructionPage()));
        break;
      case 4:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => UnderConstructionPage()));
        break;
    }
  }

  String name = '';
  String gmail = '';

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    loadUserData();
  }

  @override
  void dispose() {
    // Dispose of your AnimationControllers here
    super.dispose();
  }

  void toggleLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  void loadUserData() async {
    try {
      toggleLoading();
      final User? firebaseUser = await FirebaseAuth.instance.currentUser;
      if (firebaseUser != null) {
        DatabaseReference userRef = FirebaseDatabase.instance
            .reference()
            .child("users")
            .child(firebaseUser.uid);
        DatabaseEvent dataSnapshot = await userRef.once();

        if (dataSnapshot.snapshot.value != null) {
          Map? userData = dataSnapshot.snapshot.value as Map?;

          // Set data to text controllers
          name = userData?["name"]?.toString() ?? "";

          // Set other text controlrlers accordingly
          gmail = userData?["email"]?.toString() ?? "";
        }
      }
    } catch (e) {
      print("Error loading user data: $e");
    } finally {
      toggleLoading(); // Hide loading animation
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
                    'lib/images/loading_animation.json', // Replace with your animation file path
                  ),
                  Text(
                    'Were are setting up, please wait',
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 40, 0, 0),
                      child: Text(
                        name.isEmpty ? 'name' : name,
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Poppins-Regular',
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 30),
                      child: Text(
                        gmail.isEmpty ? 'gmail' : gmail,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Poppins-Light',
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(height: 10),
                          AccountSettingsTile(
                            title: 'Add/View My Vehicles',
                            icon: Icons.directions_car,
                            iconColor: Colors.blue,
                            onTap: () {
                              // Add your logic for Add/View My Vehicles here
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        AddNewVehicleScreen()),
                              );
                            },
                          ),
                          AccountSettingsTile(
                            title: 'Notification Settings',
                            icon: Icons.notifications,
                            iconColor: Colors.orange,
                            onTap: () {
                              // Add your logic for Notification Settings here
                            },
                          ),
                          AccountSettingsTile(
                            title: 'Update Profile',
                            icon: Icons.person,
                            iconColor: Colors.green,
                            onTap: () {
                              // Add your logic for Update Profile here
                            },
                          ),
                          AccountSettingsTile(
                            title: 'Change Password',
                            icon: Icons.lock,
                            iconColor: Colors.purple,
                            onTap: () {
                              // Add your logic for Change Password here
                            },
                          ),
                          AccountSettingsTile(
                            title: 'Contact Us',
                            icon: Icons.contact_mail,
                            iconColor: Colors.red,
                            onTap: () {
                              // Add your logic for Contact Us here
                            },
                          ),
                          Divider(),
                          AccountSettingsTile(
                            title: 'Delete Account',
                            icon: Icons.delete,
                            iconColor: Colors.grey,
                            onTap: () {
                              // Add your logic for Delete Account here
                            },
                            textColor: Colors.red,
                          ),
                          AccountSettingsTile(
                            title: 'Logout',
                            icon: Icons.logout,
                            iconColor: Colors.red,
                            onTap: () {
                              signUserOut(); // Add your logic for Logout here
                            },
                            textColor: Colors.red,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
