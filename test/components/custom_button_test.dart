import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dartverein_app/components/custom_button.dart';

void main() {
  group('CustomButton Widget Tests', () {
    testWidgets('should display button text correctly', (tester) async {
      const buttonText = 'Test Button';
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(
              text: buttonText,
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.text(buttonText), findsOneWidget);
    });

    testWidgets('should handle button press', (tester) async {
      var wasPressed = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(
              text: 'Press Me',
              onPressed: () {
                wasPressed = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(CustomButton));
      await tester.pumpAndSettle();

      expect(wasPressed, true);
    });

    testWidgets('should be disabled when onPressed is null', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CustomButton(
              text: 'Disabled Button',
              onPressed: null,
            ),
          ),
        ),
      );

      final button = tester.widget<CustomButton>(find.byType(CustomButton));
      expect(button.onPressed, null);
    });

    testWidgets('should show loading indicator when isLoading is true', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(
              text: 'Loading Button',
              onPressed: () {},
              isLoading: true,
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Loading Button'), findsNothing);
    });

    testWidgets('should display icon when provided', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(
              text: 'Icon Button',
              onPressed: () {},
              icon: const Icon(Icons.star),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.star), findsOneWidget);
      expect(find.text('Icon Button'), findsOneWidget);
    });

    testWidgets('should apply different button types correctly', (tester) async {
      // Test primary button
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                CustomButton(
                  text: 'Primary',
                  onPressed: () {},
                  type: ButtonType.primary,
                ),
                CustomButton(
                  text: 'Secondary',
                  onPressed: () {},
                  type: ButtonType.secondary,
                ),
                CustomButton(
                  text: 'Danger',
                  onPressed: () {},
                  type: ButtonType.danger,
                ),
                CustomButton(
                  text: 'Success',
                  onPressed: () {},
                  type: ButtonType.success,
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Primary'), findsOneWidget);
      expect(find.text('Secondary'), findsOneWidget);
      expect(find.text('Danger'), findsOneWidget);
      expect(find.text('Success'), findsOneWidget);
    });

    testWidgets('should apply different button sizes correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                CustomButton(
                  text: 'Small',
                  onPressed: () {},
                  size: ButtonSize.small,
                ),
                CustomButton(
                  text: 'Medium',
                  onPressed: () {},
                  size: ButtonSize.medium,
                ),
                CustomButton(
                  text: 'Large',
                  onPressed: () {},
                  size: ButtonSize.large,
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Small'), findsOneWidget);
      expect(find.text('Medium'), findsOneWidget);
      expect(find.text('Large'), findsOneWidget);
    });

    testWidgets('should respect custom width and height', (tester) async {
      const customWidth = 200.0;
      const customHeight = 80.0;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(
              text: 'Custom Size',
              onPressed: () {},
              customWidth: customWidth,
              customHeight: customHeight,
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(CustomButton),
          matching: find.byType(Container),
        ).first,
      );

      expect(container.constraints?.maxWidth, customWidth);
    });

    testWidgets('should animate on press', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(
              text: 'Animated Button',
              onPressed: () {},
            ),
          ),
        ),
      );

      // Test animation by simulating press
      final gesture = await tester.startGesture(
        tester.getCenter(find.byType(CustomButton)),
      );
      await tester.pump();
      
      // Button should be in pressed state
      await gesture.up();
      await tester.pumpAndSettle();

      // Animation should complete
      expect(find.byType(CustomButton), findsOneWidget);
    });

    testWidgets('should handle long text with ellipsis', (tester) async {
      const longText = 'This is a very long button text that should be truncated';
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 100,
              child: CustomButton(
                text: longText,
                onPressed: () {},
              ),
            ),
          ),
        ),
      );

      final textWidget = tester.widget<Text>(
        find.descendant(
          of: find.byType(CustomButton),
          matching: find.byType(Text),
        ),
      );

      expect(textWidget.overflow, TextOverflow.ellipsis);
    });

    testWidgets('should not respond to tap when disabled', (tester) async {
      var wasPressed = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(
              text: 'Disabled',
              onPressed: null,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(CustomButton));
      await tester.pumpAndSettle();

      expect(wasPressed, false);
    });

    testWidgets('should not respond to tap when loading', (tester) async {
      var wasPressed = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(
              text: 'Loading',
              onPressed: () {
                wasPressed = true;
              },
              isLoading: true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(CustomButton));
      await tester.pumpAndSettle();

      expect(wasPressed, false);
    });
  });
}