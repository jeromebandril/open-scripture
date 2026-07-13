import 'dart:math';

import 'package:flutter/material.dart';

const _welcomeVerses = [
  (
    reference: '1 Corinthians 14:40',
    text: 'Let all things be done decently and in order.',
  ),
  (
    reference: 'Psalm 119:105',
    text: 'Thy word is a lamp unto my feet, and a light unto my path.',
  ),
  (
    reference: 'Colossians 3:16',
    text: 'Let the word of Christ dwell in you richly in all wisdom.',
  ),
  (
    reference: 'Hebrews 4:12',
    text:
        'For the word of God is quick, and powerful, and sharper than any twoedged sword.',
  ),
  (
    reference: 'Romans 10:17',
    text: 'So then faith cometh by hearing, and hearing by the word of God.',
  ),
  (
    reference: 'Psalm 96:9',
    text: 'O worship the LORD in the beauty of holiness.',
  ),
  (
    reference: 'Nehemiah 8:8',
    text: 'So they read in the book in the law of God distinctly.',
  ),
  (
    reference: '2 Timothy 3:16',
    text: 'All scripture is given by inspiration of God.',
  ),
];

class InitalEmptyContentScreen extends StatefulWidget {
  const InitalEmptyContentScreen({super.key});

  @override
  State<InitalEmptyContentScreen> createState() =>
      _InitalEmptyContentScreenState();
}

class _InitalEmptyContentScreenState extends State<InitalEmptyContentScreen> {
  late final verse;

  @override
  void initState() {
    super.initState();
    verse = _welcomeVerses[Random().nextInt(_welcomeVerses.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 16,
      children: [
        Text(
          "\"${verse.text}\"",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
        ),
        Text(verse.reference),
      ],
    );
  }
}
