import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dartverein_app/utils/responsive_utils.dart';

void main() {
  group('ResponsiveUtils Tests', () {
    testWidgets('should correctly identify mobile devices', (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 800));
      
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              expect(ResponsiveUtils.isMobile(context), true);
              expect(ResponsiveUtils.isTablet(context), false);
              expect(ResponsiveUtils.isDesktop(context), false);
              return Container();
            },
          ),
        ),
      );
    });

    testWidgets('should correctly identify tablet devices', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1024));
      
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              expect(ResponsiveUtils.isMobile(context), false);
              expect(ResponsiveUtils.isTablet(context), true);
              expect(ResponsiveUtils.isDesktop(context), false);
              return Container();
            },
          ),
        ),
      );
    });

    testWidgets('should correctly identify desktop devices', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 800));
      
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              expect(ResponsiveUtils.isMobile(context), false);
              expect(ResponsiveUtils.isTablet(context), false);
              expect(ResponsiveUtils.isDesktop(context), true);
              return Container();
            },
          ),
        ),
      );
    });

    testWidgets('should return correct screen dimensions', (tester) async {
      const size = Size(800, 600);
      await tester.binding.setSurfaceSize(size);
      
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              expect(ResponsiveUtils.getScreenWidth(context), size.width);
              expect(ResponsiveUtils.getScreenHeight(context), size.height);
              return Container();
            },
          ),
        ),
      );
    });

    testWidgets('should provide different padding for different screen sizes', (tester) async {
      // Test mobile padding
      await tester.binding.setSurfaceSize(const Size(400, 800));
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final mobilePadding = ResponsiveUtils.getPagePadding(context);
              expect(mobilePadding, const EdgeInsets.all(16.0));
              return Container();
            },
          ),
        ),
      );

      // Test tablet padding
      await tester.binding.setSurfaceSize(const Size(800, 1024));
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final tabletPadding = ResponsiveUtils.getPagePadding(context);
              expect(tabletPadding, const EdgeInsets.all(24.0));
              return Container();
            },
          ),
        ),
      );

      // Test desktop padding
      await tester.binding.setSurfaceSize(const Size(1200, 800));
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final desktopPadding = ResponsiveUtils.getPagePadding(context);
              expect(desktopPadding, const EdgeInsets.all(32.0));
              return Container();
            },
          ),
        ),
      );
    });

    testWidgets('should provide responsive font sizes', (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 800)); // Mobile
      
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final smallFont = ResponsiveUtils.getFontSize(context, FontSizeType.small);
              final bodyFont = ResponsiveUtils.getFontSize(context, FontSizeType.body);
              final titleFont = ResponsiveUtils.getFontSize(context, FontSizeType.title);
              final displayFont = ResponsiveUtils.getFontSize(context, FontSizeType.display);
              
              expect(smallFont, 12.0);
              expect(bodyFont, 16.0);
              expect(titleFont, 24.0);
              expect(displayFont, 48.0);
              
              // Test that fonts scale with screen size
              expect(titleFont > bodyFont, true);
              expect(displayFont > titleFont, true);
              
              return Container();
            },
          ),
        ),
      );
    });

    testWidgets('should provide responsive spacing', (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 800)); // Mobile
      
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final xsSpacing = ResponsiveUtils.getSpacing(context, SpacingType.xs);
              final smSpacing = ResponsiveUtils.getSpacing(context, SpacingType.sm);
              final mdSpacing = ResponsiveUtils.getSpacing(context, SpacingType.md);
              final lgSpacing = ResponsiveUtils.getSpacing(context, SpacingType.lg);
              final xlSpacing = ResponsiveUtils.getSpacing(context, SpacingType.xl);
              final xxlSpacing = ResponsiveUtils.getSpacing(context, SpacingType.xxl);
              
              expect(xsSpacing, 4.0);
              expect(smSpacing, 8.0);
              expect(mdSpacing, 16.0);
              expect(lgSpacing, 24.0);
              expect(xlSpacing, 32.0);
              expect(xxlSpacing, 48.0);
              
              // Test spacing hierarchy
              expect(smSpacing > xsSpacing, true);
              expect(mdSpacing > smSpacing, true);
              expect(lgSpacing > mdSpacing, true);
              expect(xlSpacing > lgSpacing, true);
              expect(xxlSpacing > xlSpacing, true);
              
              return Container();
            },
          ),
        ),
      );
    });

    testWidgets('should provide responsive grid columns', (tester) async {
      // Test mobile grid columns
      await tester.binding.setSurfaceSize(const Size(400, 800));
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              expect(ResponsiveUtils.getGridColumns(context), 2);
              return Container();
            },
          ),
        ),
      );

      // Test tablet grid columns
      await tester.binding.setSurfaceSize(const Size(800, 1024));
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              expect(ResponsiveUtils.getGridColumns(context), 3);
              return Container();
            },
          ),
        ),
      );

      // Test desktop grid columns
      await tester.binding.setSurfaceSize(const Size(1200, 800));
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              expect(ResponsiveUtils.getGridColumns(context), 4);
              return Container();
            },
          ),
        ),
      );
    });

    testWidgets('should provide responsive max width', (tester) async {
      // Test mobile max width
      await tester.binding.setSurfaceSize(const Size(400, 800));
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              expect(ResponsiveUtils.getMaxWidth(context), double.infinity);
              return Container();
            },
          ),
        ),
      );

      // Test tablet max width
      await tester.binding.setSurfaceSize(const Size(800, 1024));
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              expect(ResponsiveUtils.getMaxWidth(context), 600);
              return Container();
            },
          ),
        ),
      );

      // Test desktop max width
      await tester.binding.setSurfaceSize(const Size(1200, 800));
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              expect(ResponsiveUtils.getMaxWidth(context), 800);
              return Container();
            },
          ),
        ),
      );
    });
  });
}