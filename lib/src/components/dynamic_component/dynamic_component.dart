// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import '../../model/ui/has_renderer.dart';
import '../../utils/async/async.dart';
import 'package:angular2/angular2.dart';

/// Dynamically renders another component, setting the [value] field on the
/// dynamic component if it implements [RendersValue] (and not if the component
/// does not implement the interface).
///
/// A host component can load child components in a loop and set their values:
///
///     ... *ngFor="item in items">
///       <dynamic-component
///           [componentType]="aTypeThatMayNotRenderValue"
///           [value]="item">
///       </dynamic-component>
///
@Component(
    selector: 'dynamic-component',
// #marker variable is used to refer to the <div> tag later when calling
// DynamicComponentLoader.loadNextToLocation. The tag does not have to be
// <span>. It can be anything. In this case, we simply needed something
// that's not visible, and <span> does the job perfectly.
    template: '''<span #marker></span>''')
class DynamicComponent implements OnDestroy {
  final DynamicComponentLoader _componentLoader;
  final ChangeDetectorRef _changeDetectorRef;
  final _onLoadController = new LazyStreamController<ComponentRef>();

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
  Object _value;

  /// Fired when component is loaded allowing clients to get a handle on the
  /// component loaded.
  @Output()
  Stream<ComponentRef> get onLoad => _onLoadController.stream;

  DynamicComponent(this._componentLoader, this._changeDetectorRef);

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

  /// The type of component to dynamically render.
  @Input()
  set componentType(Type dartType) {
    _disposeChildComponent();
    _componentType = dartType;
    if (dartType == null) {
      return;
    }
    if (_viewContainerRef != null) {
      _initialize();
    } else {
      _loadDeferred = true;
    }
  }

  void _initialize() {
    Type loadType = _componentType;
    _componentLoader
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
