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

import 'package:angular2/angular2.dart';

import '../../utils/disposer/disposer.dart';

import 'deferred_content_aware.dart';

/// When put on an element B, this directive creates B each time the nearest
/// strict ancestor [DeferredContentAware] container A becomes visible and
/// destroys B each time A becomes invisible.
///
/// Throws if A does not exist.
/// This directive can be used to avoid the cost of eagerly instantiating
/// invisible content and the cost of change-detection on invisible content.
///
/// Example:
/// <modal [(visible)]="visible">
///   <expensive-content *deferredContent></expensive-content>
/// </modal>
@Directive(selector: '[deferredContent]')
class DeferredContentDirective implements OnDestroy {
  ViewContainerRef _viewContainer;
  TemplateRef _template;
  final _disposer = new Disposer.oneShot();

  // Keep around the current state.
  bool _visible = false;

  void _setVisible(bool value) {
    if (value == _visible) return;
    if (value) {
      _viewContainer.createEmbeddedView(_template);
    } else {
      _viewContainer.clear();
    }
    _visible = value;
  }

  DeferredContentDirective(
      this._viewContainer, this._template, DeferredContentAware parent) {
    _disposer.addStreamSubscription(parent.contentVisible.listen(_setVisible));
  }

  @override
  void ngOnDestroy() {
    _disposer.dispose();
    _viewContainer = null;
    _template = null;
  }
}

/// Nested inside a [DeferredContentAware] container, this directive creates
/// its content the first time the parent container becomes visible.
///
/// This directive is not recommended as it will cause Angular to change-detect
/// the contents even when hidden. If your hidden content has push-detection
/// enabled, go for it.
@Directive(selector: '[cachedDeferredContent]')
class CachingDeferredContentDirective implements OnDestroy {
  ViewContainerRef _viewContainer;
  TemplateRef _template;
  final _disposer = new Disposer.oneShot();
  ViewRef _view;

  // Keep around the current state.
  bool _visible = false;

  void _setVisible(bool value) {
    if (value == _visible) return;
    if (value && _view == null) {
      _view = _viewContainer.createEmbeddedView(_template);
    }
    _visible = value;
  }

  CachingDeferredContentDirective(
      this._viewContainer, this._template, DeferredContentAware parent) {
    _disposer.addStreamSubscription(parent.contentVisible.listen(_setVisible));
  }

  @override
  void ngOnDestroy() {
    _disposer.dispose();
    _viewContainer = null;
    _template = null;
  }
}
