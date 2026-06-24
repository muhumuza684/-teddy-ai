import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../theme.dart';

class ProfileScreen extends StatelessWidget {
  final UserProfile profile;

  const ProfileScreen({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: TeddyTheme.primary,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: TeddyTheme.primarySurface,
                  child: const Text('🐻', style: TextStyle(fontSize: 40)),
                ),
                const SizedBox(height: 12),
                Text(profile.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                Text(profile.district, style: TextStyle(color: Colors.grey.shade600)),
              ],
            ),
          ),
          const SizedBox(height: 28),
          _tile(Icons.work_outline_rounded, 'Occupation', profile.occupation),
          _tile(Icons.language_rounded, 'Language', profile.language),
          _tile(Icons.location_on_outlined, 'District', profile.district),
          if (profile.tribe.isNotEmpty) _tile(Icons.people_outline_rounded, 'Community', profile.tribe),
          if (profile.interests.isNotEmpty)
            _tile(Icons.interests_outlined, 'Interests', profile.interests.join(', ')),
          const SizedBox(height: 24),
          Text(
            'Member since ${profile.createdAt.day}/${profile.createdAt.month}/${profile.createdAt.year}',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _tile(IconData icon, String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: TeddyTheme.primary),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
              Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            ],
          ),
        ],
      ),
    );
  }
}
