class DailyTip {
  final String emoji;
  final String titleEn;
  final String titleLg;
  final String bodyEn;
  final String bodyLg;
  final String sector;

  const DailyTip({
    required this.emoji,
    required this.titleEn,
    required this.titleLg,
    required this.bodyEn,
    required this.bodyLg,
    required this.sector,
  });
}

const List<DailyTip> kDailyTips = [
  DailyTip(
    emoji: '🌱',
    titleEn: 'Farming Tip',
    titleLg: 'Obubaka bw\'Olimi',
    bodyEn: 'Mulch your crops during dry season to keep moisture in the soil and reduce watering needs by up to 70%.',
    bodyLg: 'Teeka ebikomo ku bisimba byo mu kiseera ky\'okukaala okukuuma amazzi mu ttaka era okedde okuwatirira okutuuka ku 70%.',
    sector: 'agriculture',
  ),
  DailyTip(
    emoji: '💧',
    titleEn: 'Health Tip',
    titleLg: 'Obubaka bw\'Obulamu',
    bodyEn: 'Boil your drinking water for at least 1 minute to kill all bacteria and prevent typhoid and cholera.',
    bodyLg: 'Oza amazzi g\'okunywa ekitundu ky\'essaawa emu oyo buli kiseera okutta bakyeria yonna n\'okwegga omutego gwa tifoyidi ne kolera.',
    sector: 'health',
  ),
  DailyTip(
    emoji: '⚖️',
    titleEn: 'Know Your Rights',
    titleLg: 'Manya Eddembe Lyo',
    bodyEn: 'Your landlord CANNOT evict you without a court order. If threatened, report to your LC1 chairman immediately.',
    bodyLg: 'Mupangisa wo TAYINZA kukuggya mu nnyumba wabula omuteeka gwa kkooti. Nga bakukuba obugumba, buulira omukulu wa LC1 wo mangu.',
    sector: 'law',
  ),
  DailyTip(
    emoji: '📚',
    titleEn: 'Education Tip',
    titleLg: 'Obubaka bw\'Emyooga',
    bodyEn: 'Government secondary school is FREE under USE. No child should be sent home for school fees in S1-S4.',
    bodyLg: 'Ssekondari ya gavumenti YATALAWUFU wansi wa USE. Mwana teyetaagisa kutumibwa awaka olw\'ettendo mu S1-S4.',
    sector: 'education',
  ),
  DailyTip(
    emoji: '💰',
    titleEn: 'Money Tip',
    titleLg: 'Obubaka bw\'Ensimbi',
    bodyEn: 'Join a SACCO to access loans at 1-2% monthly interest — much cheaper than banks or money lenders.',
    bodyLg: 'Yingira mu SACCO okufuna ssente ez\'okweyazika ku musolo gwa 1-2% mu mwezi — ompewomu okusinga amabanki oba abazimbulukufu.',
    sector: 'business',
  ),
  DailyTip(
    emoji: '🏛️',
    titleEn: 'Government Tip',
    titleLg: 'Obubaka bwa Gavumenti',
    bodyEn: 'Your National ID is FREE for first-time applicants. Visit any NIRA office with your LC1 letter and birth certificate.',
    bodyLg: 'Katonto k\'eggwanga KITALAWUFU eri ababisinziira okubisaba olubereberye. Genda ku biiro ebyonna bya NIRA n\'ebbaluwa ya LC1 n\'ekitabo ky\'okuzaalibwa.',
    sector: 'government',
  ),
  DailyTip(
    emoji: '🌍',
    titleEn: 'Environment Tip',
    titleLg: 'Obubaka bw\'Ensi',
    bodyEn: 'Plant trees on your land — it is the law. Trees improve rainfall, soil quality, and protect against floods.',
    bodyLg: 'Simba ebiti ku ttaka lyo — mateeka gegateeka. Ebiti biyamba enkuba, obulungi bw\'ettaka, era bikuuma ku mazzi g\'amazzi.',
    sector: 'environment',
  ),
  DailyTip(
    emoji: '🎭',
    titleEn: 'Cultural Wisdom',
    titleLg: 'Amagezi g\'Amasangwa',
    bodyEn: '"Abantu nibabo" — People are everything. Invest in your relationships and community, not just money.',
    bodyLg: '"Abantu nibabo" — Abantu ye byona. Teeka ensimbi mu mikwano gyo n\'ekibuga kyo, so si mu ssente zokka.',
    sector: 'culture',
  ),
];

DailyTip getTodaysTip() {
  final index = DateTime.now().day % kDailyTips.length;
  return kDailyTips[index];
}
