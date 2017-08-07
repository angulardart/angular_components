// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:html';

import 'package:angular/angular.dart';

import '../../css/acux/zindexer.dart';
import '../../utils/angular/imperative_view/imperative_view.dart';
import '../../utils/angular/managed_zone/angular_2.dart';
import '../../utils/browser/dom_service/angular_2.dart';
import '../../utils/browser/window/module.dart';
import '../ruler/dom_ruler.dart';
import 'src/overlay_service.dart';
import 'src/render/overlay_dom_render_service.dart';
import 'src/render/overlay_style_config.dart';

export 'src/render/overlay_dom_render_service.dart'
    show
        overlayContainerName,
        overlayContainerParent,
        overlayContainerToken,
        overlayRepositionLoop,
        overlaySyncDom;

/// Either finds, or creates an "acx-overlay-container" div at the end of body.
@Injectable()
HtmlElement getDefaultContainer(
    @Inject(overlayContainerName) String name,
    @Inject(overlayContainerParent) HtmlElement parent,
    @Optional() @SkipSelf() @Inject(overlayContainerToken) container) {
  if (container != null) return container;

  var element = parent.querySelector('#default-acx-overlay-container');
  if (element == null) {
    element = new DivElement()
      ..id = 'default-acx-overlay-container'
      ..classes.add('acx-overlay-container');
    parent.append(element);
  }
  element.attributes['container-name'] = name;
  return element;
}

@Injectable()
String getDefaultContainerName(
    @Optional() @SkipSelf() @Inject(overlayContainerName) containerName) {
  return containerName ?? 'default';
}

/// Returns an overlay container with debugging aid enabled.
@Injectable()
HtmlElement getDebugContainer(@Inject(overlayContainerName) String name,
    @Inject(overlayContainerParent) HtmlElement parent) {
  var element = getDefaultContainer(name, parent, null);
  element.classes.add('debug');
  return element;
}

@Injectable()
HtmlElement getOverlayContainerParent(Document document,
    @Optional() @SkipSelf() @Inject(overlayContainerParent) containerParent) {
  return containerParent ?? document.querySelector('body');
}

/// DI bindings for Overlay and its dependencies.
const overlayBindings = const [
  AcxImperativeViewUtils,
  DomRuler,
  domServiceBinding,
  const Provider(ManagedZone, useClass: Angular2ManagedZone),
  const Provider(overlayContainerName, useFactory: getDefaultContainerName),
  const Provider(overlayContainerToken, useFactory: getDefaultContainer),
  const Provider(overlayContainerParent, useFactory: getOverlayContainerParent),
  // Applications may experimentally make this true to increase performance.
  const Provider(overlaySyncDom, useValue: true),
  const Provider(overlayRepositionLoop, useValue: false),
  OverlayDomRenderService,
  OverlayStyleConfig,
  OverlayService,
  windowBindings,
  ZIndexer
];

/// Similar to [overlayBindings], but enables easy debugging of the overlays.
const overlayDebugBindings = const [
  overlayBindings,
  const Provider(overlayContainerToken, useFactory: getDebugContainer)
];
