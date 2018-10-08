// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_components/highlighted_text/highlighted_value.dart';
import 'package:angular_components/highlighted_text/highlighted_value.template.dart'
    as highlight;
import 'package:angular_components/model/selection/select.dart';
import 'package:angular_components/model/selection/selection_container.dart';
import 'package:angular_components/model/ui/has_factory.dart';
import 'package:angular_components/model/ui/highlight_assistant.dart';
import 'package:angular_components/model/ui/highlight_provider.dart';
import 'package:angular_components/model/ui/highlighted_text_model.dart';

/// Assistant to support highlighting in a SelectionContainer.
abstract class HighlightAssistantMixin<T>
    implements SelectionContainer<T>, HighlightProvider {
  @Deprecated('Use highlightFactoryRenderer instead as it allows tree-shaking.')
  final ComponentRenderer highlightComponentRenderer =
      (_) => HighlightedValueComponent;
  final FactoryRenderer highlightFactoryRenderer =
      (_) => highlight.HighlightedValueComponentNgFactory;

  HighlightAssistant _highlightAssistant;

  Highlighter _optionHighlighter;
  Highlighter get optionHighlighter => _optionHighlighter;

  /// Function which returns a list of [HighlightedTextSegment] for the given
  /// query and value.
  ///
  /// If no `optionHighlighter` is provided, a `TextHighlighter` is used in
  /// conjunction with the `itemRenderer` to produce the list of text segments.
  @Input()
  set optionHighlighter(Highlighter value) {
    _optionHighlighter = value;
    _highlightAssistant = null;
  }

  bool _highlightMatchFromStartOfWord = false;

  /// Whether matches should only highlight at the start of words.
  @Input()
  set highlightMatchFromStartOfWord(bool value) {
    _highlightMatchFromStartOfWord = value;
    _highlightAssistant = null;
  }

  /// The query to highlight.
  String get highlightQuery =>
      options is Filterable ? (options as Filterable).currentQuery ?? '' : '';

  ItemRenderer<T> get _highlightRenderer {
    if ((componentRenderer == null ||
            componentRenderer == highlightComponentRenderer) &&
        (factoryRenderer == null ||
            factoryRenderer == highlightFactoryRenderer)) {
      return itemRenderer ?? defaultItemRenderer;
    }
    return defaultItemRenderer;
  }

  @override
  List<HighlightedTextSegment> highlightOption(Object item) {
    _highlightAssistant ??= HighlightAssistant(
        optionHighlighter: optionHighlighter,
        matchFromStartOfWord: _highlightMatchFromStartOfWord);
    return _highlightAssistant.highlightOption(
        highlightQuery, item, _highlightRenderer);
  }
}
