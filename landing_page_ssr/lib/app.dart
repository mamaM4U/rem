import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';

import 'components/header.dart';
import 'constants/theme.dart';
import 'pages/about.dart';
import 'pages/blog.dart';
import 'pages/home.dart';

class App extends StatelessComponent {
  const App({super.key});

  @override
  Component build(BuildContext context) {
    return div(classes: 'main', [
      const Header(),
      Router(
        routes: [
          Route(path: '/', title: 'Rem Workspace', builder: (context, state) => const Home()),
          Route(path: '/blog', title: 'Blog - Rem Workspace', builder: (context, state) => const Blog()),
          Route(path: '/about', title: 'About - Rem Workspace', builder: (context, state) => const About()),
        ],
      ),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    // Global reset and base styles
    css('*', [
      css('&').styles(
        padding: Padding.zero,
        margin: Margin.zero,
        boxSizing: BoxSizing.borderBox,
      ),
    ]),
    css('html, body', [
      css('&').styles(
        color: textPrimary,
        fontFamily: const FontFamily.list([FontFamily('Inter'), FontFamily('system-ui'), FontFamily('-apple-system')]),
        backgroundColor: darkBg,
      ),
    ]),
    css('.main', [
      css('&').styles(
        display: Display.flex,
        minHeight: 100.vh,
        flexDirection: FlexDirection.column,
      ),
    ]),
  ];
}
