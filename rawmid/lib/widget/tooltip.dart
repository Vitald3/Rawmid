import 'package:flutter/material.dart';

class TooltipWidget extends StatefulWidget {
  final Widget child;
  final String message;

  const TooltipWidget({super.key, required this.child, required this.message});

  @override
  TooltipWidgetState createState() => TooltipWidgetState();
}

class TooltipWidgetState extends State<TooltipWidget> {
  OverlayEntry? _overlayEntry;
  bool _isTooltipVisible = false;

  void _showTooltip(BuildContext context) {
    if (_isTooltipVisible) return;

    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    final screenHeight = MediaQuery.of(context).size.height;

    double tooltipHeight = 40;
    bool showAbove = position.dy > screenHeight / 2;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: position.dx + renderBox.size.width / 2 - 26,
        top: showAbove ? position.dy - tooltipHeight - 10 : position.dy + renderBox.size.height + 10,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(5)
            ),
            child: Text(
              widget.message,
              style: TextStyle(color: Colors.white, fontSize: 14)
            )
          )
        )
      )
    );

    overlay.insert(_overlayEntry!);
    _isTooltipVisible = true;

    Future.delayed(Duration(seconds: 3), () {
      _hideTooltip();
    });
  }

  void _hideTooltip() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _isTooltipVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showTooltip(context),
      child: widget.child
    );
  }
}