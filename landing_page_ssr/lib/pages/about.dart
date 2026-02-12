import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../constants/theme.dart';

@client
class About extends StatelessComponent {
  const About({super.key});

  @override
  Component build(BuildContext context) {
    return div(classes: 'about', [
      section(classes: 'about-hero', [
        h1([Component.text('About Rem')]),
        p([Component.text('The story behind the workspace and its code-born twins.')]),
      ]),

      section(classes: 'about-content', [
        div(classes: 'about-card', [
          h2([Component.text('The Vision')]),
          p([
            Component.text(
              'Rem is a monorepo workspace forged with Melos, designed to unite and orchestrate '
              'multiple Dart/Flutter projects under a single, cohesive structure. '
              'It represents the harmony between frontend and backend development in the Dart ecosystem.',
            ),
          ]),
        ]),

        div(classes: 'about-card', [
          h2([Component.text('The Twins')]),
          p([
            Component.text(
              'Arona and Plana are the twin projects that form the core of the Rem workspace. '
              'Like yin and yang, they complement each other perfectly - '
              'Arona handles the bright, user-facing interactions while Plana manages the shadowed, backend operations.',
            ),
          ]),
        ]),

        div(classes: 'about-card', [
          h2([Component.text('Technology')]),
          div(classes: 'tech-grid', [
            _techItem('Melos', 'Monorepo management'),
            _techItem('Flutter', 'Cross-platform UI'),
            _techItem('Dart Frog', 'Backend API'),
            _techItem('Jaspr', 'Web framework'),
            _techItem('PostgreSQL', 'Database'),
            _techItem('JWT', 'Authentication'),
          ]),
        ]),
      ]),

      section(classes: 'links-section', [
        h2([Component.text('Resources')]),
        div(classes: 'links-grid', [
          a(href: 'https://github.com/invertase/melos', target: Target.blank, classes: 'link-card', [
            h3([Component.text('Melos')]),
            p([Component.text('Monorepo management tool')]),
          ]),
          a(href: 'https://flutter.dev', target: Target.blank, classes: 'link-card', [
            h3([Component.text('Flutter')]),
            p([Component.text('UI toolkit for any platform')]),
          ]),
          a(href: 'https://dartfrog.vgv.dev', target: Target.blank, classes: 'link-card', [
            h3([Component.text('Dart Frog')]),
            p([Component.text('Fast Dart backend framework')]),
          ]),
          a(href: 'https://jaspr.site', target: Target.blank, classes: 'link-card', [
            h3([Component.text('Jaspr')]),
            p([Component.text('Dart web framework')]),
          ]),
        ]),
      ]),
    ]);
  }

  Component _techItem(String name, String desc) {
    return div(classes: 'tech-item', [
      span(classes: 'tech-name', [Component.text(name)]),
      span(classes: 'tech-desc', [Component.text(desc)]),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.about', [
      css('&').styles(
        minHeight: 100.vh,
        color: textPrimary,
        backgroundColor: darkBg,
      ),
    ]),

    css('.about-hero', [
      css('&').styles(
        padding: Padding.symmetric(horizontal: 2.rem, vertical: 4.rem),
        textAlign: TextAlign.center,
      ),
      css('h1').styles(
        margin: Margin.only(bottom: 1.rem),
        fontSize: 2.5.rem,
        fontWeight: FontWeight.w700,
      ),
      css('p').styles(color: textSecondary),
    ]),

    css('.about-content', [
      css('&').styles(
        maxWidth: 800.px,
        padding: Padding.symmetric(horizontal: 2.rem),
        margin: Margin.symmetric(horizontal: Unit.auto),
      ),
    ]),

    css('.about-card', [
      css('&').styles(
        padding: Padding.all(2.rem),
        margin: Margin.only(bottom: 2.rem),
        radius: BorderRadius.circular(12.px),
        backgroundColor: cardBg,
      ),
      css('h2').styles(
        margin: Margin.only(bottom: 1.rem),
        color: primaryColor,
        fontSize: 1.5.rem,
        fontWeight: FontWeight.w600,
      ),
      css('p').styles(
        color: textSecondary,
        lineHeight: 1.7.em,
      ),
    ]),

    css('.tech-grid', [
      css('&').styles(
        display: Display.grid,
        gap: Gap(column: 1.rem, row: 1.rem),
        raw: {'grid-template-columns': 'repeat(auto-fit, minmax(200px, 1fr))'},
      ),
    ]),

    css('.tech-item', [
      css('&').styles(
        padding: Padding.all(1.rem),
        radius: BorderRadius.circular(8.px),
        backgroundColor: darkBg,
      ),
      css('.tech-name').styles(
        display: Display.block,
        margin: Margin.only(bottom: 0.25.rem),
        color: textPrimary,
        fontWeight: FontWeight.w600,
      ),
      css('.tech-desc').styles(
        color: textSecondary,
        fontSize: 0.875.rem,
      ),
    ]),

    css('.links-section', [
      css('&').styles(
        maxWidth: 800.px,
        padding: Padding.all(2.rem),
        margin: Margin.symmetric(horizontal: Unit.auto),
      ),
      css('h2').styles(
        margin: Margin.only(bottom: 1.5.rem),
        textAlign: TextAlign.center,
        fontSize: 1.5.rem,
        fontWeight: FontWeight.w600,
      ),
    ]),

    css('.links-grid', [
      css('&').styles(
        display: Display.grid,
        gap: Gap(column: 1.rem, row: 1.rem),
        raw: {'grid-template-columns': 'repeat(auto-fit, minmax(180px, 1fr))'},
      ),
    ]),

    css('.link-card', [
      css('&').styles(
        display: Display.block,
        padding: Padding.all(1.5.rem),
        radius: BorderRadius.circular(8.px),
        textDecoration: const TextDecoration(line: TextDecorationLine.none),
        backgroundColor: cardBg,
        raw: {'transition': 'transform 0.2s, background-color 0.2s'},
      ),
      css('&:hover').styles(
        backgroundColor: const Color('#334155'),
        raw: {'transform': 'translateY(-2px)'},
      ),
      css('h3').styles(
        margin: Margin.only(bottom: 0.5.rem),
        color: primaryColor,
        fontSize: 1.rem,
        fontWeight: FontWeight.w600,
      ),
      css('p').styles(
        color: textSecondary,
        fontSize: 0.875.rem,
      ),
    ]),
  ];
}
