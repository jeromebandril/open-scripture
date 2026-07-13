import 'package:equatable/equatable.dart';
import 'bible_ref.dart';

/// Represents the styling or structural metadata for a specific chunk of text.
enum SpanType {
  normal,
  bold,
  italic,
  added, // Words added by translators (often italicized in KJV)
  underline,
  smallCaps,
  superscript,
  strongs,
  footnote,
  redLetter, // Words of Jesus
  poetry,
  reference,
  crossReference
}

/// The smallest unit of text. A purely immutable value object.
class VerseSpan extends Equatable {
  final Set<SpanType> activeStyles;
  final String text;

  /// Holds extra data: e.g., the Strong's number ("G2816"),
  /// a cross-ref target ("Gen 1:1"), or footnote text.
  final String? payload;

  const VerseSpan({
    required this.activeStyles,
    required this.text,
    this.payload,
  });

  @override
  List<Object?> get props => [activeStyles, text, payload];
}

/// A structural block within a verse.
/// Handles things like paragraph breaks or section headings that interrupt a verse.
class VerseSegment extends Equatable {
  final int segmentIndex;
  final bool isParagraphStart;
  final String? heading;
  final List<VerseSpan> spans;

  const VerseSegment({
    required this.segmentIndex,
    this.isParagraphStart = false,
    this.heading,
    required this.spans,
  });

  @override
  List<Object?> get props => [segmentIndex, isParagraphStart, heading, spans];
}

/// The aggregate root for a Biblical Verse.
class Verse extends Equatable {
  final String translationId; // e.g., 'KJV', 'NIV', 'RVR60'
  final BibleRef ref;
  final List<VerseSegment> segments;

  const Verse({
    required this.translationId,
    required this.ref,
    required this.segments,
  });

  /// Utility to get the raw text devoid of formatting.
  /// Useful for search indexing or plain-text sharing.
  String get plainText => segments
      .expand((segment) => segment.spans)
      .map((span) => span.text)
      .join();

  List<VerseSpan> get spans =>
      segments.expand((segment) => segment.spans).toList();

  @override
  List<Object?> get props => [translationId, ref, segments];
}
