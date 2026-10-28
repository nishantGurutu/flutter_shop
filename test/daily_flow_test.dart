import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop/features/daily/daily_screen.dart';
import 'package:shop/features/daily/daily_store.dart';
import 'package:shop/model/khata_model.dart';
import 'package:shop/model/mandi_model.dart';
import 'package:shop/services/farmer_profile_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() async {
    SharedPreferences.setMockInitialValues({
      'daily_flow_v1': '{"tasks":[],"history":[],"morning":false}',
    });
    await DailyStore.instance.init();
    await FarmerProfileService().init();
  });
  test(
    'voice amount uses currency amount instead of quantity and understands Hindi sale',
    () async {
      final service = FarmerProfileService();
      final expense = service.parseVoiceInput('2 बोरी खाद 2700 रुपये');
      expect(expense.amount, 2700);
      expect(expense.type, KhataType.kharcha);
      final sale = service.parseVoiceInput('10 क्विंटल गेहूं बेचा 26000 रुपये');
      expect(sale.amount, 26000);
      expect(sale.type, KhataType.kamai);
      expect(service.parseVoiceInput('बीज १२५० रुपये').amount, 1250);
      expect(
        service.parseVoiceInput('गेहूं बीज 1600 रुपये').type,
        KhataType.kharcha,
      );
      expect(() => service.parseVoiceInput('खाद खरीदी'), throwsFormatException);
      expect(
        () => service.parseVoiceInput('खाद 0 रुपये'),
        throwsFormatException,
      );
      await service.flush();
    },
  );
  test(
    'profile, ledger and rate alerts survive restoring preferences',
    () async {
      final service = FarmerProfileService();
      service.updateProfile(
        name: 'Test Farmer',
        village: 'Test Village',
        selectedCrops: ['गेहूं (Wheat)'],
      );
      final entry = service.parseVoiceInput('बीज 750 रुपये');
      service.addRateAlert(
        const RateAlertModel(
          id: 'test_alert',
          cropName: 'Wheat',
          cropHindi: 'गेहूं',
          mandiName: 'नीमच मंडी',
          targetPrice: 2800,
          createdAt: 'test',
        ),
      );
      await service.flush();
      await service.init();
      expect(service.name, 'Test Farmer');
      expect(
        service.khataEntries.where((e) => e.id == entry.id).single.amount,
        750,
      );
      expect(service.rateAlerts.single.targetPrice, 2800);
      service.deleteKhataEntry(entry.id);
      service.removeRateAlert('test_alert');
      await service.flush();
      await service.init();
      expect(service.khataEntries.where((e) => e.id == entry.id), isEmpty);
      expect(service.rateAlerts, isEmpty);
    },
  );
  test('calendar tasks and completion persist, deletion persists', () async {
    final store = DailyStore.instance;
    final task = FarmTask(
      id: 12,
      title: 'Inspect crop',
      crop: 'Wheat',
      date: DateTime(2027, 1, 1),
    );
    await store.add(task);
    await store.toggle(task);
    await store.init();
    expect(store.tasks.single.done, isTrue);
    await store.remove(store.tasks.single);
    await store.init();
    expect(store.tasks, isEmpty);
  });
  testWidgets('calendar add task flow works on narrow phone screen', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const MaterialApp(home: DailyScreen()));
    await tester.pumpAndSettle();
    await tester.tap(find.text('नया काम / बुवाई जोड़ें'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, 'खेत का निरीक्षण');
    await tester.runAsync(() async {
      await tester.tap(find.text('सहेजें'));
      await Future<void>.delayed(const Duration(milliseconds: 30));
    });
    await tester.pumpAndSettle();
    expect(find.text('खेत का निरीक्षण'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  testWidgets('doctor cannot submit without a photo and consent', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: DailyScreen(initialTab: 1)),
    );
    await tester.pumpAndSettle();
    expect(find.text('डेमो परिणाम देखें'), findsOneWidget);
    final button = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'डेमो परिणाम देखें'),
    );
    expect(button.onPressed, isNull);
    expect(tester.takeException(), isNull);
  });
  testWidgets('shop enquiry requires consent and saves only a demo draft', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: DailyScreen(initialTab: 3)),
    );
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Enquiry draft बनाएं').first);
    await tester.tap(find.text('Enquiry draft बनाएं').first);
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, 'गेहूं बीज 40 किलो');
    await tester.tap(find.text('Draft सहेजें'));
    await tester.pumpAndSettle();
    expect(DailyStore.instance.history, isEmpty);
    await tester.tap(find.byType(Checkbox));
    await tester.runAsync(() async {
      await tester.tap(find.text('Draft सहेजें'));
      await Future<void>.delayed(const Duration(milliseconds: 30));
    });
    await tester.pumpAndSettle();
    expect(DailyStore.instance.history.single['status'], 'draft');
    expect(tester.takeException(), isNull);
  });
  testWidgets('scheme follow-up enters the real calendar', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: DailyScreen(initialTab: 2)),
    );
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('याद दिलाएं').first);
    await tester.tap(find.text('याद दिलाएं').first);
    await tester.pumpAndSettle();
    await tester.runAsync(() async {
      await tester.tap(find.text('सहेजें'));
      await Future<void>.delayed(const Duration(milliseconds: 30));
    });
    await tester.pumpAndSettle();
    expect(DailyStore.instance.tasks.single.crop, 'PM-KISAN');
    expect(tester.takeException(), isNull);
  });
}
