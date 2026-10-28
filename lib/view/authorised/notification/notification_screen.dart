import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop/features/daily/daily_screen.dart';
import 'package:shop/features/daily/daily_store.dart';
import 'package:shop/services/farmer_profile_service.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('मेरे रिमाइंडर और अलर्ट')),
    body: ListenableBuilder(
      listenable: Listenable.merge([
        DailyStore.instance,
        FarmerProfileService(),
      ]),
      builder: (context, _) {
        final store = DailyStore.instance;
        final tasks = store.tasks.where((t) => !t.done).toList();
        final alerts = FarmerProfileService().rateAlerts
            .where((a) => a.isActive)
            .toList();
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: ListTile(
                leading: const Icon(Icons.wb_twilight),
                title: const Text('सुबह का दैनिक बुलेटिन'),
                subtitle: Text(
                  store.morning
                      ? '${store.morningHour}:00 AM • रिमाइंडर चालू है'
                      : 'रिमाइंडर अभी बंद है',
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const DailyScreen()),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text(
                'आज और आने वाले काम',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            if (tasks.isEmpty)
              const Text(
                'अभी कोई काम नहीं है। कैलेंडर में अपनी बुवाई या योजना का reminder जोड़ें।',
              ),
            ...tasks.map(
              (t) => Card(
                child: ListTile(
                  leading: Icon(
                    t.reminder
                        ? Icons.notifications_active_outlined
                        : Icons.event_note,
                  ),
                  title: Text(t.title),
                  subtitle: Text(
                    '${t.crop} • ${DateFormat('dd MMM, h:mm a').format(t.date)}',
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const DailyScreen()),
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text(
                'सहेजे गए मंडी लक्ष्य',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const Text(
              'लक्ष्य device पर save हैं। Live rate monitoring और background push के लिए backend सेवा जरूरी है। Sample rates से notification नहीं भेजा जाता।',
            ),
            ...alerts.map(
              (a) => Card(
                child: ListTile(
                  leading: const Icon(Icons.price_change_outlined),
                  title: Text(
                    '${a.cropHindi} • ₹${a.targetPrice.toStringAsFixed(0)}',
                  ),
                  subtitle: Text(
                    '${a.mandiName} • ${a.isAbove ? "ऊपर" : "नीचे"} का लक्ष्य',
                  ),
                ),
              ),
            ),
          ],
        );
      },
    ),
  );
}
