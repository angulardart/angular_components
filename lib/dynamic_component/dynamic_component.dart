// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_components/model/ui/has_renderer.dart';

/// Dynamically renders another component, setting the [value] field on the
/// dynamic component if it implements [RendersValue] (and not if the component
/// does not implement the interface).
///
/// A host component can load child components in a loop and set their values:
///
///     ... *ngFor="item in items">
///       <dynamic-component
///           [componentFactory]="aFactoryThatMayNotRenderValue"
///           [value]="item">
///       </dynamic-component>
///
@Component(
  selector: 'dynamic-component',
  template: '''<template #marker></template>''',
)
class DynamicComponent implements OnDestroy {
  final SlowComponentLoader _slowComponentLoader;
  final ComponentLoader _componentLoader;
  final ChangeDetectorRef _changeDetectorRef;
  final _onLoadController = new StreamController<ComponentRef>();

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
  Type _componentType;
  ComponentFactory _componentFactory;
  Object _value;

  /// Fired when component is loaded allowing clients to get a handle on the
  /// component loaded.
  @Output()
  Stream<ComponentRef> get onLoad => _onLoadController.stream;

  DynamicComponent(this._slowComponentLoader, this._changeDetectorRef,
      this._componentLoader);

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

  void _checkAndInitialize() {
    _disposeChildComponent();
    if (_viewContainerRef != null) {
      _initialize();
    } else {
      _loadDeferred = true;
    }
  }

  /// The type of component to dynamically render.
  ///
  /// If something other than a null or Type is passed in, it will
  /// be ignored.
  @Deprecated('Use componentFactory instead as it is more tree-shakable')
  @Input()
  set componentType(Object dartType) {
    // Ignore unsupported type.
    if (dartType == null) {
      _disposeChildComponent();
    } else if (dartType is Type) {
      _componentFactory = null;
      _componentType = dartType;
      _checkAndInitialize();
    }
  }

  /// The ComponentFactory of component to dynamically render.
  ///
  /// If something other than a null or ComponentFactory is passed in, it will
  /// be ignored. Note: This only temporarially supports Object to allow for
  /// an easier transition of code. This does make this code slightly slower,
  /// but will be changed to [ComponentFactory] when [componentType] is
  /// removed.
  @Input()
  set componentFactory(Object component) {
    if (component == null) {
      _disposeChildComponent();
    } else if (component is ComponentFactory) {
      _componentType = null;
      _componentFactory = component;
      _checkAndInitialize();
    }
  }

  void _initialize() {
    if (_componentFactory != null) {
      if (_childComponent != null) {
        throw 'Attempting to overwrite a dynamic component';
      }

      _childComponent = _componentLoader.loadNextToLocation(
          _componentFactory, _viewContainerRef);
      _onLoadController.add(_childComponent);
      _updateChildComponent();
    } else {
      // TODO(google): Remove this code once componentType is no longer used.
      Type loadType = _componentType;
      _slowComponentLoader
          .loadNextToLocation(loadType, _viewContainerRef)
          .then((ComponentRef componentRef) {
        if (loadType != _componentType) {
          // During the load time, the component type has changed,
          // and the type we just loaded is no longer valid.
          componentRef.destroy();
          return;
        }
        if (_childComponent != null) {
          throw 'Attempting to overwrite a dynamic component';
        }
        _childComponent = componentRef;
        _onLoadController.add(componentRef);
        _updateChildComponent();
      });
    }
  }

  /// The value to set on the component if the component implements
  /// [RendersValue]. Optional.
  @Input()
  set value(dynamic s) {
    _value = s;
    _updateChildComponent();
  }

  void _updateChildComponent() {
    _changeDetectorRef.markForCheck();

    if (_childComponent != null) {
      if (_childComponent.instance is RendersValue) {
        _childComponent.instance.value = _value;
      }
    }
  }
}
