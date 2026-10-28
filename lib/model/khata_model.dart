enum KhataType { kharcha, kamai }

class KhataEntryModel {
  final String id;
  final String title;
  final String category;
  final double amount;
  final KhataType type;
  final DateTime date;
  final String? note;
  final String? cropTag;
  final bool isVoiceEntry;
  final String? voiceTranscript;

  const KhataEntryModel({
    required this.id,
    required this.title,
    required this.category,
    required this.amount,
    required this.type,
    required this.date,
    this.note,
    this.cropTag,
    this.isVoiceEntry = false,
    this.voiceTranscript,
  });

  bool get isKharcha => type == KhataType.kharcha;
  bool get isKamai => type == KhataType.kamai;

  KhataEntryModel copyWith({
    String? id,
    String? title,
    String? category,
    double? amount,
    KhataType? type,
    DateTime? date,
    String? note,
    String? cropTag,
    bool? isVoiceEntry,
    String? voiceTranscript,
  }) {
    return KhataEntryModel(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      date: date ?? this.date,
      note: note ?? this.note,
      cropTag: cropTag ?? this.cropTag,
      isVoiceEntry: isVoiceEntry ?? this.isVoiceEntry,
      voiceTranscript: voiceTranscript ?? this.voiceTranscript,
    );
  }
}
