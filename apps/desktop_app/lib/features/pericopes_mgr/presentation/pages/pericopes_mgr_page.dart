import 'package:flutter/material.dart';

class PericopesMgrPage extends StatelessWidget {
  const PericopesMgrPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(42, 0, 42, 42),
      child: SizedBox(
        height: 400,
        child: _Description(),
        // Text(
        //   'Pericopes Manager Page',
        //   style: Theme.of(context).textTheme.headlineMedium,
        // ),
      ),
    );
  }
}

class _Description extends StatelessWidget {
  const _Description();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Text(
        'This is the Pericopes Manager Page. Here you can manage pericopes and detected languages.',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}
