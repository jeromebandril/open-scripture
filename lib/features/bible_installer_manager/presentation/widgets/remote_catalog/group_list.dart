part of 'remote_catalog_section.dart';

class _GroupList extends StatefulWidget {
  final String title;
  final List<BibleMeta> bibles;

  const _GroupList({
    required this.title,
    required this.bibles,
  });

  @override
  State<_GroupList> createState() => _GroupListState();
}

class _GroupListState extends State<_GroupList> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        HoverableContainer(
          padding: EdgeInsets.only(left: 8),
          height: 40,
          hoveredColor: const Color.fromRGBO(175, 193, 175, 1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.title),
              IconButton(
                onPressed: () => setState(() => isExpanded = !isExpanded),
                icon: const Icon(Icons.arrow_drop_down_circle_sharp),
              )
            ],
          ),
        ),
        Visibility(
          visible: isExpanded,
          child: Container(
              color: Colors.grey.shade200,
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.bibles.length,
                itemBuilder: (_, index) => RemoteCatalogRow(
                    bibleMeta: widget.bibles[index], index: index + 1),
              )),
        ),
      ],
    );
  }
}
