import 'package:example/main.dart';
import 'package:example/storybook/buttons_page.dart';
import 'package:example/storybook/toasts_page.dart';
import 'package:example/widgets/radios.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_storybook/flutter_storybook.dart';
import 'package:flutter_storybook/mediaquery/device_sizes.dart';

import '../title_widgets.dart';
import '../widgets/cells.dart';
import '../widgets/toast.dart';

final groupMainCell = PropGroup('Main Cell', 'mainCell');
final groupMainCellLong = PropGroup('Main Cell Long', 'mainCellLong');

void main() => runApp(AppStoryBook());

class AppStoryBook extends StatelessWidget {
  const AppStoryBook({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoryBook.withApp(
      buildApp(),
      routesMapping: {
        'home': [
          '/home',
          '/company',
        ],
        'home 2': [
          '/home',
          '/company',
        ]
      },
      data: StoryBookData(
        title: Text('Example Storybook'),
        defaultDevice: DeviceSizes.iphoneX,
        items: [
          StoryBookFolder.of(title: 'Widgets', pages: [
            buildTextStylePage(),
            buildButtonsPage(),
            buildToastPage(),
            buildRadiosPage(),
          ]),
          StoryBookFolder.of(title: 'Composite', pages: [
            buildAlertsPage(),
            buildCellsPage(),
            buildMainCellListPage(),
          ]),
        ],
      ),
    );
  }

  StoryBookPage buildCellsPage() => StoryBookPage.list(
        title: 'Cells',
        widgets: (context) => [
          WidgetContainer(
            title: Text('Main Cell Widget'),
            children: <Widget>[
              MainCell(
                title: props(context)
                    .text('Main Title', 'Go Home', group: groupMainCell),
                subtitle: props(context).text(
                    'Main Subtitle', 'This goes home good',
                    group: groupMainCell),
                iconText: 'H',
                count: props(context)
                    .integer('Item Count', 10, group: groupMainCell),
                isFlipped: props(context)
                    .boolean('Flip Layout', false, group: groupMainCell),
              )
            ],
          ),
          WidgetContainer(
            title: Text('Main Cell Widget With Long Text'),
            children: <Widget>[
              MainCell(
                title: 'Live Life',
                subtitle:
                    'In porttitor mauris dui, pellentesque egestas justo rutrum a. Praesent eu congue justo. Mauris vulputate tempor augue a luctus. Nullam elementum, elit eu pretium convallis, purus sapien lobortis libero, eget congue diam erat suscipit ipsum. In hac habitasse platea dictumst. Vestibulum tincidunt nisi in elit mattis commodo. Duis eu placerat nibh. Nulla magna magna, tristique sed sapien imperdiet, porttitor pulvinar libero. Mauris nec vehicula velit, a maximus ligula. Morbi in purus et eros placerat faucibus non fermentum lorem. Nunc sit amet felis eu mi scelerisque aliquam a imperdiet justo. Nulla facilisi. Proin commodo facilisis sapien vel aliquam. Cras quis nisi quam. Fusce vitae arcu non arcu cursus aliquam vitae non turpis. Integer hendrerit efficitur commodo.',
                iconText: 'L',
                count: props(context)
                    .range('Long Text Count',
                        Range(min: 1, max: 20, currentValue: 1),
                        group: groupMainCellLong)
                    .toInt(),
              )
            ],
          ),
          PropTable(
            title: Text('Main Cell Props'),
            items: [
              PropTableItem(
                  name: 'Icon Text',
                  description:
                      'Specify a single text character to display as avatar.',
                  example: MainCellAvatar(
                    iconText: 'A',
                  )),
              PropTableItem(name: 'Title', description: 'Title for Cell'),
              PropTableItem(name: 'Subtitle', description: 'Subtitle for Cell'),
              PropTableItem(
                  name: 'Count',
                  description: 'displays a counter for the cell.',
                  defaultValue: '0'),
            ],
          ),
        ],
      );

  StoryBookPage buildAlertsPage() => StoryBookPage.list(
        title: 'Alerts',
        icon: Icon(Icons.error),
        widgets: (context) => [
          ExpandableWidgetSection(
            initiallyExpanded: true,
            title: 'Network Alert',
            children: <Widget>[
              AlertDialog(
                title: Text('Network Error'),
                content: Text('Something went wrong'),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Ok'),
                    onPressed: actions(context).onPressed('Alert Ok Button'),
                  ),
                ],
              )
            ],
          ),
          ExpandableWidgetSection(
            initiallyExpanded: true,
            title: 'Confirmation Dialog',
            children: <Widget>[
              AlertDialog(
                title: Text('Are you sure you want to get Pizza?'),
                content: Text('You can always order later'),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Yes'),
                    color: Theme.of(context).accentColor,
                    onPressed: actions(context).onPressed('Alert Yes Button'),
                  ),
                  FlatButton(
                    child: Text('No'),
                    onPressed: actions(context).onPressed('Alert No Button'),
                  ),
                ],
              )
            ],
          )
        ],
      );

  StoryBookPage buildTextStylePage() => StoryBookPage.list(
        title: 'Text Style Widgets',
        widgets: (context) => [
          ExpandableWidgetSection(
              initiallyExpanded: true,
              title: 'Header 1',
              children: [mainTitle('H1')]),
          ExpandableWidgetSection(
              initiallyExpanded: true,
              title: 'Other Headers',
              children: <Widget>[
                subTitle('H2'),
                h3('H3'),
              ]),
          ExpandableWidgetSection(
            title: 'Body Content',
            subtitle: 'This is content most used in decriptions',
            children: [
              body("""
                        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce suscipit iaculis velit, et ornare diam. Etiam molestie purus nec mollis malesuada. Etiam luctus, dolor eget mattis posuere, mauris turpis ullamcorper dolor, quis maximus ante erat ullamcorper tellus. Quisque sem tellus, interdum quis turpis sit amet, accumsan aliquet mi. Aliquam feugiat sapien sit amet metus tristique aliquet. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Pellentesque dignissim quam id augue efficitur varius. Phasellus sed arcu a nibh cursus fringilla blandit ac purus. Fusce diam erat, tristique eget venenatis a, gravida quis metus.

Curabitur viverra, leo et mollis gravida, arcu diam iaculis turpis, ac sollicitudin magna ipsum nec dolor. Fusce a porttitor nisl, ut tempor quam. Nam quis lorem magna. Phasellus facilisis laoreet varius. Nullam eget leo sit amet enim faucibus euismod. Nullam tempus diam et velit eleifend, eu eleifend arcu tristique. Ut vitae luctus leo. Suspendisse aliquam velit nibh, eget scelerisque tellus condimentum vitae. Quisque pharetra iaculis suscipit.

Nunc ac pulvinar nunc. Sed blandit mauris sed aliquam lobortis. Vivamus viverra mauris diam, vel dignissim ante ultrices et. Curabitur congue fermentum dolor, eget vestibulum ligula dignissim facilisis. Etiam tortor felis, cursus eget tortor nec, molestie facilisis nunc. Suspendisse elementum venenatis justo a blandit. Maecenas molestie eros sed mauris auctor, nec imperdiet sem feugiat. Fusce dignissim cursus fermentum. Curabitur in nisi nisi. In auctor, nibh eu pretium fringilla, metus erat tempor augue, sagittis facilisis quam erat sit amet ante. Aliquam tincidunt enim in augue tempor vulputate. Quisque tincidunt erat non nisi mattis convallis. In tellus sem, elementum eu libero vitae, iaculis ullamcorper sem. Aenean luctus neque eu enim porttitor lacinia. Ut tempor egestas enim, nec fringilla mauris sollicitudin sed.
                        """)
            ],
          ),
        ],
      );

  StoryBookPage buildMainCellListPage() => StoryBookPage.of(
        title: 'Main Cell List',
        child: (context) => MainCellList(
          shrinkWrap: true,
          items: [
            MainCellItem('A', 'Item 1', 'Item Subtitle', 10),
            MainCellItem('B', 'Item 2', 'Item Subtitle', 20),
          ],
        ),
      );

  StoryBookPage buildRadiosPage() => StoryBookPage.list(
        title: "Radios",
        icon: Icon(Icons.radio_button_checked),
        widgets: (context) => [
          WidgetContainer(title: Text("Plain Radios"), children: [
            RadioGroup(
              valueChanged: (value) {
                actions(context).valueChanged("Plain Radio")(value);
                final _props = props(context);
                _props.radioChanged("Radios", value);
              },
              selectedValue: props(context).radios(
                  "Radios",
                  PropValues(
                    selectedValue: "Yellow",
                    values: [
                      "Yellow",
                      "Red",
                      "Green",
                    ],
                  )),
            ),
          ]),
        ],
      );
}
