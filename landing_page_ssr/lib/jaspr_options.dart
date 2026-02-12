// dart format off
// ignore_for_file: type=lint

// GENERATED FILE, DO NOT MODIFY
// Generated with jaspr_builder

import 'package:arisu/components/header.dart' as prefix0;
import 'package:arisu/pages/about.dart' as prefix1;
import 'package:arisu/pages/blog.dart' as prefix2;
import 'package:arisu/pages/home.dart' as prefix3;
import 'package:arisu/app.dart' as prefix4;
import 'package:jaspr/server.dart';

/// Default [JasprOptions] for use with your jaspr project.
///
//  Use this to initialize jaspr **before** calling [runApp].
///
/// Example:
/// ```dart
/// import 'jaspr_options.dart';
///
/// void main() {
///   Jaspr.initializeApp(
///     options: defaultJasprOptions,
///   );
///
///   runApp(...);
/// }
/// ```
ServerOptions get defaultJasprOptions => ServerOptions(
  clients: {
    prefix1.About: ClientTarget<prefix1.About>('pages/about'),

    prefix2.Blog: ClientTarget<prefix2.Blog>('pages/blog'),

    prefix3.Home: ClientTarget<prefix3.Home>('pages/home'),
  },
  styles: () => [
    ...prefix0.Header.styles,
    ...prefix1.About.styles,
    ...prefix2.BlogState.styles,
    ...prefix3.Home.styles,
    ...prefix4.App.styles,
  ],
);
