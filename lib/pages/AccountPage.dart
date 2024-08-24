import 'package:flutter/material.dart';

void main() {
  runApp(AccountSettingsApp());
}

class AccountSettingsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Account Settings',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AccountSettingsScreen(),
    );
  }
}

class AccountSettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account Settings'),
        centerTitle: true, // Center the title
        backgroundColor: Colors.blue, // Set AppBar color to blue
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
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
                      builder: (context) => AddNewVehicleScreen()),
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
                // Add your logic for Logout here
              },
              textColor: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}

class AccountSettingsTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final Function onTap;
  final Color textColor;

  const AccountSettingsTile({
    Key? key,
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.onTap,
    this.textColor = Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: iconColor,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.black,
          fontFamily: 'Poppins-Medium',
        ),
      ),
      onTap: () => onTap(),
    );
  }
}

class AddNewVehicleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Vehicle'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Select Vehicle Type:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 10),
              DropdownButton<String>(
                items: <String>[
                  '2 Wheeler                                                 ',
                  '3 Wheeler',
                  '4 Wheeler'
                ].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                }).toList(),
                onChanged: (_) {},
              ),
              SizedBox(height: 20),
              Text(
                'Select Capacity:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 10),
              DropdownButton<String>(
                items: <String>[
                  'Below 1 Tonne                                          ',
                  'Below 2 Tonne',
                  '5 Tonne'
                ].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                }).toList(),
                onChanged: (_) {},
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Vehicle Registration',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.car_crash),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.upload),
                label: Text('Upload Vehicle Registration Images'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.upload),
                label: Text('Upload Vehicle Driving License Images'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {},
                child: Text('Add Vehicle'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
