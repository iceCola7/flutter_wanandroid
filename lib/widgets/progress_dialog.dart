import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'circle_progressbar.dart';

///
/// How to use
///
///  _showLoading(BuildContext context) async {
///    ProgressDialog.of(context).show(ProgressType.loading, "loading...");
///    await Future.delayed(const Duration(seconds: 10));
///    ProgressDialog.of(context).dismiss();
///  }
///
enum ProgressType {
  /// show loading with CupertinoActivityIndicator and text
  loading,

  /// show Icons.check and Text
  success,

  /// show Icons.close and Text
  error,

  /// show circle progress view and text
  progress
}

/// show progress like ios app
class ProgressDialog extends StatefulWidget {
  /// the offsetY of view position from center, default is -50
  final double offsetY;
  final Widget child;

  ProgressDialog({@required this.child, this.offsetY = -50, Key key})
      : super(key: key);

  static ProgressDialogState of(BuildContext context) {
    return context
        .ancestorStateOfType(const TypeMatcher<ProgressDialogState>());
  }

  @override
  ProgressDialogState createState() => ProgressDialogState();
}

class ProgressDialogState extends State<ProgressDialog>
    with SingleTickerProviderStateMixin {
  AnimationController _animation;

  var _isVisible = false;
  var _text = "";
  var _opacity = 0.0;
  var _progressType = ProgressType.loading;
  var _progressValue = 0.0;

  @override
  void initState() {
    _animation = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this)
      ..addListener(() {
        setState(() {
          _opacity = _animation.value;
        });
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.dismissed) {
          setState(() {
            _isVisible = false;
          });
        }
      });
    super.initState();
  }

  /// dismiss
  void dismiss() {
    _animation.reverse();
  }

  /// show  with type and text
  void show(ProgressType type, String text) {
    _animation.forward();
    setState(() {
      _isVisible = true;
      _text = text;
      _progressType = type;
    });
  }

  /// show loading with text
  void showLoading({String text = "loading"}) {
    this.show(ProgressType.loading, text);
  }

  /// update progress value and text when ProgressType = progress
  ///
  /// should call `show(ProgressType.progress, "Loading")` before use
  void updateProgress(double progress, String text) {
    setState(() {
      _progressValue = progress;
      _text = text;
    });
  }

  /// show  and dismiss automatically
  Future showAndDismiss(ProgressType type, String text) async {
    show(type, text);
    var millisecond = max(500 + text.length * 200, 1000);
    var duration = Duration(milliseconds: millisecond);
    await Future.delayed(duration);
    dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        widget.child,
        Offstage(
            offstage: !_isVisible,
            child: Opacity(
              opacity: _opacity,
              child: _create(),
            ))
      ],
    );
  }

  Widget _create() {
    const double kIconSize = 50;
    switch (_progressType) {
      case ProgressType.loading:
        var sizeBox = SizedBox(
            width: kIconSize,
            height: kIconSize,
            child: CupertinoActivityIndicator(animating: true, radius: 15));
        return _createView(sizeBox);
      case ProgressType.error:
        return _createView(
            Icon(Icons.close, color: Colors.white, size: kIconSize));
      case ProgressType.success:
        return _createView(
            Icon(Icons.check, color: Colors.white, size: kIconSize));
      case ProgressType.progress:
        var progressWidget = CustomPaint(
          painter: CircleProgressBarPainter(progress: _progressValue),
          size: Size(kIconSize, kIconSize),
        );
        return _createView(progressWidget);
      default:
        throw Exception("not implementation");
    }
  }

  Widget _createView(Widget child) {
    return Stack(
      children: <Widget>[
        // do not response touch event
        IgnorePointer(
          ignoring: false,
          child: Container(
            color: Colors.transparent,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
        Center(
          child: Container(
            margin: EdgeInsets.fromLTRB(10, 10, 10, 10 - widget.offsetY * 2),
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 33, 33, 33),
                borderRadius: BorderRadius.circular(5)),
            constraints: BoxConstraints(minHeight: 130, minWidth: 130),
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(15),
                    child: child,
                  ),
                  Container(
                    child: Text(_text,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
