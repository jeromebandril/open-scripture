import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/extensions/build_context_extensions.dart';
import '../../../../core/di/injection_container.dart';
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
          context.pushStandardWindow(
            title: 'Load Font from URL',
            maxSize: Size(300, 260),
            builder: (_) => _FontLoaderSelectorWindow(),
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
            if (state.status != FontLoaderStatus.loaded) return;
            context.closeWindow();
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
