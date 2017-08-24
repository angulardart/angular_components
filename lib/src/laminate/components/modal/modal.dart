// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';

import '../../../components/content/deferred_content_aware.dart';
import '../../../model/action/async_action.dart';
import '../../../utils/disposer/disposer.dart';
import '../../overlay/overlay.dart';
import 'src/modal_controller_directive.dart';

/// May be added to DI to enforce that a single [Modal] is visible at a time.
///
/// Creates a stack of modals, hiding the previous one when a new is shown.
///
/// __Example use__:
///     bootstrap(MyApp, const [GlobalModalStack]);
///
/// **NOTE**: Usage of this removes [Modal]'s built in LIFO stack.
@Injectable()
class GlobalModalStack {
  final List<Modal> _stack = new List<Modal>();

  /// Should be triggered when [modal] is closed.
  void onModalClosed(Modal modal) {
    assert(_stack.last == modal);
    if (_stack.last == modal) {
      _stack.removeLast();
      if (_stack.isNotEmpty) {
        _stack.last.hidden = false;
      }
    } else {
      _stack.remove(modal);
    }
  }

  /// Should be triggered when [modal] is opened.
  void onModalOpened(Modal modal) {
    if (_stack.isNotEmpty) {
      _stack.last.hidden = true;
    }
    _stack.add(modal);
  }
}

/// An ADT that can be injected by content that lives within a modal.
abstract class Modal {
  /// Attempts to close the modal.
  ///
  /// Returns a future that completes with `true` if it succeeds.
  Future<bool> close();

  /// Events that fires before making [visible] `false`.
  ///
  /// See [AsyncAction] for the API for deferring or cancelling the event.\
  @Output('close')
  Stream<AsyncAction> get onClose;

  /// Attempts to open the modal.
  ///
  /// Returns a future that completes with `true` if it succeeds.
  Future<bool> open();

  /// Events that fire before making [visible] `true`.
  ///
  /// See [AsyncAction] for the API for deferring or cancelling the event.
  @Output('open')
  Stream<AsyncAction> get onOpen;

  /// A stream of click events on the modal.
  ///
  /// Only is active if [preventInteraction] is `true`.
  @Output()
  Stream get shieldClick;

  /// Whether the modal is visible in the DOM.
  ///
  /// **NOTE**: It is possible it is temporarily [hidden] if another modal has
  /// taken over but still reports `true` for visible.
  bool get visible;

  /// Events that fire when [visible] changes.
  @Output('visibleChange')
  Stream<bool> get onVisibleChanged;

  /// Whether the modal is temporarily hidden.
  bool get hidden;

  /// Change the temporary visibility of the modal.
  set hidden(bool hidden);
}

/// A transcluding component that hosts inner content in a centered overlay.
///
/// A `<modal>` that is created within the context of another `<modal>` (nested)
/// automatically forms a LIFO-stack in-which the newest modal is shown and the
/// previous modals are not. Once the newest modal is dismissed, the next newest
/// will be shown.
///
/// Modals are [DeferredContentAware]. Use `*deferredContent` to avoid having
/// costly inner-content be created before the modal is visible.
///
/// If [preventInteraction] is `true` (it is by default), interaction with the
/// rest of the application may be disabled until the dialog is closed.
///
/// __Example usage__:
///     <!-- With aggressive content -->
///     <modal [preventInteraction]="isModal" ([visible])="showDialog">
///       Hello World!
///     </modal>
///
///     <!-- Or, with deferred content -->
///     <modal ([visible])="showDialog">
///       <template deferredContent>
///         <expensive-component></expensive-component>
///       </template>
///     </modal>
///
/// __Events__:
///     `open`: Fires whenever the modal is opening (before visibility).
///     `close`: Fires whenever the modal is closing (before visibility).
///     `visible`: Fires whenever visibility changes.
///     `shieldClick`: Fires whenever the modal background is pressed.
///
/// __Properties__:
///     `preventInteraction`: Set to false to allow interaction with your app.
///     `visible`: Set in order to change visibility. This will trigger an open
///                and close interaction cycle that allows users to cancel.
@Component(
  selector: 'modal',
  host: const {'[attr.pane-id]': 'uniquePaneId'},
  providers: const [
    const Provider(DeferredContentAware, useExisting: ModalComponent),
    const Provider(Modal, useExisting: ModalComponent)
  ],
  directives: const [ModalControllerDirective],
  template: r'''
    <template [modalController]="resolvedOverlayRef">
      <ng-content></ng-content>
    </template>
  ''',
)
class ModalComponent implements DeferredContentAware, Modal, OnDestroy {
  final Modal _parentModal;
  final GlobalModalStack _stack;

  @override
  Stream<AsyncAction> get onOpen => _onOpen.stream;
  final _onOpen = new StreamController<AsyncAction>.broadcast(sync: true);

  @override
  Stream<AsyncAction> get onClose => _onClose.stream;
  final _onClose = new StreamController<AsyncAction>.broadcast(sync: true);

  @override
  Stream<bool> get onVisibleChanged => _onVisibleChanged.stream;
  final _onVisibleChanged = new StreamController<bool>.broadcast(sync: true);

  final Disposer _disposer = new Disposer.oneShot();

  bool _isDestroyed = false;
  bool _isHidden = false;
  bool _isVisible = false;
  OverlayRef _resolvedOverlayRef;

  Future<bool> _pendingOpen;
  Future<bool> _pendingClose;

  ModalComponent(OverlayService overlayService,
      @Optional() @SkipSelf() this._parentModal, @Optional() this._stack) {
    _createdOverlayRef(
        overlayService.createOverlayRefSync(OverlayState.Dialog));
  }

  @Input()
  set preventInteraction(bool preventInteraction) {
    _resolvedOverlayRef.state.captureEvents = preventInteraction != false;
  }

  @override
  void ngOnDestroy() {
    _isDestroyed = true;
    _disposer.dispose();
  }

  void _createdOverlayRef(OverlayRef overlayRef) {
    // If the modal is closed before the overlay is created we should dispose
    // the ref to avoid leaks since `onDestroy` was already called.
    if (_isDestroyed) {
      overlayRef.dispose();
    } else {
      _resolvedOverlayRef = overlayRef;
      _disposer
        ..addDisposable(_resolvedOverlayRef)
        ..addStreamSubscription(_resolvedOverlayRef.onVisibleChanged
            .listen(_onOverlayVisibleChanged));
    }
  }

  // A callback received when the overlay reports a visibility change.
  void _onOverlayVisibleChanged(bool isVisible) {
    _isVisible = isVisible;
    _onVisibleChanged.add(_isVisible);
  }

  @override
  Stream get shieldClick => _resolvedOverlayRef.onPanePressed
      .where((MouseEvent e) => e.eventPhase == Event.AT_TARGET);

  @override
  Stream<bool> get contentVisible => onVisibleChanged;

  OverlayRef get resolvedOverlayRef => _resolvedOverlayRef;

  String get uniquePaneId => _resolvedOverlayRef?.uniqueId;

  // Make the overlay hosting this modal visible.
  //
  // If it has a parent, we should temporarily hide it.
  void _showModalOverlay({bool temporary: false}) {
    if (!temporary) {
      if (_stack != null) {
        _stack.onModalOpened(this);
      } else if (_parentModal != null) {
        _parentModal.hidden = true;
      }
    }
    _resolvedOverlayRef.setVisible(true);
  }

  // Make the overlay hosting this modal hidden.
  //
  // If it has a parent, we should re-show it.
  void _hideModalOverlay({bool temporary: false}) {
    if (!temporary) {
      if (_stack != null) {
        _stack.onModalClosed(this);
      } else if (_parentModal != null) {
        _parentModal.hidden = false;
      }
    }
    _resolvedOverlayRef.setVisible(false);
  }

  @override
  Future<bool> open() {
    if (_pendingOpen == null) {
      final controller = new AsyncActionController();
      controller.execute(_showModalOverlay);
      _pendingOpen = controller.action.onDone.then((completed) {
        _pendingOpen = null;
        return completed;
      });
      _onOpen.add(controller.action);
    }
    return _pendingOpen;
  }

  @override
  Future<bool> close() {
    if (_pendingClose == null) {
      final controller = new AsyncActionController();
      controller.execute(_hideModalOverlay);
      _pendingClose = controller.action.onDone.then((completed) {
        _pendingClose = null;
        return completed;
      });
      _onClose.add(controller.action);
    }
    return _pendingClose;
  }

  @override
  bool get visible => _isVisible;
  @Input()
  set visible(bool visible) {
    if (_isVisible == visible || _isDestroyed) return;
    if (visible == true) {
      open();
    } else {
      close();
    }
  }

  @override
  bool get hidden => _isHidden;

  @override
  set hidden(bool hidden) {
    _isHidden = hidden;
    if (_isHidden) {
      _hideModalOverlay(temporary: true);
    } else {
      _showModalOverlay(temporary: true);
    }
  }
}
