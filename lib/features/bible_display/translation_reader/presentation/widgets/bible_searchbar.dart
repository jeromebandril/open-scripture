import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/reader_bloc.dart';

class BibleSearchbar extends StatelessWidget {
  final List<String> items;

  const BibleSearchbar({required this.items, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Card(
          child: SizedBox(
            width: 400,
            child: TextField(
              onSubmitted: (text) => _onSubmitted(text, context),
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search, size: 20),
                contentPadding: EdgeInsets.only(right: 8),
                hintText: 'Search reference',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                ),
                hoverColor: Colors.transparent,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _onSubmitted(String text, context) {
    BlocProvider.of<ReaderBloc>(context).add(
      ReaderAnalyzePrompt(text),
    );
  }
}
