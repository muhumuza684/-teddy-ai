class Sector {
  final String id;
  final String emoji;
  final String titleEn;
  final String titleLg;
  final String color;
  final List<QuickQuestion> questions;

  const Sector({
    required this.id,
    required this.emoji,
    required this.titleEn,
    required this.titleLg,
    required this.color,
    required this.questions,
  });
}

class QuickQuestion {
  final String en;
  final String lg;

  const QuickQuestion({required this.en, required this.lg});
}

const List<Sector> kSectors = [
  Sector(
    id: 'agriculture',
    emoji: '🌱',
    titleEn: 'Agriculture',
    titleLg: 'Olimi',
    color: '#2E7D32',
    questions: [
      QuickQuestion(en: 'What crops should I plant this season?', lg: 'Nsobola okusimba ki mu kiseera kino?'),
      QuickQuestion(en: 'How do I treat banana weevil?', lg: 'Nzikiriza otya ensowera y\'ebitooke?'),
      QuickQuestion(en: 'When is the best time to plant maize?', lg: 'Ebbanga lya lusimba kasooli liri ddi?'),
      QuickQuestion(en: 'How do I improve my soil?', lg: 'Nsinzisa otya ettaka lyange?'),
    ],
  ),
  Sector(
    id: 'health',
    emoji: '🏥',
    titleEn: 'Health',
    titleLg: 'Obulamu',
    color: '#C62828',
    questions: [
      QuickQuestion(en: 'What are signs of malaria?', lg: 'Ensimba ya malaria egikola otya?'),
      QuickQuestion(en: 'Where is the nearest hospital?', lg: 'Ddwaliro erisinga okumpi liri ludda ki?'),
      QuickQuestion(en: 'How do I keep my baby healthy?', lg: 'Nzikiriza otya akaana kange obulamu?'),
      QuickQuestion(en: 'How do I get free HIV treatment?', lg: 'Nfuna otya eddwa lya HIV butalawufu?'),
    ],
  ),
  Sector(
    id: 'law',
    emoji: '⚖️',
    titleEn: 'Law & Rights',
    titleLg: 'Amateeka',
    color: '#1565C0',
    questions: [
      QuickQuestion(en: 'What are my land rights?', lg: 'Eddembe lyange ku ttaka liri otya?'),
      QuickQuestion(en: 'How does the LC system work?', lg: 'Enkola ya LC ekola otya?'),
      QuickQuestion(en: 'What do I do if I am arrested?', lg: 'Nkola ki nga bankamatawo?'),
      QuickQuestion(en: 'How do I get a free lawyer?', lg: 'Nfuna otya ssentebe w\'amateeka butalawufu?'),
    ],
  ),
  Sector(
    id: 'government',
    emoji: '🏛️',
    titleEn: 'Govt Services',
    titleLg: 'Gavumenti',
    color: '#4527A0',
    questions: [
      QuickQuestion(en: 'How do I get a National ID?', lg: 'Nfuna otya katonto k\'eggwanga?'),
      QuickQuestion(en: 'How do I get a passport?', lg: 'Nfuna otya pasipoti?'),
      QuickQuestion(en: 'How do I register a business?', lg: 'Nandika otya bizinensi yange?'),
      QuickQuestion(en: 'How do I pay taxes with URA?', lg: 'Nfukula otya omusolo ne URA?'),
    ],
  ),
  Sector(
    id: 'education',
    emoji: '📚',
    titleEn: 'Education',
    titleLg: 'Emyooga',
    color: '#E65100',
    questions: [
      QuickQuestion(en: 'Help me prepare for PLE', lg: 'Nnyamba okuteekateeka PLE yange'),
      QuickQuestion(en: 'How do I apply to Makerere?', lg: 'Nwandiisa otya e Makerere?'),
      QuickQuestion(en: 'Are there free scholarships?', lg: 'Waliwo scholarships za butalawufu?'),
      QuickQuestion(en: 'Explain photosynthesis to me', lg: 'Nnyonnyola photosynthesis'),
    ],
  ),
  Sector(
    id: 'business',
    emoji: '💰',
    titleEn: 'Business & Money',
    titleLg: 'Bizinensi',
    color: '#F57F17',
    questions: [
      QuickQuestion(en: 'How do I start a small business?', lg: 'Ntandika otya bizinensi entono?'),
      QuickQuestion(en: 'How do MTN Mobile Money charges work?', lg: 'Emirambo gya MTN Mobile Money gikola otya?'),
      QuickQuestion(en: 'How do I join a SACCO?', lg: 'Nyingira otya mu SACCO?'),
      QuickQuestion(en: 'What are today\'s market prices?', lg: 'Ebitengo by\'omutendera leero biri otya?'),
    ],
  ),
  Sector(
    id: 'culture',
    emoji: '🎭',
    titleEn: 'Culture',
    titleLg: 'Amasangwa',
    color: '#880E4F',
    questions: [
      QuickQuestion(en: 'Tell me a Luganda proverb', lg: 'Mbuulira engero ya Luganda'),
      QuickQuestion(en: 'Explain Buganda clans to me', lg: 'Nnyonnyola ebika bya Buganda'),
      QuickQuestion(en: 'Tell me about Uganda\'s history', lg: 'Mbuulira ebyafaayo by\'Uganda'),
      QuickQuestion(en: 'What are Uganda\'s national holidays?', lg: 'Ennaku ez\'olugendo mu Uganda ziri ddi?'),
    ],
  ),
  Sector(
    id: 'environment',
    emoji: '🌍',
    titleEn: 'Environment',
    titleLg: 'Ensi',
    color: '#00695C',
    questions: [
      QuickQuestion(en: 'When will the rains come?', lg: 'Enkuba ejja ddi?'),
      QuickQuestion(en: 'How do I protect my land from erosion?', lg: 'Nkuuma ttaka lyange okuva mu kweyala?'),
      QuickQuestion(en: 'What trees should I plant?', lg: 'Bisimba ki ebiti?'),
      QuickQuestion(en: 'Tell me about Uganda\'s national parks', lg: 'Mbuulira ku matooke g\'eggwanga lya Uganda'),
    ],
  ),
];
