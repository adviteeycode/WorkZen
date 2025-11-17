import 'package:flutter/material.dart';

class ProfileIcon extends StatelessWidget {
  final bool checkedIn;
  final String imageUrl;

  const ProfileIcon({
    super.key,
    required this.checkedIn,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: PopupMenuButton<String>(
        offset: const Offset(0, 50), // popup below avatar
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: Colors.grey.withOpacity(0.3)),
        ),
        color: Theme.of(context).scaffoldBackgroundColor,
        onSelected: (value) {
          if (value == "profile") {
            Navigator.pushNamed(context, '/profile');
          } else if (value == "logout") {
            // Handle logout logic here
          }
        },
        itemBuilder: (_) => [
          PopupMenuItem(
            value: "profile",
            child: Text(
              "Edit Profile",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const PopupMenuDivider(height: 1),
          PopupMenuItem(
            value: "logout",
            child: Text(
              "Log Out",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
        child: CircleAvatar(
          radius: 20,
          backgroundImage: NetworkImage(imageUrl),
        ),
      ),
    );
  }
}
