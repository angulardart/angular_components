// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular/experimental.dart';

import '../../angular/managed_zone/interface.dart';
import '../../disposer/disposer.dart';
import './dom_service.dart';
import './dom_service_webdriver_testability.dart';

export './dom_service.dart';

// This is a pattern which allows a singleton service to be shared in an
// application without binding the service at the application level, while
// still allowing an application to override a service if they so choose.
// This allows components to define the service they need with reasonable
// defaults. It allows component and service authors to add singleton services
// that require injectables. If you just need a singleton pattern consider
// using dart's factory pattern.

/// Factory for [DomService].
const domServiceBinding =
    const Provider(DomService, useFactory: createDomService, deps: const [
  const [DomService, const Optional(), const SkipSelf()],
  const [Disposer, const Optional()],
  ManagedZone,
  Window
]);

// Shared DomService resource. Currently there is only one per application.
DomService _singletonService;

@Injectable()
DomService createDomService(@Optional() @SkipSelf() DomService service,
    @Optional() Disposer disposer, ManagedZone zone, Window window) {
  // If DomService was bound higher up the tree use that instance. This allows
  // an application to override the service at root.
  if (service != null) return service;

  if (_singletonService != null) return _singletonService;

  _singletonService = new DomService(zone, window);

  createDomServiceWebdriverTestability(_singletonService).register();

  disposer?.addFunction(() {
    _singletonService = null;
  });
  return _singletonService;
}

// Initializes DOM service and wires up DomService and AcxRootDomRender
// to send layout change notifications only if dom has been mutated by angular.
void setupAcxRootDomRenderer(Injector appInjector) {
  appInjector.get(DomService)
    ..isDomMutatedPredicate = isDomRenderDirty
    ..resetIsDomMutated = resetDomRenderDirty
    ..init();
}
