// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:math' show max;

import 'package:meta/meta.dart';
import 'package:quiver/core.dart' show hash2;

/// Produces a list of [HighlightedTextSegment] instances for the given [query]
/// and [value].
typedef Highlighter<T> = List<HighlightedTextSegment> Function(
    String query, T value);

/// Represents a sub-sequence of a search suggestion, highlighted based on
/// whether it matches the query string.
class HighlightedTextSegment {
  final bool isHighlighted;
  final String text;

  HighlightedTextSegment(this.text, this.isHighlighted);

  @override
  bool operator ==(other) =>
      other is HighlightedTextSegment &&
      isHighlighted == other.isHighlighted &&
      text == other.text;

  @override
  int get hashCode => hash2(isHighlighted, text);

  @override
  String toString() => isHighlighted ? "*$text*" : text;
}

/// A class to highlight the occurrences of a list of tokens within a string.
/// By default, matches are only highlighted at the start of words,
/// and matching is case-insensitive.
class TextHighlighter {
  final bool caseSensitive;
  final bool matchFromStartOfWord;

  const TextHighlighter(
      {this.caseSensitive = false, this.matchFromStartOfWord = true});

  List<HighlightedTextSegment> highlight(String text, List<String> tokens) =>
      _applyMarkers(text, getMarkers(text, tokens));

  /// Mark the start of each occurrence of each token with a number equal to
  /// the length of the token.
  ///
  /// This can be thought of as the amount of "ink" that the highlighter should
  /// have when starting from this point.
  ///
  /// e.g. For the text `"abc def"` with [tokens] `["ab", "de"]`
  /// the marker array will be `[2,0,0,0,2,0,0]`, and the highlighted
  /// segments of the string will be computed as `[*ab*,c ,*de*,f]`
  ///
  /// Subclasses of [TextHighlighter] can override this method to provide custom
  /// text highlighting behavior.
  @protected
  List<int> getMarkers(String text, List<String> tokens) {
    var _matchText = caseSensitive ? text : text.toLowerCase();
    List<int> markers = List.filled(_matchText.length, 0);

    for (String token in tokens) {
      // Prevents an infinite loop, since there are "infinite" occurrences of
      // the empty string.
      if (token.isEmpty) continue;
      if (!caseSensitive) {
        token = token.toLowerCase();
      }
      int index = 0;
      while (true) {
        index = _matchText.indexOf(token, index);
        if (index == -1) {
          break;
        } else {
          String wrapperToken = index != 0 ? _matchText[index - 1] : null;
          if (!matchFromStartOfWord ||
              (index == 0 ||
                  // Some suggestions will have an alternate label appended to
                  // the end of the suggestion and enclosed in parenthesis or
                  // square brackets. We want to highlight matches to words that
                  // are wrapped in square brackets and parenthesis so we add
                  // this check here.
                  wrapperToken == "(" ||
                  wrapperToken == " " ||
                  wrapperToken == "[")) {
            markers[index] = max(markers[index], token.length);
          }
          index += token.length;
        }
      }
    }
    return markers;
  }

  /// Returns the highlighted list of segments based on the "ink" markers
  /// computed previously.
  List<HighlightedTextSegment> _applyMarkers(String text, List<int> markers) {
    var segments = <HighlightedTextSegment>[];
    var currentSegment = StringBuffer();

    void commitSegment({@required bool highlight}) {
      if (currentSegment.isEmpty) return;
      segments
          .add(HighlightedTextSegment(currentSegment.toString(), highlight));
      currentSegment.clear();
    }

    var ink = 0, inkPrevious = 0, i = 0, caseOffset = 0;

    while (i < text.length) {
      // "Apply" the ink to the current letter.
      ink = max(0, inkPrevious - 1);
      if (ink == 0 && inkPrevious > 0) {
        // Ran out of ink, commit the previous segment.
        commitSegment(highlight: true);
      }

      // Gather more ink.
      if (ink < markers[i + caseOffset]) {
        ink = markers[i + caseOffset];
        if (i > 0) {
          // Commit the previous segment.
          commitSegment(highlight: inkPrevious > 0);
        }
      }

      currentSegment.writeCharCode(text.codeUnitAt(i));

      // Handle the special case of some capital letters being mapped to
      // lowercase letters consisting of multiple code units, e.g. 'İ' maps to
      // "\u{69}\u{307}"
      var lowercaseChar = text[i].toLowerCase();
      if (!caseSensitive &&
          text[i] != lowercaseChar &&
          lowercaseChar.length > text[i].length) {
        var lengthDiff = lowercaseChar.length - text[i].length;
        // Offset the marker index so that on the next iteration, it points to
        // the correct index in the original string. e.g. for the string
        // "İabc" (length 4), the lowercase version is "i.abc" (length 5). On
        // the next iteration the original text index `i` of "a" is 1, but the
        // marker index `i + caseOffset` is now 2.
        caseOffset += lengthDiff;
        // Reduce the amount of ink, since the marker computation applied
        // too much ink to the capital letter at this index, as it was
        // accounting for the lowercase letter which has greater length.
        ink -= lengthDiff;
      }

      inkPrevious = ink;
      i++;
    }
    commitSegment(highlight: inkPrevious > 0);

    return segments;
  }
}
