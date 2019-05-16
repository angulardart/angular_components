// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_components/utils/browser/dom_service/dom_service.dart';
import 'package:angular_components/utils/disposer/disposer.dart';

/// A single entrypoint library for working with highly dynamic views in Angular
/// 2 code. This allows easier refactoring and migration of approaches as the
/// Angular team iterates and a standard API for AngularDart components to use.
///
/// Example use (see imperative_view_test as well):
///     @Component(
///       selector: 'imperative-list',
///       properties: const [
///         'items'
///       ]
///     )
///     @View(
///       template: '',
///       renderer: ''
///     )
///     class ImperativeListComponent {
///       final AcxImperativeViewUtils _imperativeViewUtils;
///       final ElementRef _elementRef;
///       final _listElement = new Element.ul();
///
///       ImperativeListComponent(this._imperativeViewUtils, this._elementRef) {
///         _dynamicViewUtils.useAsImperativeView(_elementRef, _listElement);
///       }
///
///       set items(List<String> items) {
///         _listElement.children.clear();
///         items.forEach((item) {
///           final itemElement = new Element.li();
///           _imperativeViewUtils.insertAngularComponent(
///               ItemComponent,
///               _elementRef,
///               itemElement).then((ComponentRef componentRef) =>
///                   componentRef.instance = item);
///           _listElement.append(itemElement);
///         });
///       }
///     }
///
///     @Component(
///       selector: 'item',
///       properties: const [
///         'value'
///       ]
///     )
///     @View(
///       template: '{{value}}'
///     )
///     class ItemComponent {
///       String value;
///     }
@Injectable()
class AcxImperativeViewUtils {
  final ComponentLoader _componentLoader;
  final DomService _domService;

  AcxImperativeViewUtils(this._componentLoader, this._domService);

  /// Returns a future that completes with a new instance created by
  /// [componentFactory], once it is inserted [intoDomElement].
  Future<ComponentRef<T>> insertComponent<T>(
      ComponentFactory<T> componentFactory,
      ViewContainerRef viewContainer,
      HtmlElement intoDomElement,
      {Injector injector}) async {
    final ref = _componentLoader.loadNextToLocation<T>(
        componentFactory, viewContainer,
        injector: injector ?? viewContainer.parentInjector);
    await _domService.onWrite();
    intoDomElement.append(ref.location);
    return ref;
  }

  /// Returns a future that completes after inserting [templateRef]
  /// into template location, preserving [existingLocation]'s scope if supplied.
  ///
  /// The returned instance can be destroyed by disposing it.
  ///
  /// **WARNING**: This code is experimental.
  Future<ImperativeViewRef> insertAngularView(HtmlElement intoDomElement,
      TemplateRef templateRef, ViewContainerRef viewContainer) {
    return _domService.onWrite().then((_) {
      var viewRef = viewContainer.createEmbeddedView(templateRef);
      for (final rootNode in viewRef.rootNodes) {
        intoDomElement.append(rootNode);
      }
      return ImperativeViewRef._(viewRef, () {
        var index = viewContainer.indexOf(viewRef);
        if (index > -1) viewContainer.remove(index);
      });
    });
  }
}

/// A handle to an imperatively created Angular view.
class ImperativeViewRef implements Disposable {
  final DisposeFunction _disposeFn;
  final EmbeddedViewRef viewRef;

  ImperativeViewRef._(this.viewRef, this._disposeFn);

  @override
  void dispose() {
    _disposeFn();
  }
}
