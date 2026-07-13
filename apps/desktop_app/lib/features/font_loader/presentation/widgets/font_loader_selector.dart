import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../../window_stack_manager/presentation/state/window_stack_manager_bloc.dart';
import '../state/font_loader_cubit.dart';

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
                WindowStackManagerOpen(
                  title: 'Load Font from URL',
                  widget: _FontLoaderSelectorWindow(),
                  size: Size(300, 260),
                ),
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
            return state.status == FontLoaderStatus.loading
                ? Center(child: CircularProgressIndicator())
                : Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
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
                        style: TextStyle(fontSize: 14, color: Colors.grey[500]),
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
                  );
          }),
    );
  }
}
