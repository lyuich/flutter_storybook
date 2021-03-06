import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_storybook/flutter_storybook.dart';
import 'package:flutter_storybook/media_utils.dart';
import 'package:flutter_storybook/ui/model/widget.dart';
import 'package:flutter_storybook/ui/styles/text_styles.dart';

class StoryBookPage extends StoryBookItem {
  /// Returns the widgets to render in a page. These are loaded when page clicked.
  final StoryBookWidget widget;
  bool shouldScroll = true;
  bool usesToolbar = true;

  StoryBookPage(
      {@required Key key,
      @required Widget title,
      Icon icon,
      @required this.widget})
      : super(key, title, icon);

  factory StoryBookPage.storyboard(
      {@required String title,
      Map<String, List<String>> routesMapping,

      /// supplied to override the default app passed into the storyboard widget
      /// Used to add previewRoutes to the storyboard.
      MaterialApp appOverride}) {
    final page = StoryBookPage(
      key: ValueKey(title),
      title: Text(title),
      widget: StoryBookWidget((context, data, app) => StoryBoard(
            child: appOverride ?? app,
            routesMapping: routesMapping,
          )),
    );
    // disable scrolling since our storyboard will handle it for us!
    page.shouldScroll = false;
    page.usesToolbar = false;
    return page;
  }

  factory StoryBookPage.list({
    Key key,
    @required String title,
    Icon icon,
    @required List<Widget> Function(BuildContext context) widgets,
  }) =>
      StoryBookPage(
          key: key ?? ValueKey(title),
          title: Text(title),
          icon: icon,
          widget: StoryBookWidgetList(widgets));

  factory StoryBookPage.of({
    Key key,
    @required String title,
    Icon icon,
    @required Widget Function(BuildContext context) child,
  }) =>
      StoryBookPage(
          key: key ?? ValueKey(title),
          title: Text(title),
          icon: icon,
          widget: StoryBookWidget.widgetBuilder(child));

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is StoryBookPage &&
          runtimeType == other.runtimeType &&
          widget == other.widget;

  @override
  int get hashCode => super.hashCode ^ widget.hashCode;

  @override
  StoryBookPage pageFromKey(Key key) => this;

  @override
  Widget buildWidget(StoryBookPage selectedPage,
      Function(StoryBookItem p1, StoryBookPage p2) onSelectPage) {
    return StoryBookPageWidget(
      page: this,
      selectedPage: selectedPage,
      onSelectPage: (page) => onSelectPage(page, page),
    );
  }
}

class StoryBookPageWidget extends StatelessWidget {
  final StoryBookPage page;
  final StoryBookPage selectedPage;
  final Function(StoryBookPage) onSelectPage;

  const StoryBookPageWidget(
      {Key key, @required this.page, this.selectedPage, this.onSelectPage})
      : super(key: key);

  @override
  Widget build(BuildContext context) => ListTile(
        leading: page.icon ?? Icon(Icons.book),
        title: DefaultTextStyle.merge(
          child: page.title,
          style: context.isWatch ? smallStyle : null,
        ),
        selected: selectedPage != null && selectedPage == page,
        onTap: () => onSelectPage(page),
      );
}
