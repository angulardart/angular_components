// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library angular2_components.model.ui.highlight_assistant;

import './has_renderer.dart';
import './highlighted_text_model.dart';

/// Maintains a reference to the highlighter and a cache of highlighted data.
class HighlightAssistant {
  // Cache highlight segments.
  final _highlightCache =
      new Map<String, Map<dynamic, List<HighlightedTextSegment>>>();

  final Highlighter _optionHighlighter;

  // Lazy private highlighter getter.
  TextHighlighter __textHighlighter;

  /// Gets the default text highlighter, creating a cached instance if needed.
  TextHighlighter get _textHighlighter =>
      __textHighlighter ??= new TextHighlighter(matchFromStartOfWord: false);

  HighlightAssistant(this._optionHighlighter);

  List<HighlightedTextSegment> highlightOption(
      String _lastQuery, dynamic item, ItemRenderer itemRenderer) {
    var _queryHighlightCache = _highlightCache[_lastQuery] ??= {};
    var value = _queryHighlightCache[item];
    if (value == null) {
      value = (_optionHighlighter != null
          ? _optionHighlighter(_lastQuery, item)
          : _textHighlighter.highlight(itemRenderer(item), [_lastQuery]));
      _queryHighlightCache[item] = value;
    }
    return value;
  }
}
