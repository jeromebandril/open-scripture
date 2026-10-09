import 'package:flutter/material.dart';

class InlineLinkButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const InlineLinkButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  State<InlineLinkButton> createState() => _InlineLinkButtonState();
}

class _InlineLinkButtonState extends State<InlineLinkButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onPressed,
      borderRadius: BorderRadius.circular(4),
      onHover: (v) => setState(() => _isHovered = v),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(widget.icon, size: 12),
            const SizedBox(width: 6),
            Text(
              widget.label,
              style: TextStyle(
                fontSize: 12,
                decoration: _isHovered ? TextDecoration.underline : null,
                decorationStyle: TextDecorationStyle.solid,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
