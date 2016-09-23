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

library angular2_components.utils.browser.dom_service.dom_service_webdriver_testability;

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