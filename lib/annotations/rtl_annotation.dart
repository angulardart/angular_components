// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:html';

import 'package:angular/angular.dart';

/// Annotation bound to a boolean which is used to indicate that a complete
/// web page is RTL.
///
/// This is used to only read the DOM once for an app to determine if the app
/// itself is RTL. Only use this for components whose RTL is not independant
/// of the application as a whole.
const rtlToken = const OpaqueToken('isRtl');

const rtlProvider =
    const Provider(rtlToken, useFactory: determineRtl, deps: const [Document]);

@Injectable()
bool determineRtl(Document document) =>
    document.documentElement.dir == 'rtl' ||
    (document as HtmlDocument).body.dir == 'rtl';
