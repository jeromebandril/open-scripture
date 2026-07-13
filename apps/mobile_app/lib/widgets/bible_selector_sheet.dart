import 'package:flutter/material.dart';
import 'package:shared/rc_protocol/enums/remote_command_type.dart';
import 'package:shared/rc_protocol/models/remote_command.dart';

import '../injection_container.dart' as di;
import '../services/client_ws.dart';

class BibleSelectorSheet extends StatefulWidget {
  const BibleSelectorSheet({super.key});

  @override
  State<BibleSelectorSheet> createState() => _BibleSelectorSheetState();
}

class _BibleSelectorSheetState extends State<BibleSelectorSheet> {
  List<int>? _selectedIds;
  List<dynamic> _installedBibles = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadOptions();
  }

  Future<void> _loadOptions() async {
    try {
      final res = await di.sl<RemoteWsClient>().sendRequest(
        RemoteCommand(
          target: 'pane',
          name: 'get_installed_bibles',
          type: RemoteCommandType.custom,
        ),
      );
      final data = Map<String, dynamic>.from(res?['response']);
      setState(() {
        _installedBibles = data['bibles'] ?? [];
        _selectedIds = List<int>.from(data['current'] ?? []);
        _loading = false;
      });
    } catch (_) {
      setState(() => _error = 'Failed to load');
    }
  }

  void _confirmSelection() {
    di.sl<RemoteWsClient>().sendCommand(
      RemoteCommand(
        target: 'pane',
        name: 'select_bibles',
        type: RemoteCommandType.custom,
        payload: {'ids': _selectedIds},
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error != null) return Text(_error!);
    if (_installedBibles.isEmpty) return const Text('No bibles available');

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select bibles',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          Theme(
            data: Theme.of(
              context,
            ).copyWith(splashFactory: NoSplash.splashFactory),
            child: Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _installedBibles.length,
                itemBuilder: (context, index) {
                  final bMeta = _installedBibles[index];
                  final id = bMeta['id'] as int;
                  final isSelected = _selectedIds?.contains(id) ?? false;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 2),
                    child: ListTile(
                      tileColor: isSelected
                          ? Theme.of(
                              context,
                            ).colorScheme.surfaceContainerHighest
                          : null,
                      visualDensity: VisualDensity.compact,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      onTap: () {
                        setState(
                          () => isSelected
                              ? _selectedIds?.remove(id)
                              : _selectedIds?.add(id),
                        );
                      },
                      leading: const Icon(Icons.menu_book_rounded, size: 32),
                      title: Text(bMeta['name']),
                      trailing: (_selectedIds ?? []).contains(id)
                          ? const Icon(Icons.check_rounded, size: 32)
                          : null,
                      subtitle: Text(bMeta['language']),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: _confirmSelection,
                  child: const Text('Confirm'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
