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

library angular2_components.utils.angular.reference.reference;

import 'package:angular2/angular2.dart';

// TODO(google): Remove this once use of '#' in a template is either
// consistent, or has a way to declare specifically what you want - e.g. the
// component instance or the element ref. Today, using # on an HTML element will
// be an elementRef, but # on a component will be a component instance.

/// Place on an element or component to expose the [ElementRef] as 'ref'.
///
/// Example usage:
///     <material-button ref #button="ref"></materialButton>
///     <!-- You can now use 'button' in this template as a property -->
@Directive(selector: '[ref]', exportAs: 'ref')
class ReferenceDirective {
  final ElementRef elementRef;

  ReferenceDirective(this.elementRef);
}
