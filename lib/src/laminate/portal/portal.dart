// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';

import '../../utils/angular/imperative_view/imperative_view.dart';
import '../../utils/disposer/disposer.dart';

/// Dynamic content that can be inserted into a host container.
abstract class Portal<T> {
  PortalHost _attachedHost;

  /// Attaches the portal within [host].
  ///
  /// Returns a future that completes with an instance of the portal's instance.
  ///
  /// Throws [StateError] if a portal is already attached.
  Future<T> attach(PortalHost host) {
    assert(host != null);
    if (isAttached) {
      throw new StateError('Already attached to host!');
    } else {
      _attachedHost = host;
      return host.attach(this) as Future<T>;
    }
  }

  /// Creates a copy of this portal that can also be attached.
  Portal<T> clone();

  /// Detaches the portal if attached to a host.
  ///
  /// Returns a future that completes when detached.
  Future detach() {
    final currentHost = _attachedHost;
    assert(currentHost != null);
    _attachedHost = null;
    return currentHost.detach();
  }

  /// Returns true if this portal is in the process of being attached but the
  /// host has not loaded it yet or if the host has already loaded it.
  ///
  /// Can be used to determine whether [detach] is required before [attach].
  /// TODO(google): If this is not used in public API, make it private.
  bool get isAttached => _attachedHost != null;

  void setAttachedHost(PortalHost host) {
    _attachedHost = host;
  }
}

/// A component, when attached, instantiates a new component of type [T].
class ComponentPortal<T> extends Portal<T> {
  /// Optionally define an origin.
  ///
  /// This is necessary in cases where you don't want the portal host to be the
  /// origin, instead, you want it to be some other location in your app.
  final ViewContainerRef origin;

  // TODO(google): Document and better explain when/when not to set origin.
  // TODO(google): Add optional `onInitialize` callback/future.
  ComponentPortal([this.origin]);

  @override
  ComponentPortal<T> clone() => new ComponentPortal<T>(origin);

  /// The type of component that will be created.
  Type get component => T;
}

/// A part of a template, when attached, becomes live as part of the host.
class TemplatePortal extends Portal<Map<String, dynamic>> {
  Map<String, dynamic> _locals = const {};

  /// The template this portal originated from.
  final TemplateRef template;

  /// The ViewContainerRef this portal originated from.
  final ViewContainerRef viewContainer;

  // TODO(google): Add optional locals map initialization.
  TemplatePortal(this.template, this.viewContainer) {
    assert(template != null);
    assert(viewContainer != null);
  }

  get origin => viewContainer;

  @override
  TemplatePortal clone() => new TemplatePortal(template, viewContainer);

  /// Attach to the [host], optionally with [locals] specific to this instance.
  @override
  Future<Map<String, dynamic>> attach(PortalHost host,
      [Map<String, dynamic> locals = const {}]) {
    _locals = locals;
    return super.attach(host);
  }

  @override
  Future detach() {
    _locals = const {};
    return super.detach();
  }

  /// Local variables that are defined for the context of this template.
  Map<String, dynamic> get locals => _locals;
}

/// A host container that can project a single [Portal] within.
abstract class PortalHost implements Disposable {
  /// Attaches [portal].
  ///
  /// Returns a future that completes when portal is attached with the context
  /// of the instantiated view. For components, this is an instance of the
  /// component. For views, it is a [Map] of locals.
  ///
  /// When possible, prefer using [Portal.attach], as it returns a typed result
  /// instead of [dynamic].
  Future attach(Portal portal);

  /// Detaches any active portal.
  ///
  /// Returns a future that completes when the existing portal is detached.
  Future detach();

  /// True if the host has a portal attached within.
  ///
  /// This may return true even if still waiting for asynchronous actions to
  /// process the attachment.
  bool get hasAttached;
}

/// A partial implementation of [PortalHost].
///
/// Implement [attachComponentPortal] and [attachTemplatePortal].
abstract class BasePortalHost implements PortalHost {
  Portal _attachedPortal;
  DisposeFunction _detachPortal;
  bool _isDisposed = false;

  @override
  Future attach(Portal portal) {
    assert(portal != null);
    if (_isDisposed) {
      throw new StateError('Already disposed.');
    }
    if (hasAttached) {
      throw new StateError('Already has attached portal!');
    }
    if (portal is ComponentPortal) {
      _attachedPortal = portal;
      return attachComponentPortal(portal);
    } else if (portal is TemplatePortal) {
      _attachedPortal = portal;
      return attachTemplatePortal(portal);
    } else if (portal == null) {
      throw new ArgumentError.notNull('portal');
    } else {
      throw new ArgumentError.value(portal.runtimeType, 'portal');
    }
  }

  Future<ComponentRef> attachComponentPortal(ComponentPortal portal);

  Future<Map<String, dynamic>> attachTemplatePortal(TemplatePortal portal);

  @Deprecated('No longer supported')
  static Map<String, dynamic> createLocalsMap(ViewRef viewRef) => {};

  @override
  Future detach() {
    _attachedPortal.setAttachedHost(null);
    _attachedPortal = null;
    if (_detachPortal != null) {
      _detachPortal();
      _detachPortal = null;
    }
    return new Future.value();
  }

  @override
  void dispose() {
    if (hasAttached) {
      detach();
    }
    _isDisposed = true;
  }

  @override
  bool get hasAttached => _attachedPortal != null;

  void setPortalDisposer(DisposeFunction fn) {
    assert(_detachPortal == null);
    _detachPortal = fn;
  }
}

/// A delegating implementation of [PortalHost].
class DelegatingPortalHost implements PortalHost {
  final PortalHost _delegateHost;

  DelegatingPortalHost(this._delegateHost);

  @override
  bool get hasAttached => _delegateHost.hasAttached;

  @override
  Future attach(Portal portal) => _delegateHost.attach(portal);

  @override
  Future detach() => _delegateHost.detach();

  @override
  void dispose() {
    _delegateHost.dispose();
  }
}

/// An implementation of [PortalHost] as an Angular 2 template directive.
///
/// For example:
///     <template portalHost="portal"></template>
@Directive(selector: '[portalHost]')
class PortalHostDirective extends BasePortalHost {
  final SlowComponentLoader _dynamicComponentLoader;
  final ViewContainerRef _viewContainerRef;

  PortalHostDirective(this._dynamicComponentLoader, this._viewContainerRef);

  @override
  Future<ComponentRef> attachComponentPortal(ComponentPortal portal) {
    // By default, use the portal host as the origin. If [portal.origin] is set
    // however, then use that.
    portal.setAttachedHost(this);
    var viewContainerRef = _viewContainerRef;
    if (portal.origin != null) {
      viewContainerRef = portal.origin;
    }
    return _dynamicComponentLoader
        .loadNextToLocation(portal.component, viewContainerRef)
        .then((ref) {
      setPortalDisposer(ref.destroy);
      return ref.instance;
    });
  }

  @override
  Future<Map<String, dynamic>> attachTemplatePortal(TemplatePortal portal) {
    portal.setAttachedHost(this);
    final viewRef = _viewContainerRef.createEmbeddedView(portal.template);
    portal.locals.forEach(viewRef.setLocal);
    setPortalDisposer(_viewContainerRef.clear);
    return new Future.value(BasePortalHost.createLocalsMap(viewRef));
  }

  @Input('portalHost')
  set portal(Portal portal) {
    if (hasAttached) {
      detach().then((_) {
        if (portal != null) {
          attach(portal);
        }
      });
    } else {
      // Null signifies just detach any existing portal, do not attach anything.
      if (portal != null) {
        attach(portal);
      }
    }
  }
}

/// An implementation of [PortalHost] that has an arbitrary DOM node as its
/// container.
class DomPortalHost extends BasePortalHost {
  final HtmlElement _hostElement;
  final AcxImperativeViewUtils _imperativeViewUtils;

  DomPortalHost(this._hostElement, this._imperativeViewUtils);

  @override
  Future<ComponentRef> attachComponentPortal(ComponentPortal portal) {
    if (portal.origin == null) {
      throw new StateError('A component hosted in a DomPortalHost must '
          'have an `origin` set, since the DOM element itself '
          'is not an Angular component.');
    }
    return _imperativeViewUtils
        .insertAngularComponent(portal.component, portal.origin, _hostElement)
        .then((ref) {
      setPortalDisposer(ref.destroy);
      return ref.instance;
    });
  }

  @override
  Future<Map<String, dynamic>> attachTemplatePortal(TemplatePortal portal) {
    return _imperativeViewUtils
        .insertAngularView(_hostElement, portal.template, portal.viewContainer)
        .then((ref) {
      portal.locals.forEach(ref.viewRef.setLocal);
      setPortalDisposer(ref.dispose);
      return BasePortalHost.createLocalsMap(ref.viewRef);
    });
  }
}

typedef void OnTemplatePortalReady(TemplatePortal portal);

/// An implementation of [TemplatePortal] as an Angular directive.
///
/// Example:
///     <template portal (ready)="onReady($event)">
///       Hello {{name}}!
///     </template>
@Directive(selector: '[portal]')
class TemplatePortalDirective extends TemplatePortal {
  @Output()
  Stream<TemplatePortalDirective> get ready => _ready.stream;
  final _ready = new StreamController.broadcast();

  TemplatePortalDirective(
      TemplateRef templateRef, ViewContainerRef viewContainerRef)
      : super(templateRef, viewContainerRef) {
    // TODO(google): Consider a better or standard pattern for this.
    scheduleMicrotask(() {
      _ready.add(this);
    });
  }
}
