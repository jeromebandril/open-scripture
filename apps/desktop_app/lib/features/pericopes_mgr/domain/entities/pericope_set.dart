class PericopeSet {
  final String extId;
  final String langIsoCode;
  final int versionCount;
  final String? attribution;

  PericopeSet({
    required this.extId,
    required this.langIsoCode,
    required this.versionCount,
    this.attribution,
  });
}
