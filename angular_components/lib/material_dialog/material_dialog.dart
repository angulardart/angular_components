// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_components/focus/focus_trap.dart';
import 'package:angular_components/laminate/components/modal/modal.dart';
import 'package:angular_components/utils/browser/dom_service/dom_service.dart';
import 'package:angular_components/utils/disposer/disposer.dart';

/// A styled container following the Material Spec for Dialogs.
///
/// __Supported Content:__
///
/// - `[header]` -- Header content for the dialog.
/// - `[footer]` -- Footer content for the dialog.
///
/// __Attributes:__
///
///  - `headered` -- Adds a gray background to the dialog header.
///  - `info` -- Styles the dialog as an info dialog.
///
@Component(
  selector: 'material-dialog',
  templateUrl: 'material_dialog.html',
  styleUrls: ['material_dialog.scss.css'],
  directives: [FocusTrapComponent, NgIf],
  changeDetection: ChangeDetectionStrategy.OnPush,
)
class MaterialDialogComponent implements AfterContentChecked, OnDestroy {
  final HtmlElement _rootElement;
  final DomService _domService;
  final ChangeDetectorRef _changeDetector;
  final ModalComponent _modal;
  final _disposer = Disposer.oneShot();

  HtmlElement _mainElement;
  bool _shouldShowHeader = true;
  bool _shouldShowFooter = true;
  bool shouldShowTopScrollStroke = false;
  bool shouldShowBottomScrollStroke = false;

  final _isInFullscreenModeStreamController = StreamController<bool>();
  bool _isInFullscreenMode;
  bool _shouldListenForFullscreenChanges = false;

  MaterialDialogComponent(this._rootElement, this._domService,
      this._changeDetector, @Optional() this._modal);

  @ViewChild('main', read: HtmlElement)
  set main(HtmlElement element) {
    _mainElement = element;
    _disposer.addStreamSubscription(element.onScroll.listen((_) {
      _setHeaderFooterScrollBorder();
    }));
    if (_modal == null) return;
    _disposer.addStreamSubscription(_modal.onOpen.listen((_) {
      _setHeaderFooterScrollBorder();
    }));
  }

  /// Error to show up in the error section of the dialog.
  @Input()
  String error;

  /// Whether to hide the dialog header.
  @Input()
  set hideHeader(bool shouldHideHeader) =>
      _shouldShowHeader = !shouldHideHeader;

  /// Whether to hide the dialog footer.
  @Input()
  set hideFooter(bool shouldHideFooter) =>
      _shouldShowFooter = !shouldHideFooter;

  bool get shouldShowHeader => _shouldShowHeader;

  bool get shouldShowFooter => _shouldShowFooter;

  /// Whether to show the top/bottom borders on the <main> part of the dialog to
  /// indicate whether there is more content that the user can reach by
  /// scrolling.
  @Input()
  bool shouldShowScrollStrokes = true;

  void _setHeaderFooterScrollBorder() {
    if (!shouldShowScrollStrokes) return;
    _disposer.addDisposable(_domService.scheduleRead(() {
      var shouldShowTopScrollStroke =
          _mainElement.scrollTop > 0 && error == null;
      var shouldShowBottomScrollStroke =
          _mainElement.clientHeight < _mainElement.scrollHeight &&
              _mainElement.scrollTop <
                  _mainElement.scrollHeight - _mainElement.clientHeight;
      if (shouldShowTopScrollStroke != this.shouldShowTopScrollStroke ||
          shouldShowBottomScrollStroke != this.shouldShowBottomScrollStroke) {
        this.shouldShowTopScrollStroke = shouldShowTopScrollStroke;
        this.shouldShowBottomScrollStroke = shouldShowBottomScrollStroke;
        _changeDetector
          ..markForCheck()
          // This detectChanges() here is for updating the classes when the page
          // initially loads.
          ..detectChanges();
      }
    }));
  }

  /// Determines whether to listen for when the dialog enters or exits
  /// fullscreen mode.
  @Input('listenForFullscreenChanges')
  set shouldListenForFullscreenChanges(bool shouldListenForFullscreenChanges) {
    // Don't do anything if [shouldListenForFullscreenChanges] is set to false.
    if (!shouldListenForFullscreenChanges) return;

    // If [_shouldListenForFullscreenChanges] is set to true, then that means
    // that we're already listening to fullscreen changes, so don't do anything.
    if (_shouldListenForFullscreenChanges) return;

    _shouldListenForFullscreenChanges = shouldListenForFullscreenChanges;
    _disposer.addStreamSubscription(window.onResize.listen((_) {
      _listenForFullscreenChanges();
    }));
  }

  /// Stream for when the dialog enters or exits fullscreen mode.
  @Output('fullscreenMode')
  Stream<bool> get isInFullscreenMode =>
      _isInFullscreenModeStreamController.stream;

  void _listenForFullscreenChanges() {
    if (!_shouldListenForFullscreenChanges) return;
    _disposer.addDisposable(
        _domService.scheduleRead(_updateForFullscreenChangesInsideDomReadLoop));
  }

  void _updateForFullscreenChangesInsideDomReadLoop() {
    final isInFullscreenMode =
        document.body.clientWidth <= _rootElement.clientWidth &&
            document.body.clientHeight <= _rootElement.clientHeight;
    if (_isInFullscreenMode != isInFullscreenMode) {
      _isInFullscreenMode = isInFullscreenMode;
      _isInFullscreenModeStreamController.add(isInFullscreenMode);
    }
  }

  @override
  void ngAfterContentChecked() {
    if (_shouldListenForFullscreenChanges) {
      _updateForFullscreenChangesInsideDomReadLoop();
    }

    // This adds or removes the scroll border when the content within the <main>
    // element has changed.
    _setHeaderFooterScrollBorder();
  }

  @override
  void ngOnDestroy() {
    _disposer.dispose();
  }
}
