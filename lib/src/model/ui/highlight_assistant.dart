// Copyright 2016 Google Inc.
// 
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// 
//     http://www.apache.org/licenses/LICENSE-2.0
// 
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

library ads.acx2.model.ui.highlight_assistant;

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