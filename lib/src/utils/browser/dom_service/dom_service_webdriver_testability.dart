// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../../../framework_stabilizers/testability.dart';
import './dom_service.dart';

Testability createDomServiceWebdriverTestability(DomService domService) {
  if (testabilitiesEnabled) {
    return new DomServiceWebdriverTestability._(domService);
  }
  return new NullTestability();
}

/// The DomService Webdriver Testability API allows test frameworks to wait for
/// all pending activities to finish before executing the next test action.
class DomServiceWebdriverTestability extends AbstractTestability {
  final DomService _domService;

  DomServiceWebdriverTestability._(this._domService) {
    _domService.onQueuesProcessed.listen((_) => checkStable());
  }

  @override
  bool get isStable => _domService.isStable;
}
