import 'package:jaspr/jaspr.dart';

import '../constants/theme.dart';

@client
class Home extends StatelessComponent {
  const Home({super.key});

  @override
  Component build(BuildContext context) {
    return div(classes: 'landing', [
      // Hero Section
      section(classes: 'hero', [
        div(classes: 'hero-content', [
          h1([text('Rem Workspace')]),
          p(classes: 'tagline', [
            text('A monorepo forged with Melos, uniting code-born twins under one structure.')
          ]),
          div(classes: 'badges', [
            _badge('Melos', '#f700ff'),
            _badge('Flutter', '#61DAFB'),
            _badge('Dart', '#2275C7'),
            _badge('Dart Frog', '#01589B'),
          ]),
        ]),
      ]),

      // Projects Section
      section(classes: 'projects', [
        h2([text('The Twins')]),
        p(classes: 'section-desc', [
          text('Under Rem\'s guidance, the twins work in perfect harmony.')
        ]),
        div(classes: 'cards', [
          _projectCard(
            'Arona',
            'Flutter App',
            'The bright, cheerful twin serving as the frontline interface. '
            'Arona shines on the surface, interacting with users and spreading light.',
            aronaColor,
            ['Flutter', 'GetX', 'Dio', 'Secure Storage'],
          ),
          _projectCard(
            'Plana',
            'API Server',
            'The shadowed, silent twin guarding the data flow behind the scenes. '
            'Plana operates in the background, managing unseen logic.',
            planaColor,
            ['Dart Frog', 'PostgreSQL', 'JWT', 'REST API'],
          ),
        ]),
      ]),

      // Arisu Section
      section(classes: 'arisu-section', [
        div(classes: 'arisu-content', [
          h2([text('Arisu')]),
          p(classes: 'arisu-role', [text('Landing Page')]),
          p([
            text('The newest addition to the family. Built with Jaspr, '
                'Arisu serves as the welcoming face of the Rem workspace, '
                'presenting the project to the world with elegance.')
          ]),
          div(classes: 'tech-stack', [
            _techBadge('Jaspr'),
            _techBadge('SSR'),
            _techBadge('Dart Web'),
          ]),
        ]),
      ]),

      // Tech Stack Section
      section(classes: 'stack', [
        h2([text('Tech Stack')]),
        div(classes: 'stack-grid', [
          _stackItem('State Management', 'GetX for lightweight & reactive state'),
          _stackItem('HTTP Client', 'Dio with interceptors'),
          _stackItem('Security', 'JWT + Biometric Auth'),
          _stackItem('Database', 'PostgreSQL'),
          _stackItem('API Framework', 'Dart Frog'),
          _stackItem('Web Framework', 'Jaspr SSR'),
        ]),
      ]),

      // Footer
      footer([
        p([
          text('Built with '),
          span(styles: Styles(color: accentColor), [text('Dart')]),
          text(' by the Rem team'),
        ]),
        p(classes: 'support', [
          a(href: 'https://palestine-liberation.org', target: Target.blank, [
            text('Free Palestine'),
          ]),
        ]),
      ]),
    ]);
  }

  Component _badge(String label, String color) {
    return span(
      classes: 'badge',
      styles: Styles(backgroundColor: Color(color)),
      [text(label)],
    );
  }

  Component _projectCard(String name, String role, String description, Color color, List<String> tech) {
    return div(classes: 'card', [
      div(
        classes: 'card-header',
        styles: Styles(backgroundColor: color),
        [
          h3([text(name)]),
          span(classes: 'role', [text(role)]),
        ],
      ),
      div(classes: 'card-body', [
        p([text(description)]),
        div(classes: 'tech-list', [
          for (var t in tech) span(classes: 'tech', [text(t)]),
        ]),
      ]),
    ]);
  }

  Component _techBadge(String label) {
    return span(classes: 'tech-badge', [text(label)]);
  }

  Component _stackItem(String title, String desc) {
    return div(classes: 'stack-item', [
      h4([text(title)]),
      p([text(desc)]),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    // Landing container
    css('.landing', [
      css('&').styles(
        minHeight: 100.vh,
        backgroundColor: darkBg,
        color: textPrimary,
      ),
    ]),

    // Hero section
    css('.hero', [
      css('&').styles(
        display: Display.flex,
        minHeight: 60.vh,
        padding: Padding.all(2.rem),
        justifyContent: JustifyContent.center,
        alignItems: AlignItems.center,
        textAlign: TextAlign.center,
        raw: {'background': 'linear-gradient(135deg, #0f172a 0%, #1e1b4b 50%, #0f172a 100%)'},
      ),
      css('.hero-content').styles(maxWidth: 800.px),
      css('h1').styles(
        margin: Margin.only(bottom: 1.rem),
        fontSize: 3.5.rem,
        fontWeight: FontWeight.w800,
        raw: {
          'background': 'linear-gradient(90deg, #6366f1, #8b5cf6, #ec4899)',
          '-webkit-background-clip': 'text',
          '-webkit-text-fill-color': 'transparent',
        },
      ),
      css('.tagline').styles(
        margin: Margin.only(bottom: 2.rem),
        fontSize: 1.25.rem,
        color: textSecondary,
      ),
      css('.badges').styles(
        display: Display.flex,
        gap: Gap(column: 0.5.rem),
        justifyContent: JustifyContent.center,
        flexWrap: FlexWrap.wrap,
      ),
      css('.badge').styles(
        padding: Padding.symmetric(horizontal: 0.75.rem, vertical: 0.25.rem),
        radius: BorderRadius.circular(4.px),
        fontSize: 0.875.rem,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    ]),

    // Projects section
    css('.projects', [
      css('&').styles(
        padding: Padding.symmetric(horizontal: 2.rem, vertical: 4.rem),
        textAlign: TextAlign.center,
      ),
      css('h2').styles(
        margin: Margin.only(bottom: 0.5.rem),
        fontSize: 2.5.rem,
        fontWeight: FontWeight.w700,
      ),
      css('.section-desc').styles(
        margin: Margin.only(bottom: 3.rem),
        color: textSecondary,
      ),
      css('.cards').styles(
        display: Display.flex,
        maxWidth: 900.px,
        margin: Margin.symmetric(horizontal: Unit.auto),
        gap: Gap(column: 2.rem),
        justifyContent: JustifyContent.center,
        flexWrap: FlexWrap.wrap,
      ),
    ]),

    // Card styles
    css('.card', [
      css('&').styles(
        width: 400.px,
        radius: BorderRadius.circular(12.px),
        overflow: Overflow.hidden,
        backgroundColor: cardBg,
        raw: {'box-shadow': '0 4px 20px rgba(0, 0, 0, 0.2)'},
      ),
      css('.card-header').styles(
        padding: Padding.all(1.5.rem),
        color: Colors.white,
      ),
      css('.card-header h3').styles(
        margin: Margin.only(bottom: 0.25.rem),
        fontSize: 1.5.rem,
        fontWeight: FontWeight.w700,
      ),
      css('.card-header .role').styles(
        fontSize: 0.875.rem,
        opacity: 0.9,
      ),
      css('.card-body').styles(padding: Padding.all(1.5.rem)),
      css('.card-body p').styles(
        margin: Margin.only(bottom: 1.rem),
        lineHeight: 1.6.em,
        color: textSecondary,
      ),
      css('.tech-list').styles(
        display: Display.flex,
        gap: Gap(column: 0.5.rem),
        flexWrap: FlexWrap.wrap,
      ),
      css('.tech').styles(
        padding: Padding.symmetric(horizontal: 0.5.rem, vertical: 0.25.rem),
        radius: BorderRadius.circular(4.px),
        fontSize: 0.75.rem,
        backgroundColor: const Color('#374151'),
        color: textSecondary,
      ),
    ]),

    // Arisu section
    css('.arisu-section', [
      css('&').styles(
        padding: Padding.symmetric(horizontal: 2.rem, vertical: 4.rem),
        textAlign: TextAlign.center,
        raw: {'background': 'linear-gradient(180deg, transparent 0%, #831843 50%, transparent 100%)'},
      ),
      css('.arisu-content').styles(
        maxWidth: 600.px,
        margin: Margin.symmetric(horizontal: Unit.auto),
      ),
      css('h2').styles(
        fontSize: 2.rem,
        fontWeight: FontWeight.w700,
        color: arisuColor,
      ),
      css('.arisu-role').styles(
        margin: Margin.only(bottom: 1.rem),
        fontSize: 1.rem,
        color: textSecondary,
      ),
      css('p').styles(
        lineHeight: 1.6.em,
        color: textPrimary,
      ),
      css('.tech-stack').styles(
        display: Display.flex,
        margin: Margin.only(top: 1.5.rem),
        gap: Gap(column: 0.75.rem),
        justifyContent: JustifyContent.center,
      ),
      css('.tech-badge').styles(
        padding: Padding.symmetric(horizontal: 1.rem, vertical: 0.5.rem),
        radius: BorderRadius.circular(20.px),
        fontSize: 0.875.rem,
        fontWeight: FontWeight.w600,
        border: Border.only(left: BorderSide.solid(color: arisuColor, width: 1.px), right: BorderSide.solid(color: arisuColor, width: 1.px), top: BorderSide.solid(color: arisuColor, width: 1.px), bottom: BorderSide.solid(color: arisuColor, width: 1.px)),
        color: arisuColor,
      ),
    ]),

    // Stack section
    css('.stack', [
      css('&').styles(
        padding: Padding.symmetric(horizontal: 2.rem, vertical: 4.rem),
        textAlign: TextAlign.center,
      ),
      css('h2').styles(
        margin: Margin.only(bottom: 2.rem),
        fontSize: 2.rem,
        fontWeight: FontWeight.w700,
      ),
      css('.stack-grid').styles(
        display: Display.grid,
        maxWidth: 900.px,
        margin: Margin.symmetric(horizontal: Unit.auto),
        gap: Gap(column: 1.5.rem, row: 1.5.rem),
        raw: {'grid-template-columns': 'repeat(auto-fit, minmax(250px, 1fr))'},
      ),
      css('.stack-item').styles(
        padding: Padding.all(1.5.rem),
        radius: BorderRadius.circular(8.px),
        textAlign: TextAlign.left,
        backgroundColor: cardBg,
      ),
      css('.stack-item h4').styles(
        margin: Margin.only(bottom: 0.5.rem),
        fontSize: 1.rem,
        fontWeight: FontWeight.w600,
        color: primaryColor,
      ),
      css('.stack-item p').styles(
        fontSize: 0.875.rem,
        color: textSecondary,
      ),
    ]),

    // Footer
    css('footer', [
      css('&').styles(
        padding: Padding.all(2.rem),
        textAlign: TextAlign.center,
        border: Border.only(top: BorderSide.solid(color: const Color('#1e293b'), width: 1.px)),
      ),
      css('p').styles(color: textSecondary),
      css('.support').styles(margin: Margin.only(top: 0.5.rem)),
      css('.support a').styles(
        color: accentColor,
        textDecoration: const TextDecoration(line: TextDecorationLine.none),
      ),
      css('.support a:hover').styles(
        textDecoration: const TextDecoration(line: TextDecorationLine.underline),
      ),
    ]),

    // Responsive
    css.media(MediaQuery.screen(maxWidth: 768.px), [
      css('.hero h1').styles(fontSize: 2.5.rem),
      css('.cards').styles(flexDirection: FlexDirection.column, alignItems: AlignItems.center),
      css('.card').styles(width: 100.percent, maxWidth: 400.px),
    ]),
  ];
}
