import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:shop/services/farmer_profile_service.dart';

Future<void> showVoiceEntry(BuildContext context) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  builder: (_) => const VoiceEntrySheet(),
);

class VoiceEntrySheet extends StatefulWidget {
  const VoiceEntrySheet({super.key});
  @override
  State<VoiceEntrySheet> createState() => _VoiceEntrySheetState();
}

class _VoiceEntrySheetState extends State<VoiceEntrySheet> {
  final speech = SpeechToText();
  final text = TextEditingController();
  bool listening = false;
  String? error;
  @override
  void dispose() {
    speech.cancel();
    text.dispose();
    super.dispose();
  }

  Future<void> listen() async {
    try {
      if (listening) {
        await speech.stop();
        if (mounted) setState(() => listening = false);
        return;
      }
      final available = await speech.initialize(
        onStatus: (status) {
          if (mounted && status != 'listening') {
            setState(() => listening = false);
          }
        },
        onError: (e) {
          if (mounted) {
            setState(() {
              listening = false;
              error = 'आवाज़ उपलब्ध नहीं है। अनुमति जांचें या नीचे लिखें।';
            });
          }
        },
      );
      if (!mounted) return;
      if (!available) {
        setState(() => error = 'Microphone/speech अनुमति दें या नीचे लिखें।');
        return;
      }
      final locales = await speech.locales();
      final hindi = locales
          .where((l) => l.localeId.startsWith('hi'))
          .firstOrNull;
      await speech.listen(
        listenOptions: SpeechListenOptions(localeId: hindi?.localeId),
        onResult: (result) {
          if (mounted) setState(() => text.text = result.recognizedWords);
        },
      );
      if (mounted) {
        setState(() {
          listening = true;
          error = null;
        });
      }
    } on Object {
      if (mounted) {
        setState(() {
          listening = false;
          error = 'इस device पर speech उपलब्ध नहीं। नीचे रकम लिखकर जोड़ें।';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) => SafeArea(
    child: Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        20,
        20,
        MediaQuery.viewInsetsOf(context).bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'बोलकर खाता लिखें',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              'उदाहरण: “2 बोरी खाद 2700 रुपये” या “गेहूं बेचा 26000 रुपये”। पहले transcript और रकम जांचें, फिर सहेजें।',
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: listen,
              icon: Icon(listening ? Icons.stop : Icons.mic),
              label: Text(listening ? 'सुनना रोकें' : 'बोलना शुरू करें'),
            ),
            TextField(
              controller: text,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'बोला हुआ विवरण / यहां सुधारें',
              ),
            ),
            if (error != null)
              Text(error!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () async {
                try {
                  await speech.stop();
                  FarmerProfileService().parseVoiceInput(text.text.trim());
                  await FarmerProfileService().flush();
                  if (context.mounted) Navigator.pop(context);
                } on Object catch (e) {
                  if (mounted) setState(() => error = e.toString());
                }
              },
              child: const Text('जांचकर खाते में सहेजें'),
            ),
          ],
        ),
      ),
    ),
  );
}
