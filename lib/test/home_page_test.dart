import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:trackmate/pages/home.dart';
import 'package:provider/provider.dart';
import 'package:trackmate/db/habit_database.dart';

void main() {
  testWidgets('should display create new habit dialog', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => HabitDatabase(),
        child: MaterialApp(
          home: HomePage(),
        ),
      ),
    );

    // Trigger floating action button tap
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify if the dialog is displayed
    expect(find.byType(AlertDialog), findsOneWidget);
  });
}
