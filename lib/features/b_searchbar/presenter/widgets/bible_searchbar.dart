import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/b_searchbar_bloc.dart';

class BSearchbar extends StatelessWidget {
  const BSearchbar({
    this.focusNode,
    this.onSubmitted,
    this.onEditComplete,
    super.key,
  });

  final FocusNode? focusNode;
  final Function()? onSubmitted;
  final Function()? onEditComplete;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        width: 400,
        child: TextField(
          focusNode: focusNode,
          onEditingComplete: () {
            if (onEditComplete != null) onEditComplete!();
          },
          onSubmitted: (input) {
            BlocProvider.of<BSearchbarBloc>(context)
                .add(BSearchbarParseIntent(input));

            if (onSubmitted != null) onSubmitted!();
          },
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
    );
  }
}
