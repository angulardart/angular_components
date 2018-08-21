// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular_components/model/ui/highlighted_text_model.dart';

abstract class HighlightProvider {
  List<HighlightedTextSegment> highlightOption(Object value);
}
