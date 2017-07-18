// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:html';

import 'package:angular/angular.dart';

/// Utility class to allow opening a URL in a new window.
@Injectable()
class NewWindowOpener {
  void open(String url) => openInNewWindow(url);
}

/// Opens the given url in a new window.
///
/// Gives a hint to Chrome that it should open the given link in a separate
/// process.
void openInNewWindow(String url) {
  var anchorElement = new AnchorElement(href: url)
    ..rel = 'noreferrer'
    ..target = '_blank';
  document.body.append(anchorElement);
  anchorElement.click();
  anchorElement.remove();
}
