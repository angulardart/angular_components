// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';

import '../../utils/disposer/disposer.dart';
import 'src/tooltip_controller.dart';

const materialTooltipBindings = const [TooltipController];

// This is a pattern which allows a singleton service to be shared in an
// application without binding the service at the application level, while
// still allowing an application to override a service if they so choose.
// This allows components to define the service they need with reasonable
// defaults. It allows component and service authors to add singleton services
// that require injectables. If you just need a singleton pattern consider
// using dart's factory pattern.

/// Factory for [TooltipController].
const tooltipControllerBinding = const Provider(TooltipController,
    useFactory: createTooltipController,
    deps: const [
      const [TooltipController, const Optional(), const SkipSelf()],
      const [Disposer, const Optional()]
    ]);

// Shared [TooltipController] resource. Currently there is only one per
// application.
TooltipController _singletonController;

@Injectable()
TooltipController createTooltipController(
    @Optional() @SkipSelf() TooltipController controller,
    @Optional() Disposer disposer) {
  // If TooltipController was bound higher up the tree use that instance. This
  // allows an application to override the service at root.
  if (controller != null) return controller;

  if (_singletonController != null) return _singletonController;

  _singletonController = new TooltipController();
  disposer?.addFunction(() {
    _singletonController = null;
  });
  return _singletonController;
}
