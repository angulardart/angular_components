// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_components/highlighted_text/highlighted_text.dart';
import 'package:angular_components/model/ui/has_renderer.dart';
import 'package:angular_components/model/ui/highlight_provider.dart';
import 'package:angular_components/model/ui/highlighted_text_model.dart';

/// An alternate api to [HighlightedTextComponent] that uses a highlighter
/// and accepts a value that it converts to text segments using a
/// [HighlightProvider].
@Component(
  selector: 'highlight-value',
  templateUrl: 'highlighted_text.html',
  styleUrls: ['highlighted_text.scss.css'],
  directives: [NgFor],
)
class HighlightedValueComponent implements RendersValue {
  final HighlightProvider _highLighter;

  /// Value to pass to the highlighter to calculate text segments.
  @override
  @Input()
  Object value;

  HighlightedValueComponent(this._highLighter);

  /// List of [HighlightedTextSegment]s to present.
  List<HighlightedTextSegment> get segments {
    /// Highlighter is caching the data so this is fine otherwise this object
    /// would need to know when it needs to requery if the highlighting changed.
    return _highLighter.highlightOption(value);
  }
}
