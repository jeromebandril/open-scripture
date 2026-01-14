import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_smyrna_bible_v2/core/domain/entities/bible_ref.dart';

import '../bloc/b_searchbar_bloc.dart';

class BSearchbar extends StatelessWidget {
  final FocusNode? focusNode;
  final Function()? onSubmitted;
  final Function()? onEditComplete;

  const BSearchbar({
    this.focusNode,
    this.onSubmitted,
    this.onEditComplete,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final history = context.select((BSearchbarBloc b) => b.state.history);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Card(
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
        ),
        DropdownButton(
          items: history.map<DropdownMenuItem<String>>((BibleRef value) {
            return DropdownMenuItem<String>(
                value: value.toString(), child: Text(value.toString()));
          }).toList(),
          onChanged: (_) {},
        ),
      ],
    );
  }
}
