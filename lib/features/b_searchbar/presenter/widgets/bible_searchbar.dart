import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/b_searchbar_bloc.dart';

class BSearchbar extends StatelessWidget {
  final List<String> items;

  const BSearchbar({required this.items, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Card(
          child: SizedBox(
            width: 400,
            child: TextField(
              onSubmitted: (input) => _onSubmitted(input, context),
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

  void _onSubmitted(String input, context) {
    print("> BSearchbar: analyzing prompt...");
    BlocProvider.of<BSearchbarBloc>(context)
        .add(BSearchbarAnalyzeIntent(input));
  }
}
