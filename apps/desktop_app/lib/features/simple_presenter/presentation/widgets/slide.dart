import 'package:flutter/material.dart';

import '../../domain/entities/slide_data.dart';

class Slide extends StatelessWidget {
  const Slide({super.key, required this.data});

  final SlideData data;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 4,
        children: [
          Text(
            data.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 64,
              color: Colors.white,
              fontWeight: FontWeight.w600,
              height: 1.2,
            ),
          ),
          if (data.subtitle != null)
            Text(
              data.subtitle!,
              style: TextStyle(
                fontSize: 32,
                color: Colors.white,
              ),
            )
        ],
      ),
    );
  }
}
