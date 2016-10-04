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

library angular2_components.utils.browser.dom_service.angular_2;

import 'dart:html';

import 'package:angular2/angular2.dart';
import 'package:angular2/src/core/di.dart' show Injector, Injectable;
import 'package:angular2/src/platform/dom/dom_renderer.dart'
    show DomRootRenderer;

import '../../angular/managed_zone/interface.dart';
import './dom_service.dart';
import './dom_service_webdriver_testability.dart';
import '../../disposer/disposer.dart';

export 'package:angular2/src/platform/dom/dom_renderer.dart'
    show DomRootRenderer;

export './dom_service.dart';

// WARNING EXPERIMENTAL DO NOT COPY THIS PATTERN without talking to
// tsander@, matanl@, or ferhat@ first. This is an experimental pattern which
// allows a singleton service to be shared in an application without binding the
// service at the application level, while still allowing an application to
// override a service if they so choose. This allows components to define the
// service they need with reasonable defaults. It allows component and service
// authors to add singleton services that require injectables. If you just need
// a singleton pattern consider using dart's factory pattern.

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
    ..isDomMutatedPredicate = () {
      return DomRootRenderer.isDirty;
    }
    ..resetIsDomMutated = () {
      DomRootRenderer.isDirty = false;
    }
    ..init();
}
