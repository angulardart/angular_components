// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_components/model/ui/highlighted_text_model.dart';

/// A component that presents a list of [HighlightedTextSegment]s.
///
/// Example parent component:
///
///     var highlighter = new TextHighlighter();
///     var segments = highlighter.highlight(text, ['search', 'tokens']);
///
/// And template:
///
///     <highlighted-text [segments]="segments"></highlighted-text>
///
/// Use [HighlightedValueComponent] for highlighting a value instead of
/// providing segments as required by this component.
@Component(
  selector: 'highlighted-text',
  templateUrl: 'highlighted_text.html',
  styleUrls: ['highlighted_text.scss.css'],
  directives: [NgFor],
  changeDetection: ChangeDetectionStrategy.OnPush,
)
class HighlightedTextComponent {
  /// List of [HighlightedTextSegment]s to present.
  @Input()
  List<HighlightedTextSegment> segments;
}
