import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';
import '../../../window_stack_manager/presentation/bloc/window_stack_manager_bloc.dart';
import '../cubit/font_loader_cubit.dart';

class FontLoaderSelector extends StatelessWidget {
  const FontLoaderSelector({
    super.key,
    this.onLoadFont,
  });

  final Function(String fontName)? onLoadFont;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          // open the font loader selector window using stack manager bloc
          // instead of using an overlay
          context.read<WindowStackManagerBloc>().add(
                WindowStackManagerOpen(_FontLoaderSelectorWindow()),
              );
        },
        icon: const Icon(Icons.font_download));
  }
}

class _FontLoaderSelectorWindow extends StatelessWidget {
  _FontLoaderSelectorWindow();

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<FontLoaderCubit>(),
      child: BlocConsumer<FontLoaderCubit, FontLoaderState>(
          listenWhen: (prev, curr) => prev.status != curr.status,
          listener: (context, state) {
            if (state.status == FontLoaderStatus.loaded) {
              context
                  .read<WindowStackManagerBloc>()
                  .add(WindowStackManagerClose());
            }
          },
          builder: (context, state) {
            return Card(
              elevation: 100,
              child: Container(
                width: 300,
                height: state.status == FontLoaderStatus.error
                    ? 260 // increase height if error to show error message
                    : 240,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Theme.of(context).colorScheme.surfaceContainerHigh,
                ),
                child: state.status == FontLoaderStatus.loading
                    ? Center(child: CircularProgressIndicator())
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                  child: const Text('Load Font from URL',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18,
                                      ))),
                              IconButton(
                                  onPressed: () {
                                    context
                                        .read<WindowStackManagerBloc>()
                                        .add(WindowStackManagerClose());
                                  },
                                  icon: const Icon(Icons.close)),
                            ],
                          ),
                          SizedBox(height: 12),
                          TextField(
                            decoration: InputDecoration(
                              labelText: 'Font URL',
                              errorText: state.status == FontLoaderStatus.error
                                  ? state.errorMessage
                                  : null,
                            ),
                            controller: _controller,
                          ),
                          SizedBox(height: 12),
                          Text(
                            'Copy the URL of a font (for example, from Google Fonts) and paste it here to load the font.',
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey[500]),
                          ),
                          Spacer(),
                          TextButton(
                            onPressed: () {
                              context
                                  .read<FontLoaderCubit>()
                                  .loadFontFromUrl(_controller.text);
                            },
                            child: const Text('Load font'),
                          ),
                        ],
                      ),
              ),
            );
          }),
    );
  }
}
