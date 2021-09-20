// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular/experimental.dart' show changeDetectionLink;
import 'package:angular_components/model/ui/has_renderer.dart';

/// Dynamically renders another component, setting the [value] field on the
/// dynamic component if it implements [RendersValue] (and not if the component
/// does not implement the interface).
@changeDetectionLink
@Component(
  selector: 'dynamic-component',
  template: '''<template #marker></template>''',
  changeDetection: ChangeDetectionStrategy.OnPush,
)
class DynamicComponent implements OnDestroy, AfterChanges {
  final ComponentLoader _componentLoader;
  final _onLoadController = StreamController<ComponentRef>();

  ViewContainerRef _viewContainerRef;
  bool _loadDeferred = false;

  @ViewChild('marker', read: ViewContainerRef)
  set viewContainerRef(ViewContainerRef value) {
    _viewContainerRef = value;
    if (_loadDeferred) {
      _initialize();
      _loadDeferred = false;
    }
  }

  ComponentRef _childComponent;
  ComponentFactory _componentFactory;
  bool _factoryChanged = false;
  Object _value;
  bool _valueChanged = false;
  Injector _injector;

  /// Fired when component is loaded allowing clients to get a handle on the
  /// component loaded.
  @Output()
  Stream<ComponentRef> get onLoad => _onLoadController.stream;

  DynamicComponent(this._componentLoader);

  /// Returns the loaded dynamic component reference.
  ComponentRef get childComponent => _childComponent;

  @override
  void ngOnDestroy() {
    _disposeChildComponent();
    _viewContainerRef = null;
  }

  void _disposeChildComponent() {
    _childComponent?.destroy();
    _childComponent = null;
  }

  /// The component factory of the component to dynamically render.
  @Input()
  set componentFactory(ComponentFactory component) {
    if (_componentFactory != component) _factoryChanged = true;
    _componentFactory = component;
  }

  /// The value to set on the component if the component implements
  /// [RendersValue]. Optional.
  @Input()
  set value(dynamic s) {
    _value = s;
    _valueChanged = true;
  }

  /// Optionally an injector can be passed in which the generated component
  /// will use.
  @Input()
  set injector(Injector injector) {
    _injector = injector;
    // Marks factory as changed to cause a regeneration of the component
    // with this injector.
    _factoryChanged = true;
  }

  @override
  void ngAfterChanges() {
    if (_factoryChanged) {
      _disposeChildComponent();
      if (_viewContainerRef != null) {
        _initialize();
      } else {
        _loadDeferred = true;
      }
    } else if (_valueChanged) {
      // Only update the child if the component was not changed. If the
      // component was changed then it will get initialized with the value.
      _updateChildComponent();
    }
    _valueChanged = _factoryChanged = false;
  }

  void _initialize() {
    if (_componentFactory != null) {
      if (_childComponent != null) {
        throw 'Attempting to overwrite a dynamic component';
      }

      _childComponent = _componentLoader.loadNextToLocation(
          _componentFactory, _viewContainerRef,
          injector: _injector);
      _onLoadController.add(_childComponent);
      _updateChildComponent();
    }
  }

  void _updateChildComponent() {
    if (_childComponent != null) {
      _childComponent.update((instance) {
        if (instance is RendersValue) {
          instance.value = _value;
        }
      });
    }
  }
}
