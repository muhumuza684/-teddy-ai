# 🐻 Teddy AI v2.0 — Uganda's AI Assistant

Built with Flutter. Powered by Sunbird AI (Sunflower).
Free to build. Free to use.

---

## 📱 What's inside

| Feature | Description |
|---|---|
| 8 knowledge sectors | Agriculture, Health, Law, Govt, Education, Business, Culture, Environment |
| 6 Ugandan languages | English, Luganda, Runyankole, Acholi, Ateso, Lugbara |
| Voice input | Speak your question in Luganda — Sunbird STT transcribes it |
| Voice output | Teddy reads answers back in your language (TTS) |
| Daily tips | A new useful Uganda tip every day |
| Remembers you | Your name, district, occupation tailored into every answer |
| Chat history | Conversations saved per sector, persists between sessions |
| Onboarding | First-time setup collects your profile |
| Offline friendly | Knowledge base baked in — no network needed for base facts |

---

## 🚀 Setup

### Step 1 — Get your FREE Sunbird API key
1. Go to **https://api.sunbird.ai/register**
2. Sign up (completely free)
3. Copy your API key from the dashboard

### Step 2 — Add your API key
Open `.env` in the root folder:
```
SUNBIRD_API_KEY=paste_your_key_here
```

### Step 3 — Install dependencies
```bash
flutter pub get
```

### Step 4 — Run
```bash
# Run on connected Android phone
flutter run

# Build release APK
flutter build apk --release
```

APK will be at:
`build/app/outputs/flutter-apk/app-release.apk`

---

## 📁 Project Structure

```
lib/
├── main.dart
├── theme.dart
├── models/
│   ├── message.dart
│   ├── sector.dart
│   └── user_profile.dart
├── services/
│   ├── sunbird_service.dart      ← All Sunbird API calls
│   └── storage_service.dart      ← Local persistence
├── data/
│   └── daily_tips.dart           ← Daily tip content
├── screens/
│   ├── splash_screen.dart
│   ├── onboarding_screen.dart    ← First-time profile setup
│   ├── home_screen.dart          ← Sector grid + daily tip
│   ├── chat_screen.dart          ← Main chat (per sector)
│   └── profile_screen.dart
└── widgets/
    ├── chat_bubble.dart
    ├── daily_tip_card.dart
    ├── language_selector.dart
    ├── sector_card.dart
    └── voice_button.dart

assets/
└── knowledge/
    └── uganda_knowledge.txt      ← Uganda facts (you keep adding!)
```

---

## 🧠 How to make Teddy smarter (no code needed)

Open `assets/knowledge/uganda_knowledge.txt` and add more Uganda facts.

Example — adding more farming info:
```
COFFEE PRICES (2024):
Robusta coffee: UGX 8,000-10,000 per kilo (farm gate)
Arabica coffee: UGX 12,000-15,000 per kilo (farm gate)
Best buyers: UCDA registered exporters, cooperatives
```

The more you add, the smarter Teddy gets. No coding required.

---

## 🔮 Phase 3 ideas (when you have users)
- Push notifications for daily tips
- WhatsApp integration via Twilio
- Market prices API (live data)
- Weather API for farming alerts
- Community forum within the app

---

## 🤝 Built on
- [Sunbird AI](https://sunbird.ai) — Uganda's own AI (free API)
- Flutter — Google's cross-platform framework
- Made in Uganda 🇺🇬 for Uganda

---

*"Abantu nibabo" — People are everything.*
