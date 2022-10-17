library shifting_tabbar;

import 'package:flutter/material.dart';
import 'package:news_roll_out/GlobalData/globalthemeconstats.dart';
import 'package:news_roll_out/GlobalWidgets/global_widget.dart';

extension ExtendedIterable<E> on Iterable<E> {
  /// Like Iterable<T>.map but callback have index as second argument
  Iterable<T> mapIndexed<T>(T Function(E e, int i) f) {
    int i = 0;
    return map((E e) => f(e, i++));
  }
}

/// A widget that displays a horizontal row of tabs with some kind of shifting animation.
///
/// Typically created instead of [AppBar] and in conjunction with a [TabBarView].
///
/// If a [TabController] is not provided, then a [DefaultTabController] ancestor
/// must be provided instead. The tab controller's [TabController.length] must
/// equal the length of the [tabs] list.
///
/// Requires one of its ancestors to be a [Material] widget.
///
/// See also:
///
///  * [TabBarView], which displays page views that correspond to each tab.
class ShiftingTabBar extends StatefulWidget implements PreferredSizeWidget {
  /// Creates a shifting tab bar.
  ///
  /// The [tabs] argument must not be null and its length must match the [controller]'s
  /// [TabController.length].
  ///
  /// If a [TabController] is not provided, then there must be a
  /// [DefaultTabController] ancestor.
  ///
  /// The [color] argument is used as background of tab bar If a [color] is not provided
  /// then it will use ancestor [ThemeData.primaryColor] property as default
  /// background color.
  ///
  /// The [brightness] argument is used to determine whatever the color of text must light
  /// or dark. If it's not provided it will use [Color.computeLuminance] function and
  /// [color] argument or [ThemeData.primaryColor] as arguments to determines this property.
  const ShiftingTabBar({
    Key? key,
    required this.tabs,
    this.controller,
    this.color,
    this.brightness,
    this.labelFlex,
    this.labelStyle,
    this.forceUpperCase = true,
    this.scrollable = false,
  })  : assert(tabs != null),
        super(key: key);

  /// Typically a list of two or more [ShiftingTab] widgets.
  ///
  /// The length of this list must match the [controller]'s [TabController.length].
  final List<ShiftingTab> tabs;

  /// This widget's selection and animation state.
  ///
  /// If [TabController] is not provided, then the value of [DefaultTabController.of]
  /// will be used.
  final TabController? controller;

  /// The color of widget background.
  ///
  /// If a [color] is not provided then it will use ancestor [ThemeData.primaryColor]
  /// property as default background color.
  final Color? color;

  /// Describes the contrast of background color.
  ///
  /// If [Brightness] is not provided, then it will use [Color.computeLuminance] function and
  /// background color as arguments to determine this property.
  final Brightness? brightness;

  ///To scroll the tab
  final bool scrollable;

  /// The amount of space that [Text] widget can take.
  ///
  /// The flex value for [Icon] widgets and also the default value of this property is 1.0
  final double? labelFlex;

  /// The text style of the tab labels.
  final TextStyle? labelStyle;

  /// The option to disable upper-case style in labels
  final bool forceUpperCase;

  @override
  _ShiftingTabBarState createState() => _ShiftingTabBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _ShiftingTabBarState extends State<ShiftingTabBar> {
  TabController? _controller;
  Color? _color;
  Brightness? _brightness;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _controller = widget.controller ?? DefaultTabController.of(context);
    _color = widget.color ?? Theme.of(context).primaryColor;
    _brightness = widget.brightness ?? Brightness.light;

    _controller?.animation?.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: kToolbarHeight,
      color: _color,
      child: SafeArea(
        top: true,
        child: widget.scrollable
            ? SingleChildScrollView(
                padding: EdgeInsets.only(left: 0.0),
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _buildTabWidgets(),
                ))
            : Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: _buildTabWidgets(),
              ),
      ),
    );
  }

// SingleChildScrollView(
//                 //padding: EdgeInsets.only(left: 0.0),
//                 scrollDirection: Axis.horizontal,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: _buildTabWidgets(),
//                 ),
//               )
  double _computeTabMargin(int tabsLength) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double labelFlex = widget.labelFlex ?? 1.0;
    final double sizeFactor = tabsLength + labelFlex;
    return (deviceWidth / sizeFactor - 19) / 2;
  }

  List<Widget> _buildTabWidgets() {
    final double margin = _computeTabMargin(widget.tabs.length);
    final List<Widget> tabWidgets = List<Widget>.generate(
        widget.tabs.length,
        (index) => _ShiftingTabWidget(
              key: widget.tabs[index].key,
              animation: _ShiftingAnimation(_controller, index),
              margin: margin,
              onTap: () => _controller?.animateTo(index),
              text: widget.forceUpperCase
                  ? widget.tabs[index].text?.toUpperCase()
                  : widget.tabs[index].text,
              brightness: _brightness ??
                  (_color!.computeLuminance() > 0.5
                      ? Brightness.dark
                      : Brightness.light),
              labelFlex: widget.labelFlex ?? 1.0,
              labelStyle: widget.labelStyle,
              iconPath: widget.tabs[index].iconpath,
            ));
    // from(
    //   widget.tabs.mapIndexed<_ShiftingTabWidget>(
    //     (ShiftingTab tab, int index) => _ShiftingTabWidget(
    //       key: tab.key,
    //       animation: _ShiftingAnimation(_controller, index),
    //       margin: margin,
    //       icon: tab.icon,
    //       iconPath: tab.iconpath,
    //       onTap: () => _controller?.animateTo(index),
    //       text: widget.forceUpperCase ? tab.text!.toUpperCase() : tab.text,
    //       brightness: _brightness ??
    //           (_color!.computeLuminance() > 0.5
    //               ? Brightness.dark
    //               : Brightness.light),
    //       labelFlex: widget.labelFlex ?? 1.0,
    //       labelStyle: widget.labelStyle,
    //     ),
    //   ),
    // );

    for (int i = 0; i < widget.tabs.length; i++) {
      tabWidgets[i] = Container(
        height: kToolbarHeight,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _ShiftingTabWidget(
              key: widget.tabs[i].key,
              animation: _ShiftingAnimation(_controller, i),
              margin: margin,
              onTap: () => _controller?.animateTo(i),
              text: widget.forceUpperCase
                  ? widget.tabs[i].text?.toUpperCase()
                  : widget.tabs[i].text,
              brightness: _brightness ??
                  (_color!.computeLuminance() > 0.5
                      ? Brightness.dark
                      : Brightness.light),
              labelFlex: widget.labelFlex ?? 1.0,
              labelStyle: widget.labelStyle,
              iconPath: widget.tabs[i].iconpath,
            ),
          ],
        ),
      );
    }

    return tabWidgets;
  }
}

class ShiftingTab {
  ShiftingTab({this.key, this.text, this.icon, required this.iconpath});

  final Key? key;
  final String? text;
  final Icon? icon;
  final String iconpath;
}

class _ShiftingTabWidget extends AnimatedWidget {
  const _ShiftingTabWidget({
    Key? key,
    required Animation<double> animation,
    this.onTap,
    this.text,
    this.icon,
    required this.iconPath,
    this.tabColor,
    this.margin,
    this.brightness,
    this.labelFlex,
    this.labelStyle,
  }) : super(key: key, listenable: animation);

  final Function? onTap;
  final Animatable<Color?>? tabColor;
  final String? text;
  final Icon? icon;
  final String iconPath;
  final double? margin;
  final Brightness? brightness;
  final double? labelFlex;
  final TextStyle? labelStyle;

  // int get iconSize => 19;
  int get textSize => 16;

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable as Animation<double>;
    Animatable<Color?> _tabColor = TweenSequence<Color?>([
      TweenSequenceItem(
        weight: 1.0,
        tween: ColorTween(
          begin: GlobalTheme().backgroundColor,
          end: GlobalTheme().kGreyLightestest,
        ),
      ),
    ]);
    final Tween<double> tween =
        Tween<double>(begin: 1.0, end: 1.0 + labelFlex!);
    final Color? color = brightness == Brightness.dark
        ? Color.lerp(Colors.white54, Colors.white, animation.value)
        : Color.lerp(Colors.black54, Colors.black, animation.value);

    return Expanded(
      flex: (tween.animate(animation).value * 100).round(),
      child: Padding(
        padding: const EdgeInsets.only(left: 5, right: 5),
        child: InkWell(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onTap: onTap as void Function()?,
          child: _buildTab(
              animation, color, _tabColor, margin!.toDouble(), context),
        ),
      ),
    );
  }

  Widget _buildTab(
    Animation<double> animation,
    Color? color,
    Animatable<Color?> tabColor,
    double margin,
    BuildContext context,
  ) {
    final TextDirection dir = Directionality.of(context);

    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      curve: Curves.easeIn,
      decoration: BoxDecoration(
          color: tabColor.evaluate(animation),
          borderRadius: BorderRadius.circular(5.0)),
      margin: EdgeInsets.only(right: margin, top: 10.0, bottom: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: 10.0,
          ),
          _buildIcon(color, margin, dir),
          SizedBox(
            width: 10.0,
          ),
          _buildText(
              animation,
              color,
              dir,
              labelStyle ??
                  Theme.of(context).textTheme.headline6!.copyWith(
                      fontSize: 14,
                      color: color,
                      letterSpacing: 2,
                      fontWeight: FontWeight.bold)),
          SizedBox(
            width: 10.0,
          ),
        ],
      ),
    );
  }

  Widget _buildIcon(Color? color, double? margin, TextDirection dir) {
    return Center(
      child: GlobalWidget().iconCreator(iconPath, size: FixedIconSize.SMALL),
    );
  }

  Widget _buildText(
    Animation<double> animation,
    Color? color,
    TextDirection dir,
    TextStyle labelStyle,
  ) {
    return FadeTransition(
      opacity: animation,
      child: SizeTransition(
        child: Container(
          child: Center(
              child: TextView(
            text!,
            size: 12.0,
            color: Color.fromARGB(255, 28, 23, 23),
            decoration: TextDecoration.none,
            fontWeight: FontWeight.bold,
            overflow: TextOverflow.visible,
            textAlign: TextAlign.center,
            textScaleFactor: .8,
          )),
        ),
        axis: Axis.horizontal,
        // axisAlignment: -1.0,
        sizeFactor: Tween<double>(begin: 0.0, end: 1.0).animate(animation),
      ),
    );
  }
}

class _ShiftingAnimation extends Animation<double>
    with AnimationWithParentMixin<double> {
  _ShiftingAnimation(this.controller, this.index);

  final TabController? controller;
  final int index;

  @override
  Animation<double> get parent => controller!.animation!;

  @override
  double get value => _indexChangeProgress(controller!, index);
}

/// I'm not exactly sure that what I did here. LOL
/// But the basic idea of this function is converting the value of controller
/// animation (witch is a double between 0.0 and number of tab items minus one)
/// to a double between 0.0 and 1.0 base on [index] of tab.
double _indexChangeProgress(TabController controller, int index) {
  final double controllerValue = controller.animation!.value;
  final double previousIndex = controller.previousIndex.toDouble();
  final double currentIndex = controller.index.toDouble();

  /// I created this part base on some experiments and I'm pretty sure this can be
  /// simplified!

  if (index != currentIndex && index != previousIndex) {
    if (controller.indexIsChanging)
      return 0.0;
    else if (controller.offset < 0 && index == controller.index - 1)
      return controller.offset.abs().clamp(0.0, 1.0);
    else if (controller.offset > 0 && index == controller.index + 1)
      return controller.offset.abs().clamp(0.0, 1.0);
    else
      return 0.0;
  }

  // The controller's offset is changing because the user is dragging the
  // TabBarView's PageView to the left or right.
  if (!controller.indexIsChanging) {
    if (index == currentIndex)
      return 1.0 - controller.offset.abs().clamp(0.0, 1.0);
    else
      return (controller.index + 1 == previousIndex && controller.offset > 0) ||
              (controller.index - 1 == previousIndex && controller.offset < 0)
          ? controller.offset.abs().clamp(0.0, 1.0)
          : 0.0;
  }

  // The TabController animation's value is changing from previousIndex to currentIndex.
  final double val = (controllerValue - currentIndex).abs() /
      (currentIndex - previousIndex).abs();
  return index == currentIndex ? 1.0 - val : val;
}
