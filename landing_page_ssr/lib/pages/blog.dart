import 'package:jaspr/jaspr.dart';
import 'package:jaspr/server.dart';

import '../constants/theme.dart';
import '../models/home_data.dart';
import '../services/api_service.dart';

@client
class Blog extends StatefulComponent {
  const Blog({super.key});

  @override
  State<Blog> createState() => BlogState();
}

class BlogState extends State<Blog> with PreloadStateMixin, SyncStateMixin<Blog, Map<String, dynamic>> {
  List<HomeItem> items = [];
  String? errorMessage;
  bool isLoading = true;

  @override
  Future<void> preloadState() async {
    final response = await ApiService().getHomeData();
    if (response.success && response.data != null) {
      items = response.data!.items;
    } else {
      errorMessage = response.message ?? 'Failed to load posts';
    }
    isLoading = false;
  }

  @override
  Map<String, dynamic> getState() {
    return {
      'items': items.map((e) => {
        'id': e.id,
        'title': e.title,
        'subtitle': e.subtitle,
        'imageUrl': e.imageUrl,
      }).toList(),
      'errorMessage': errorMessage,
      'isLoading': isLoading,
    };
  }

  @override
  void updateState(Map<String, dynamic>? state) {
    if (state != null) {
      items = (state['items'] as List?)?.map((e) => HomeItem(
        id: e['id'] as String,
        title: e['title'] as String,
        subtitle: e['subtitle'] as String,
        imageUrl: e['imageUrl'] as String?,
      )).toList() ?? [];
      errorMessage = state['errorMessage'] as String?;
      isLoading = state['isLoading'] as bool? ?? false;
    }
  }

  @override
  Component build(BuildContext context) {
    return div(classes: 'blog', [
      // Header
      section(classes: 'blog-hero', [
        h1([text('Blog')]),
        p([text('Latest posts from our API')]),
      ]),

      // Content
      section(classes: 'blog-content', [
        if (isLoading)
          div(classes: 'loading', [
            p([text('Loading posts...')]),
          ])
        else if (errorMessage != null)
          div(classes: 'error', [
            p([text(errorMessage!)]),
            p(classes: 'hint', [
              text('Make sure Plana API server is running at '),
              code([text(ApiService().baseUrl)]),
            ]),
          ])
        else
          div(classes: 'posts-grid', [
            for (final item in items) _buildPostCard(item),
          ]),
      ]),
    ]);
  }

  Component _buildPostCard(HomeItem item) {
    return article(classes: 'post-card', [
      if (item.imageUrl != null)
        div(
          classes: 'post-image',
          styles: Styles(
            raw: {'background-image': 'url(${item.imageUrl})'},
          ),
          [],
        ),
      div(classes: 'post-content', [
        h3([text(item.title)]),
        p([text(item.subtitle)]),
        span(classes: 'post-id', [text('#${item.id}')]),
      ]),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.blog', [
      css('&').styles(
        minHeight: 100.vh,
        backgroundColor: darkBg,
        color: textPrimary,
      ),
    ]),

    css('.blog-hero', [
      css('&').styles(
        padding: Padding.symmetric(horizontal: 2.rem, vertical: 4.rem),
        textAlign: TextAlign.center,
        raw: {'background': 'linear-gradient(135deg, #0f172a 0%, #312e81 50%, #0f172a 100%)'},
      ),
      css('h1').styles(
        margin: Margin.only(bottom: 0.5.rem),
        fontSize: 2.5.rem,
        fontWeight: FontWeight.w700,
      ),
      css('p').styles(color: textSecondary),
    ]),

    css('.blog-content', [
      css('&').styles(
        maxWidth: 1200.px,
        margin: Margin.symmetric(horizontal: Unit.auto),
        padding: Padding.all(2.rem),
      ),
    ]),

    css('.loading', [
      css('&').styles(
        padding: Padding.all(4.rem),
        textAlign: TextAlign.center,
        color: textSecondary,
      ),
    ]),

    css('.error', [
      css('&').styles(
        padding: Padding.all(2.rem),
        radius: BorderRadius.circular(8.px),
        textAlign: TextAlign.center,
        backgroundColor: const Color('#7f1d1d'),
      ),
      css('p').styles(color: textPrimary),
      css('.hint').styles(
        margin: Margin.only(top: 1.rem),
        fontSize: 0.875.rem,
        color: textSecondary,
      ),
      css('code').styles(
        padding: Padding.symmetric(horizontal: 0.5.rem, vertical: 0.25.rem),
        radius: BorderRadius.circular(4.px),
        backgroundColor: const Color('#450a0a'),
        fontFamily: const FontFamily('monospace'),
      ),
    ]),

    css('.posts-grid', [
      css('&').styles(
        display: Display.grid,
        gap: Gap(column: 1.5.rem, row: 1.5.rem),
        raw: {'grid-template-columns': 'repeat(auto-fill, minmax(300px, 1fr))'},
      ),
    ]),

    css('.post-card', [
      css('&').styles(
        radius: BorderRadius.circular(12.px),
        overflow: Overflow.hidden,
        backgroundColor: cardBg,
        raw: {'transition': 'transform 0.2s, box-shadow 0.2s'},
      ),
      css('&:hover').styles(
        raw: {
          'transform': 'translateY(-4px)',
          'box-shadow': '0 10px 40px rgba(0, 0, 0, 0.3)',
        },
      ),
    ]),

    css('.post-image', [
      css('&').styles(
        height: 160.px,
        raw: {
          'background-size': 'cover',
          'background-position': 'center',
        },
      ),
    ]),

    css('.post-content', [
      css('&').styles(padding: Padding.all(1.5.rem)),
      css('h3').styles(
        margin: Margin.only(bottom: 0.5.rem),
        fontSize: 1.125.rem,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        raw: {
          'display': '-webkit-box',
          '-webkit-line-clamp': '2',
          '-webkit-box-orient': 'vertical',
          'overflow': 'hidden',
        },
      ),
      css('p').styles(
        margin: Margin.only(bottom: 1.rem),
        fontSize: 0.875.rem,
        lineHeight: 1.5.em,
        color: textSecondary,
      ),
      css('.post-id').styles(
        fontSize: 0.75.rem,
        color: primaryColor,
      ),
    ]),
  ];
}
