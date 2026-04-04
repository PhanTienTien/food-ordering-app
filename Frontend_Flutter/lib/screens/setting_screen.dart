import 'package:flutter/material.dart';
import '../constants/colors.dart';

class SettingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text("Settings",
            style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),

      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [

            /// 🔹 USER INFO
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 5),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(
                        "https://i.pravatar.cc/150"),
                  ),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text("Tien Phan",
                          style: TextStyle(
                              fontWeight: FontWeight.bold)),
                      Text("tienphan@email.com",
                          style:
                          TextStyle(color: Colors.grey)),
                    ],
                  )
                ],
              ),
            ),

            SizedBox(height: 20),

            /// 🔹 MENU
            _buildItem(Icons.person, "Profile"),
            _buildItem(Icons.location_on, "Address"),
            _buildItem(Icons.payment, "Payment"),
            _buildItem(Icons.notifications, "Notification"),
            _buildItem(Icons.lock, "Change Password"),

            SizedBox(height: 20),

            /// 🔹 LOGOUT
            _buildItem(Icons.logout, "Logout", isLogout: true),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(IconData icon, String title,
      {bool isLogout = false}) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 5),
        ],
      ),
      child: ListTile(
        leading: Icon(icon,
            color: isLogout ? Colors.red : AppColors.primary),
        title: Text(title),
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          // TODO: xử lý navigation
        },
      ),
    );
  }
}