import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';

import '../constants/theme.dart';

class Header extends StatelessComponent {
  const Header({super.key});

  @override
  Component build(BuildContext context) {
    var activePath = context.url;

    return header([
      div(classes: 'logo', [
        span(styles: Styles(color: primaryColor), [Component.text('Rem')]),
        Component.text(' Workspace'),
      ]),
      nav([
        for (var route in [
          (label: 'Home', path: '/'),
          (label: 'Blog', path: '/blog'),
          (label: 'About', path: '/about'),
        ])
          div(classes: activePath == route.path ? 'active' : null, [
            Link(to: route.path, child: Component.text(route.label)),
          ]),
      ]),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('header', [
      css('&').styles(
        display: Display.flex,
        padding: Padding.symmetric(horizontal: 2.rem, vertical: 1.rem),
        border: Border.only(
          bottom: BorderSide.solid(color: cardBg, width: 1.px),
        ),
        justifyContent: JustifyContent.spaceBetween,
        alignItems: AlignItems.center,
        backgroundColor: darkBg,
      ),
      css('.logo').styles(
        color: textPrimary,
        fontSize: 1.25.rem,
        fontWeight: FontWeight.w700,
      ),
      css('nav', [
        css('&').styles(
          display: Display.flex,
          gap: Gap(column: 0.5.rem),
        ),
        css('a', [
          css('&').styles(
            display: Display.flex,
            padding: Padding.symmetric(horizontal: 1.rem, vertical: 0.5.rem),
            radius: BorderRadius.circular(6.px),
            alignItems: AlignItems.center,
            color: textSecondary,
            fontWeight: FontWeight.w500,
            textDecoration: const TextDecoration(line: TextDecorationLine.none),
          ),
          css('&:hover').styles(
            color: textPrimary,
            backgroundColor: cardBg,
          ),
        ]),
        css('div.active a').styles(
          color: Colors.white,
          backgroundColor: primaryColor,
        ),
      ]),
    ]),
  ];
}
