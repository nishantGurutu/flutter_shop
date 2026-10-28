import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shop/services/farmer_profile_service.dart';
import 'daily_store.dart';
import 'farmer_api.dart';

class DailyScreen extends StatefulWidget {
  final int initialTab;
  const DailyScreen({super.key, this.initialTab = 0});
  @override
  State<DailyScreen> createState() => _DailyScreenState();
}

class _DailyScreenState extends State<DailyScreen> {
  final store = DailyStore.instance;
  final symptoms = TextEditingController();
  final picker = ImagePicker();
  XFile? photo;
  Uint8List? preview;
  String crop =
      FarmerProfileService().selectedCrops.firstOrNull ?? 'गेहूं (Wheat)';
  String? error;
  Map<String, dynamic>? diagnosis;
  bool busy = false;
  bool consent = false;
  String listingFilter = 'सभी';
  List<Map<String, dynamic>> liveShops = [];
  bool loadingShops = false;
  String? shopsError;
  @override
  void initState() {
    super.initState();
    if (FarmerApi.configured) loadShops();
  }

  Future<void> loadShops() async {
    setState(() {
      loadingShops = true;
      shopsError = null;
    });
    try {
      final result = await FarmerApi.get(
        '/input-listings?district=${Uri.encodeQueryComponent(FarmerProfileService().district)}',
      );
      final items = (result['items'] as List)
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
      if (mounted) setState(() => liveShops = items);
    } on Object {
      if (mounted)
        setState(
          () => shopsError = 'दुकानों की सूची नहीं मिली। दोबारा कोशिश करें।',
        );
    } finally {
      if (mounted) setState(() => loadingShops = false);
    }
  }

  @override
  void dispose() {
    symptoms.dispose();
    super.dispose();
  }

  Future<void> run(Future<void> Function() action) async {
    try {
      await action();
    } on Object catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().replaceFirst('Bad state: ', ''))),
        );
      }
    }
  }

  String date(DateTime d) => DateFormat('dd MMM yyyy, h:mm a').format(d);
  @override
  Widget build(BuildContext context) => DefaultTabController(
    length: 4,
    initialIndex: widget.initialTab,
    child: Scaffold(
      backgroundColor: const Color(0xFFF5F7EF),
      appBar: AppBar(
        title: const Text('मेरी खेती • Kisan Daily'),
        bottom: const TabBar(
          isScrollable: true,
          tabs: [
            Tab(text: 'फसल कैलेंडर'),
            Tab(text: 'फसल डॉक्टर'),
            Tab(text: 'सरकारी योजनाएं'),
            Tab(text: 'स्थानीय दुकानें'),
          ],
        ),
      ),
      body: ListenableBuilder(
        listenable: store,
        builder: (context, _) =>
            TabBarView(children: [calendar(), doctor(), schemes(), listings()]),
      ),
    ),
  );
  Widget panel(Widget child) => Card(
    margin: const EdgeInsets.only(bottom: 14),
    elevation: 0,
    child: Padding(padding: const EdgeInsets.all(16), child: child),
  );
  Widget note(String text, {IconData icon = Icons.info_outline}) => panel(
    Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: const Color(0xFF39734C)),
        const SizedBox(width: 12),
        Expanded(child: Text(text)),
      ],
    ),
  );
  Widget page(List<Widget> children) =>
      ListView(padding: const EdgeInsets.all(16), children: children);
  Widget heading(String title, String subtitle) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        Text(subtitle),
      ],
    ),
  );

  Widget calendar() {
    final pending = store.tasks.where((t) => !t.done).length;
    return page([
      heading(
        'हर दिन, सही काम 🌱',
        '$pending काम बाकी • ${FarmerProfileService().district}',
      ),
      panel(
        Column(
          children: [
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('सुबह का दैनिक रिमाइंडर'),
              subtitle: Text(
                '${store.morningHour}:00 बजे • मौसम, मंडी और खाता देखें',
              ),
              value: store.morning,
              onChanged: (v) =>
                  run(() => store.setMorning(v, store.morningHour)),
            ),
            Row(
              children: [
                const Text('सुबह का समय'),
                const Spacer(),
                DropdownButton<int>(
                  value: store.morningHour,
                  items: [5, 6, 7, 8, 9]
                      .map(
                        (h) =>
                            DropdownMenuItem(value: h, child: Text('$h:00 AM')),
                      )
                      .toList(),
                  onChanged: (h) {
                    if (h != null) {
                      run(() => store.setMorning(store.morning, h));
                    }
                  },
                ),
              ],
            ),
            const Text(
              'Phone अनुमति जरूरी है। Android battery settings के कारण समय थोड़ा बदल सकता है।',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
      FilledButton.icon(
        onPressed: () => addTask(),
        icon: const Icon(Icons.add),
        label: const Text('नया काम / बुवाई जोड़ें'),
      ),
      const SizedBox(height: 12),
      note(
        'अपनी बुवाई की तारीख से काम बनाएं। ये सामान्य planning reminders हैं; खेत, मौसम और स्थानीय कृषि सलाह के अनुसार तारीख बदलें।',
      ),
      if (store.tasks.isEmpty)
        note(
          'अभी कोई काम नहीं है। नया काम जोड़ें या बुवाई से अपना कैलेंडर बनाएं।',
          icon: Icons.event_available,
        ),
      ...store.tasks.map(
        (t) => panel(
          Row(
            children: [
              Checkbox(
                value: t.done,
                onChanged: (_) => run(() => store.toggle(t)),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        decoration: t.done ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    Text(
                      '${t.crop}\n${date(t.date)}${t.reminder ? ' • 🔔' : ''}',
                      style: const TextStyle(fontSize: 12),
                    ),
                    if (!t.done && t.date.isBefore(DateTime.now()))
                      const Text(
                        'समय बीत गया',
                        style: TextStyle(color: Colors.orange),
                      ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'हटाएं',
                icon: const Icon(Icons.delete_outline),
                onPressed: () => run(() => store.remove(t)),
              ),
            ],
          ),
        ),
      ),
    ]);
  }

  Future<void> addTask({String? title, String? scheme}) async {
    final name = TextEditingController(text: title);
    var selectedCrop = crop;
    var day = DateTime.now().add(const Duration(days: 1));
    var time = const TimeOfDay(hour: 8, minute: 0);
    var remind = false;
    var template = false;
    var saving = false;
    String? message;
    if (!mounted) return;
    final dialogRoute = DialogRoute<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (c, update) => AlertDialog(
          title: Text(
            scheme == null ? 'खेती का काम जोड़ें' : 'योजना का रिमाइंडर',
          ),
          content: SizedBox(
            width: 420,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: name,
                    decoration: const InputDecoration(labelText: 'काम का नाम'),
                  ),
                  if (scheme == null)
                    DropdownButtonFormField<String>(
                      initialValue: selectedCrop,
                      isExpanded: true,
                      items: FarmerProfileService().selectedCrops
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                      onChanged: (v) {
                        if (v != null) update(() => selectedCrop = v);
                      },
                    ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(DateFormat('dd MMM yyyy').format(day)),
                    trailing: const Icon(Icons.calendar_month),
                    onTap: () async {
                      final d = await showDatePicker(
                        context: c,
                        initialDate: day,
                        firstDate: DateTime.now().subtract(
                          const Duration(days: 365),
                        ),
                        lastDate: DateTime.now().add(const Duration(days: 730)),
                      );
                      if (d != null) update(() => day = d);
                    },
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(time.format(c)),
                    trailing: const Icon(Icons.schedule),
                    onTap: () async {
                      final t = await showTimePicker(
                        context: c,
                        initialTime: time,
                      );
                      if (t != null) update(() => time = t);
                    },
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    value: remind,
                    title: const Text('फोन पर याद दिलाएं'),
                    onChanged: (v) => update(() => remind = v),
                  ),
                  if (scheme == null)
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      value: template,
                      title: const Text(
                        'यह बुवाई है: 7, 21 और 45 दिन पर निरीक्षण के काम भी बनाएं',
                      ),
                      onChanged: (v) => update(() => template = v ?? false),
                    ),
                  if (scheme != null)
                    const Text(
                      'यह आपकी चुनी तारीख है, सरकारी last date नहीं। आधिकारिक पोर्टल से deadline जांचें।',
                    ),
                  if (message != null)
                    Text(message!, style: const TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: saving ? null : () => Navigator.pop(c),
              child: const Text('रद्द करें'),
            ),
            FilledButton(
              onPressed: saving
                  ? null
                  : () async {
                      final when = DateTime(
                        day.year,
                        day.month,
                        day.day,
                        time.hour,
                        time.minute,
                      );
                      if (name.text.trim().isEmpty ||
                          (remind && !when.isAfter(DateTime.now()))) {
                        update(
                          () => message =
                              'काम का नाम और reminder के लिए भविष्य की तारीख चुनें।',
                        );
                        return;
                      }
                      update(() => saving = true);
                      try {
                        await store.add(
                          FarmTask(
                            id: store.newId(),
                            title: name.text.trim(),
                            crop: scheme ?? selectedCrop,
                            date: when,
                            reminder: remind,
                          ),
                        );
                        if (template) {
                          for (final days in [7, 21, 45]) {
                            final next = when.add(Duration(days: days));
                            await store.add(
                              FarmTask(
                                id: store.newId(),
                                title:
                                    'बुवाई के $days दिन: खेत और फसल का निरीक्षण',
                                crop: selectedCrop,
                                date: next,
                                reminder:
                                    remind && next.isAfter(DateTime.now()),
                              ),
                            );
                          }
                        }
                        if (c.mounted) Navigator.pop(c);
                      } on Object catch (e) {
                        update(() {
                          saving = false;
                          message = e.toString();
                        });
                      }
                    },
              child: Text(saving ? 'सहेज रहे हैं…' : 'सहेजें'),
            ),
          ],
        ),
      ),
    );
    if (mounted) await Navigator.of(context).push(dialogRoute);
    await dialogRoute.completed;
    name.dispose();
  }

  Future<void> pick(ImageSource source) async {
    await run(() async {
      final chosen = await picker.pickImage(
        source: source,
        maxWidth: 1600,
        imageQuality: 85,
      );
      if (chosen == null) return;
      final bytes = await chosen.readAsBytes();
      if (bytes.length > 10 * 1024 * 1024) {
        throw StateError('10 MB से छोटी photo चुनें।');
      }
      if (mounted) {
        setState(() {
          photo = chosen;
          preview = bytes;
          diagnosis = null;
          error = null;
        });
      }
    });
  }

  Widget doctor() => page([
    heading('पत्ते की फोटो से मदद 🔬', 'साफ फोटो, सही फसल और लक्षण जोड़ें।'),
    note(
      'AI की पहचान अंतिम diagnosis नहीं है। दवा या मात्रा तय करने से पहले कृषि विशेषज्ञ से सलाह लें। गंभीर बीमारी में तुरंत स्थानीय कृषि केंद्र से मिलें।',
    ),
    if (!FarmerApi.configured)
      note(
        'Demo mode: फोटो चुनकर उदाहरण परिणाम देखें। आपकी photo AI सेवा को नहीं भेजी जाएगी और उसकी बीमारी की पहचान नहीं होगी।',
      ),
    panel(
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (preview != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.memory(preview!, height: 200, fit: BoxFit.contain),
            )
          else
            Container(
              height: 140,
              decoration: BoxDecoration(
                color: const Color(0xFFEAF1E3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.add_photo_alternate_outlined,
                size: 56,
                color: Color(0xFF39734C),
              ),
            ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: [
              OutlinedButton.icon(
                onPressed: busy ? null : () => pick(ImageSource.camera),
                icon: const Icon(Icons.camera_alt_outlined),
                label: const Text('कैमरा'),
              ),
              OutlinedButton.icon(
                onPressed: busy ? null : () => pick(ImageSource.gallery),
                icon: const Icon(Icons.photo_library_outlined),
                label: const Text('गैलरी'),
              ),
            ],
          ),
          DropdownButtonFormField<String>(
            initialValue: crop,
            isExpanded: true,
            decoration: const InputDecoration(labelText: 'फसल'),
            items: FarmerProfileService().selectedCrops
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: busy
                ? null
                : (v) {
                    if (v != null) setState(() => crop = v);
                  },
          ),
          TextField(
            controller: symptoms,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'लक्षण (जैसे पत्ते पर पीले धब्बे)',
            ),
          ),
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            value: consent,
            onChanged: busy
                ? null
                : (v) => setState(() => consent = v ?? false),
            title: Text(
              FarmerApi.configured
                  ? 'मैं इस photo और लक्षणों को पहचान के लिए AI सेवा पर भेजने की सहमति देता/देती हूं।'
                  : 'मैं समझता/समझती हूं कि यह केवल demo है और photo की AI पहचान नहीं होगी।',
              style: const TextStyle(fontSize: 13),
            ),
          ),
          Text(
            'आज ${store.doctorCallsToday}/3 ${FarmerApi.configured ? 'AI जांच' : 'Demo previews'}',
            style: const TextStyle(fontSize: 12),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed:
                busy || photo == null || !consent || store.doctorCallsToday >= 3
                ? null
                : diagnose,
            icon: busy
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.biotech),
            label: Text(
              busy
                  ? 'जांच हो रही है…'
                  : (FarmerApi.configured
                        ? 'फोटो की जांच करें'
                        : 'डेमो परिणाम देखें'),
            ),
          ),
          if (error != null)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(error!, style: const TextStyle(color: Colors.red)),
            ),
        ],
      ),
    ),
    if (diagnosis != null)
      panel(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              FarmerApi.configured
                  ? 'AI जांच का परिणाम'
                  : 'उदाहरण परिणाम • Demo',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text(diagnosis!['summary'].toString()),
            if (diagnosis!['advice'] != null)
              Text(diagnosis!['advice'].toString()),
          ],
        ),
      ),
    const Text('पिछली जांच', style: TextStyle(fontWeight: FontWeight.bold)),
    ...store.history
        .where((e) => e['type'] == 'doctor')
        .map(
          (e) => panel(
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(e['summary'] ?? 'जांच'),
              subtitle: Text(
                '${e['crop']} • ${date(DateTime.parse(e['date']))}',
              ),
            ),
          ),
        ),
  ]);
  Future<void> diagnose() async {
    setState(() {
      busy = true;
      error = null;
    });
    try {
      final result = FarmerApi.configured
          ? await FarmerApi.diagnose(photo!, crop, symptoms.text.trim())
          : <String, dynamic>{
              'summary':
                  'केवल उदाहरण: पत्तियों के धब्बे या रंग बदलने की स्थिति में खेत का निरीक्षण करें। यह आपकी photo का विश्लेषण या बीमारी की पहचान नहीं है।',
              'advice':
                  'फसल, बुवाई की तारीख और साफ फोटो के साथ स्थानीय कृषि विशेषज्ञ से सलाह लें। इस demo के आधार पर दवा न चुनें।',
            };
      if (result['summary'] is! String ||
          (result['summary'] as String).trim().isEmpty) {
        throw StateError('जांच का सही परिणाम नहीं मिला। फिर कोशिश करें।');
      }
      await store.record({
        'type': 'doctor',
        'demo': !FarmerApi.configured,
        'crop': crop,
        'summary': result['summary'],
        'advice': result['advice'],
      });
      if (mounted) setState(() => diagnosis = result);
    } on Object catch (e) {
      if (mounted) setState(() => error = e.toString());
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  static const schemeData = [
    {
      'name': 'PM-KISAN',
      'body':
          'किसान सम्मान निधि • पात्रता, eKYC और लाभार्थी स्थिति आधिकारिक पोर्टल पर जांचें।',
      'docs': 'आधार, बैंक खाता और भूमि संबंधी दस्तावेज',
      'url': 'https://pmkisan.gov.in/',
    },
    {
      'name': 'फसल बीमा (PMFBY)',
      'body':
          'आपके राज्य, मौसम और अधिसूचित फसल के अनुसार बीमा उपलब्धता जांचें।',
      'docs': 'पहचान, बैंक विवरण, भूमि/बुवाई का प्रमाण',
      'url': 'https://pmfby.gov.in/',
    },
    {
      'name': 'कृषि सहायता और सब्सिडी',
      'body':
          'बीज, कृषि उपकरण और अन्य सहायता के लिए अपने राज्य और जिला कृषि विभाग से जानकारी लें।',
      'docs': 'योजना के अनुसार दस्तावेज अलग होंगे',
      'url': 'https://www.myscheme.gov.in/',
    },
  ];
  Future<void> openUrl(String url) => run(() async {
    if (!await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    )) {
      throw StateError('लिंक नहीं खुला। बाद में कोशिश करें।');
    }
  });
  Widget schemes() => page([
    heading(
      'आपके लिए सरकारी योजनाएं 📋',
      'जानकारी देखें, फिर अपनी follow-up तारीख चुनें।',
    ),
    note(
      'पात्रता, आवेदन और last date केवल सरकारी पोर्टल से पुष्टि करें। यहां कोई वर्तमान deadline या मंजूरी का दावा नहीं है।',
    ),
    ...schemeData.map(
      (s) => panel(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              s['name']!,
              style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(s['body']!),
            const SizedBox(height: 8),
            Text('तैयारी: ${s['docs']}'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                FilledButton.tonalIcon(
                  onPressed: () => openUrl(s['url']!),
                  icon: const Icon(Icons.open_in_new),
                  label: const Text('सरकारी पोर्टल'),
                ),
                OutlinedButton.icon(
                  onPressed: () => addTask(
                    title: '${s['name']} की स्थिति / आवेदन जांचें',
                    scheme: s['name'],
                  ),
                  icon: const Icon(Icons.add_alert_outlined),
                  label: const Text('याद दिलाएं'),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  ]);
  static const shops = [
    {
      'id': 'demo_seed',
      'name': 'उदाहरण बीज केंद्र',
      'category': 'बीज',
      'item': 'गेहूं और चना के प्रमाणित बीज',
      'sponsored': true,
    },
    {
      'id': 'demo_fertilizer',
      'name': 'उदाहरण कृषि सेवा केंद्र',
      'category': 'खाद',
      'item': 'खाद और उर्वरक की जानकारी',
      'sponsored': false,
    },
    {
      'id': 'demo_protection',
      'name': 'उदाहरण फसल सुरक्षा केंद्र',
      'category': 'दवाई',
      'item': 'फसल सुरक्षा उत्पादों की जानकारी',
      'sponsored': false,
    },
  ];
  Widget listings() => page([
    heading(
      'गांव के पास, खेती का सामान 🏪',
      '${FarmerProfileService().district} • बीज, खाद और फसल सुरक्षा',
    ),
    note(
      FarmerApi.configured
          ? 'Sponsored label वाली listing paid placement है। कीमत और उपलब्धता दुकान से पुष्टि करें। Enquiry केवल आपकी सहमति पर भेजी जाएगी।'
          : 'ये demo दुकानें हैं। वास्तविक stock या paid sponsorship नहीं। Enquiry device पर draft में save होगी।',
    ),
    if (loadingShops) const LinearProgressIndicator(),
    if (shopsError != null)
      Text(shopsError!, style: const TextStyle(color: Colors.red)),
    if (FarmerApi.configured)
      TextButton.icon(
        onPressed: loadingShops ? null : loadShops,
        icon: const Icon(Icons.refresh),
        label: const Text('दुकानें Refresh करें'),
      ),
    if (FarmerApi.configured && !loadingShops && liveShops.isEmpty)
      note('अभी आपके जिले में कोई listing नहीं मिली।'),
    Wrap(
      spacing: 8,
      children: ['सभी', 'बीज', 'खाद', 'दवाई']
          .map(
            (v) => ChoiceChip(
              label: Text(v),
              selected: listingFilter == v,
              onSelected: (_) => setState(() => listingFilter = v),
            ),
          )
          .toList(),
    ),
    const SizedBox(height: 16),
    ...(FarmerApi.configured ? liveShops : shops)
        .where((s) => listingFilter == 'सभी' || s['category'] == listingFilter)
        .map(
          (s) => panel(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (s['sponsored'] == true)
                  Chip(
                    avatar: const Icon(Icons.campaign, size: 16),
                    label: Text(
                      FarmerApi.configured ? 'Sponsored' : 'Sponsored • Demo',
                    ),
                  ),
                Text(
                  s['name'] as String,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(s['item'] as String),
                const Text('कीमत और उपलब्धता की पुष्टि जरूरी है'),
                const SizedBox(height: 12),
                FilledButton.tonalIcon(
                  onPressed: () => inquiry(s),
                  icon: const Icon(Icons.edit_note),
                  label: Text(
                    FarmerApi.configured
                        ? 'दुकान से पूछें'
                        : 'Enquiry draft बनाएं',
                  ),
                ),
              ],
            ),
          ),
        ),
    const Text('मेरी enquiries', style: TextStyle(fontWeight: FontWeight.bold)),
    const SizedBox(height: 8),
    ...store.history
        .where((e) => e['type'] == 'lead')
        .map(
          (e) => panel(
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(e['shop']),
              subtitle: Text(
                '${e['message']}\n${e['status'] == 'sent' ? 'भेजी गई' : 'Draft'} • ${date(DateTime.parse(e['date']))}',
              ),
            ),
          ),
        ),
  ]);
  Future<void> inquiry(Map<String, dynamic> shop) async {
    final message = TextEditingController();
    var approved = false;
    var sending = false;
    String? validation;
    final dialogRoute = DialogRoute<void>(
      context: context,
      builder: (c) => StatefulBuilder(
        builder: (c, update) => AlertDialog(
          title: Text(shop['name'] as String),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: message,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'कौन सा सामान, कितनी मात्रा?',
                ),
              ),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                value: approved,
                onChanged: (v) => update(() => approved = v ?? false),
                title: Text(
                  FarmerApi.configured
                      ? 'इस enquiry और मेरी संपर्क जानकारी को इस दुकान से साझा करने की सहमति देता/देती हूं।'
                      : 'इस enquiry को मेरे device पर save करें। कोई जानकारी दुकान को अभी नहीं भेजी जाएगी।',
                ),
              ),
              if (validation != null)
                Text(validation!, style: const TextStyle(color: Colors.red)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: sending ? null : () => Navigator.pop(c),
              child: const Text('रद्द करें'),
            ),
            FilledButton(
              onPressed: sending
                  ? null
                  : () async {
                      if (message.text.trim().isEmpty || !approved) {
                        update(
                          () => validation =
                              'सामान लिखें और save करने की सहमति दें।',
                        );
                        return;
                      }
                      update(() => sending = true);
                      if (FarmerApi.configured) {
                        try {
                          await FarmerApi.post('/input-leads', {
                            'listingId': shop['id'],
                            'message': message.text.trim(),
                            'consent': true,
                          });
                        } on Object catch (e) {
                          if (c.mounted)
                            update(() {
                              validation = e.toString();
                              sending = false;
                            });
                          return;
                        }
                      }
                      await store.record({
                        'type': 'lead',
                        'shop': shop['name'],
                        'shopId': shop['id'],
                        'message': message.text.trim(),
                        'status': FarmerApi.configured ? 'sent' : 'draft',
                      });
                      if (c.mounted) Navigator.pop(c);
                    },
              child: Text(
                FarmerApi.configured ? 'Enquiry भेजें' : 'Draft सहेजें',
              ),
            ),
          ],
        ),
      ),
    );
    if (mounted) await Navigator.of(context).push(dialogRoute);
    await dialogRoute.completed;
    message.dispose();
  }
}
