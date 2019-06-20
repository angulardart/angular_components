// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_components/utils/disposer/disposer.dart';

import 'deferred_content_aware.dart';

/// When put on an element B, this directive creates B each time the nearest
/// strict ancestor [DeferredContentAware] container A becomes visible and
/// destroys B each time A becomes invisible.
///
/// Throws if A does not exist.
/// This directive can be used to avoid the cost of eagerly instantiating
/// invisible content and the cost of change-detection on invisible content.
@Directive(
  selector: '[deferredContent]',
)
class DeferredContentDirective implements OnDestroy {
  final _disposer = Disposer.oneShot();
  final _placeholder = DivElement();

  ViewContainerRef _viewContainer;
  EmbeddedViewRef _viewRef;
  TemplateRef _template;

  /// Create a placeholder element to maintain content size when hidden.
  ///
  /// Used like:
  /// ```html
  ///  <my-expensive-component *deferredContent="true"></my-expensive-component>
  /// ```
  @Input('deferredContent')
  bool preserveDimensions = false;

  /// Even when the content is not-visible force it to be on the page.
  ///
  /// Only use this for common components which needs to give options to it's
  /// content.
  @Input()
  set deferredContentForceContent(bool value) {
    _forceContent = value;
    _setVisible();
  }

  // Keep around the current state.
  bool _shown = false;
  bool _visible = false;
  bool _forceContent = false;

  void _setVisible() {
    bool value = _visible || _forceContent;
    if (value == _shown) return;
    if (value) {
      if (preserveDimensions) {
        // Remove the placeholder and add the deferred content.
        _placeholder.remove();
      }
      _viewRef = _viewContainer.createEmbeddedView(_template);
    } else {
      if (preserveDimensions) {
        // Save the dimensions of the deferred content.
        var rootNodes = _viewRef?.rootNodes ?? [];
        var content = rootNodes.isNotEmpty ? rootNodes.first : null;
        if (content is HtmlElement) {
          // This isn't in DomService.schedule{Read,Write} because
          // it needs to work with components that aren't scheduled.
          var dimensions = content.getBoundingClientRect();
          _placeholder.style
            ..width = '${dimensions.width}px'
            ..height = '${dimensions.height}px';
        }
      }

      // Remove the deferred content.
      _viewContainer.clear();

      if (preserveDimensions) {
        // Add the placeholder so the parent's size doesn't change.
        var container = _viewContainer.element?.nativeElement;
        if (container?.parentNode != null) {
          container.parentNode.insertBefore(_placeholder, container);
        }
      }
    }
    _shown = value;
  }

  DeferredContentDirective(
    this._viewContainer,
    this._template,
    DeferredContentAware parent,
    ChangeDetectorRef changeDetector,
  ) {
    _disposer.addStreamSubscription(parent.contentVisible.listen((value) {
      _visible = value;
      _setVisible();
      changeDetector.markForCheck();
    }));
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
@Directive(
  selector: '[cachedDeferredContent]',
)
class CachingDeferredContentDirective implements OnDestroy {
  ViewContainerRef _viewContainer;
  TemplateRef _template;
  final _disposer = Disposer.oneShot();
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
    this._viewContainer,
    this._template,
    DeferredContentAware parent,
    ChangeDetectorRef changeDetector,
  ) {
    _disposer.addStreamSubscription(parent.contentVisible.listen((value) {
      _setVisible(value);
      changeDetector.markForCheck();
    }));
  }

  @override
  void ngOnDestroy() {
    _disposer.dispose();
    _viewContainer = null;
    _template = null;
  }
}
