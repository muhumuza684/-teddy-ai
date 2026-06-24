import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/user_profile.dart';
import '../models/sector.dart';
import '../data/daily_tips.dart';
import '../theme.dart';
import '../widgets/daily_tip_card.dart';
import '../widgets/sector_card.dart';
import 'chat_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatelessWidget {
  final UserProfile profile;

  const HomeScreen({super.key, required this.profile});

  String get _greeting {
    final hour = DateTime.now().hour;
    if (profile.language == 'lug') {
      if (hour < 12) return 'Wasuze otya, ${profile.name}!';
      if (hour < 17) return 'Osiibire otya, ${profile.name}!';
      return 'Okukoona otya, ${profile.name}!';
    }
    if (hour < 12) return 'Good morning, ${profile.name}!';
    if (hour < 17) return 'Good afternoon, ${profile.name}!';
    return 'Good evening, ${profile.name}!';
  }

  String get _subGreeting {
    final isLg = profile.language == 'lug';
    return isLg ? 'Oyagala okumanya ki leero?' : 'What would you like to know today?';
  }

  @override
  Widget build(BuildContext context) {
    final tip = getTodaysTip();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: TeddyTheme.primary,
        title: Row(
          children: [
            const Text('🐻', style: TextStyle(fontSize: 22)),
            const SizedBox(width: 8),
            const Text('Teddy AI', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline_rounded, color: Colors.white),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ProfileScreen(profile: profile)),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          // Header greeting
          Container(
            color: TeddyTheme.primary,
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_greeting, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 4),
                Text(_subGreeting, style: const TextStyle(color: Colors.white70, fontSize: 14)),
                const SizedBox(height: 4),
                Text(
                  DateFormat('EEEE, d MMMM yyyy').format(DateTime.now()),
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ],
            ),
          ),

          // Daily tip
          DailyTipCard(
            tip: tip,
            languageCode: profile.language,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ChatScreen(
                  sector: kSectors.firstWhere((s) => s.id == tip.sector, orElse: () => kSectors.first),
                  profile: profile,
                  initialMessage: profile.language == 'lug' ? tip.bodyLg : tip.bodyEn,
                ),
              ),
            ),
          ),

          // Sector grid
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Text(
              profile.language == 'lug' ? 'Ekitundu ky\'ebibuuzo' : 'Choose a topic',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF424242)),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.85,
              ),
              itemCount: kSectors.length,
              itemBuilder: (context, i) {
                final sector = kSectors[i];
                return SectorCard(
                  sector: sector,
                  languageCode: profile.language,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChatScreen(
                        sector: sector,
                        profile: profile,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Quick ask anything
          Padding(
            padding: const EdgeInsets.all(16),
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChatScreen(
                    sector: kSectors.first,
                    profile: profile,
                    generalMode: true,
                  ),
                ),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search_rounded, color: Colors.grey.shade400),
                    const SizedBox(width: 10),
                    Text(
                      profile.language == 'lug' ? 'Buuza Teddy ekintu kyona...' : 'Ask Teddy anything...',
                      style: TextStyle(color: Colors.grey.shade400, fontSize: 15),
                    ),
                    const Spacer(),
                    const Text('🐻', style: TextStyle(fontSize: 18)),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
