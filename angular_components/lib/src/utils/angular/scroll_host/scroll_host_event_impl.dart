// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular_components/utils/angular/scroll_host/interface.dart';

class ScrollHostEventImpl implements ScrollHostEvent {
  @override
  final int deltaX;
  @override
  final int deltaY;

  ScrollHostEventImpl(this.deltaX, this.deltaY);
}
