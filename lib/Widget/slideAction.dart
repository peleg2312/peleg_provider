import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

const bool _kCloseOnTap = true;

abstract class ClosableSlideAction extends StatelessWidget {
  /// Creates a slide that closes when a tap has occurred if [closeOnTap]
  /// is [true].
  ///
  /// The [closeOnTap] argument must not be null.
  const ClosableSlideAction({
    Key? key,
    required this.onTap,
    this.closeOnTap = _kCloseOnTap,
  })  : assert(closeOnTap != null),
        super(key: key);

  /// A tap has occurred.
  final VoidCallback onTap;

  /// Whether close this after tap occurred.
  ///
  /// Defaults to true.
  final bool closeOnTap;

  /// Calls [onTap] if not null and closes the closest [Slidable]
  /// that encloses the given context.
  void _handleCloseAfterTap(BuildContext context) {
    if (onTap != null) {
      onTap();
    }

    Slidable.of(context)?.close();
  }

  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: !closeOnTap ? onTap : () => _handleCloseAfterTap(context),
      child: buildAction(context),
    );
  }

  Widget buildAction(BuildContext context);
}

class IconSlideAction extends ClosableSlideAction {
  /// Creates a slide action with an icon, a [caption] if set and a
  /// background color.
  ///
  /// The [closeOnTap] argument must not be null.
  const IconSlideAction({
    Key? key,
    required this.icon,
    required this.caption,
    Color? color,
    required this.foregroundColor,
    required VoidCallback onTap,
    bool closeOnTap = _kCloseOnTap,
  })  : color = color ?? Colors.white,
        super(
          key: key,
          onTap: onTap,
          closeOnTap: closeOnTap,
        );

  final IconData icon;

  final String caption;

  /// The background color.
  ///
  /// Defaults to true.
  final Color color;

  final Color foregroundColor;

  @override
  Widget buildAction(BuildContext context) {
    final Color estimatedColor =
        ThemeData.estimateBrightnessForColor(color) == Brightness.light
            ? Colors.black
            : Colors.white;
    final Text textWidget = new Text(
      caption ?? '',
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context)
          .primaryTextTheme
          .caption!
          .copyWith(color: foregroundColor ?? estimatedColor),
    );
    return Container(
      color: color,
      child: new Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Flexible(
              child: new Icon(
                icon,
                color: foregroundColor ?? estimatedColor,
              ),
            ),
            new Flexible(child: textWidget),
          ],
        ),
      ),
    );
  }
}
