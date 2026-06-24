import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../services/storage_service.dart';
import '../theme.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  final _storage = StorageService();
  int _page = 0;

  // Form data
  String _name = '';
  String _district = '';
  String _occupation = 'farmer';
  String _language = 'eng';
  String _tribe = '';
  final List<String> _interests = [];

  final _districts = [
    'Kampala', 'Wakiso', 'Mukono', 'Jinja', 'Mbarara', 'Gulu', 'Lira',
    'Arua', 'Fort Portal', 'Masaka', 'Mbale', 'Soroti', 'Kabale',
    'Kasese', 'Hoima', 'Masindi', 'Moroto', 'Tororo', 'Iganga', 'Bushenyi',
  ];

  final _occupations = {
    'farmer': '🌱 Farmer',
    'trader': '💼 Trader / Businessperson',
    'student': '📚 Student',
    'teacher': '🏫 Teacher',
    'health_worker': '🏥 Health Worker',
    'boda_rider': '🏍️ Boda Boda Rider',
    'parent': '👨‍👩‍👧 Parent / Householder',
    'other': '👤 Other',
  };

  final _languages = {
    'eng': 'English',
    'lug': 'Luganda',
    'nyn': 'Runyankole',
    'ach': 'Acholi',
    'teo': 'Ateso',
    'lgg': 'Lugbara',
  };

  final _sectorInterests = [
    ('🌱', 'agriculture', 'Farming'),
    ('🏥', 'health', 'Health'),
    ('📚', 'education', 'Education'),
    ('💰', 'business', 'Business'),
    ('⚖️', 'law', 'Law & Rights'),
    ('🏛️', 'government', 'Govt Services'),
    ('🎭', 'culture', 'Culture'),
    ('🌍', 'environment', 'Environment'),
  ];

  void _next() {
    if (_page < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _page++);
    } else {
      _finish();
    }
  }

  Future<void> _finish() async {
    final profile = UserProfile(
      name: _name.isEmpty ? 'Friend' : _name,
      district: _district.isEmpty ? 'Uganda' : _district,
      occupation: _occupation,
      language: _language,
      tribe: _tribe,
      interests: _interests,
      createdAt: DateTime.now(),
    );
    await _storage.saveProfile(profile);
    await _storage.saveLanguage(_language);
    await _storage.setOnboarded();

    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => HomeScreen(profile: profile)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Progress dots
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: List.generate(4, (i) => Expanded(
                  child: Container(
                    height: 3,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color: i <= _page ? TeddyTheme.primary : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                )),
              ),
            ),

            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildWelcomePage(),
                  _buildProfilePage(),
                  _buildLocationPage(),
                  _buildInterestsPage(),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _next,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TeddyTheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    _page == 3 ? 'Start using Teddy AI 🐻' : 'Continue',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomePage() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🐻', style: TextStyle(fontSize: 72)),
          const SizedBox(height: 24),
          const Text(
            'Teddy AI',
            style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: TeddyTheme.primary),
          ),
          const SizedBox(height: 8),
          const Text(
            'Uganda\'s AI Assistant',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          const SizedBox(height: 32),
          const Text(
            'Your knowledgeable Ugandan companion for farming, health, law, education, business and more — in your language.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, height: 1.6, color: Color(0xFF424242)),
          ),
          const SizedBox(height: 24),
          _buildBadge('🌍 Built in Uganda'),
          const SizedBox(height: 8),
          _buildBadge('🗣️ Speaks Luganda & 5 other local languages'),
          const SizedBox(height: 8),
          _buildBadge('⚡ Powered by Sunbird AI'),
        ],
      ),
    );
  }

  Widget _buildBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: TeddyTheme.primarySurface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text, style: const TextStyle(fontSize: 13, color: TeddyTheme.primary, fontWeight: FontWeight.w500)),
    );
  }

  Widget _buildProfilePage() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Tell Teddy about yourself', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          const Text('Teddy gives better answers when it knows you', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 28),

          const Text('Your name', style: TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          TextField(
            decoration: const InputDecoration(hintText: 'e.g. Ssemanda, Nalwoga, Peter...'),
            onChanged: (v) => _name = v,
            textCapitalization: TextCapitalization.words,
          ),

          const SizedBox(height: 20),
          const Text('What language do you prefer?', style: TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _languages.entries.map((e) {
              final selected = _language == e.key;
              return GestureDetector(
                onTap: () => setState(() => _language = e.key),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: selected ? TeddyTheme.primary : Colors.transparent,
                    border: Border.all(color: selected ? TeddyTheme.primary : Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(e.value, style: TextStyle(color: selected ? Colors.white : Colors.grey.shade700, fontSize: 13)),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 20),
          const Text('What do you do?', style: TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _occupations.entries.map((e) {
              final selected = _occupation == e.key;
              return GestureDetector(
                onTap: () => setState(() => _occupation = e.key),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: selected ? TeddyTheme.primarySurface : Colors.transparent,
                    border: Border.all(color: selected ? TeddyTheme.primary : Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(e.value, style: TextStyle(fontSize: 12, color: selected ? TeddyTheme.primary : Colors.grey.shade700)),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationPage() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Where are you in Uganda?', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          const Text('Teddy gives advice specific to your district', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 28),
          const Text('Your district', style: TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _districts.map((d) {
              final selected = _district == d;
              return GestureDetector(
                onTap: () => setState(() => _district = d),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: selected ? TeddyTheme.primary : Colors.transparent,
                    border: Border.all(color: selected ? TeddyTheme.primary : Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(d, style: TextStyle(fontSize: 13, color: selected ? Colors.white : Colors.grey.shade700)),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildInterestsPage() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('What topics matter most to you?', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          const Text('Pick as many as you like', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 28),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _sectorInterests.map((s) {
              final selected = _interests.contains(s.$2);
              return GestureDetector(
                onTap: () => setState(() {
                  if (selected) _interests.remove(s.$2);
                  else _interests.add(s.$2);
                }),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: selected ? TeddyTheme.primarySurface : Colors.white,
                    border: Border.all(
                      color: selected ? TeddyTheme.primary : Colors.grey.shade300,
                      width: selected ? 1.5 : 0.5,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(s.$1, style: const TextStyle(fontSize: 18)),
                      const SizedBox(width: 6),
                      Text(s.$3, style: TextStyle(color: selected ? TeddyTheme.primary : Colors.grey.shade700, fontWeight: selected ? FontWeight.w600 : FontWeight.normal)),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
