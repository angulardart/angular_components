// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:intl/intl.dart';
import 'package:quiver/time.dart';
import 'package:angular_components/button_decorator/button_decorator.dart';
import 'package:angular_components/content/deferred_content.dart';
import 'package:angular_components/focus/focus_trap.dart';
import 'package:angular_components/focus/keyboard_only_focus_indicator.dart';
import 'package:angular_components/glyph/glyph.dart';
import 'package:angular_components/laminate/enums/alignment.dart';
import 'package:angular_components/laminate/popup/popup.dart';
import 'package:angular_components/material_button/material_button.dart';
import 'package:angular_components/material_datepicker/comparison.dart';
import 'package:angular_components/material_datepicker/date_range_editor.dart';
import 'package:angular_components/material_datepicker/module.dart';
import 'package:angular_components/material_datepicker/next_prev_buttons.dart';
import 'package:angular_components/material_datepicker/preset.dart';
import 'package:angular_components/material_datepicker/range.dart';
import 'package:angular_components/material_popup/material_popup.dart';
import 'package:angular_components/material_select/dropdown_button.dart';
import 'package:angular_components/model/a11y/keyboard_handler_mixin.dart';
import 'package:angular_components/model/date/date.dart';
import 'package:angular_components/model/date/date_formatter.dart';
import 'package:angular_components/model/observable/observable.dart';
import 'package:angular_components/utils/angular/properties/properties.dart';
import 'package:angular_components/utils/browser/dom_service/dom_service.dart';
import 'package:angular_components/utils/disposer/disposer.dart';

/// A material-design-styled date range picker.
///
/// Users can choose preset date ranges, type in custom date ranges, or select
/// ranges by playing around with the calendar.
///
/// When a user types in a date, dates with 2-digit years are handled specially.
/// E.g. 7/7/77 is interpreted as July 7, 1977, not July 7, 77. This logic looks
/// 20 years into the future: right now (August 2015), "35" is interpreted as
/// 2035 but "36" is interpreted as "1936". Next year, "36" will start to be
/// interpreted as 2036.
///
///
/// __Example usage:__
///
///     <material-date-range-picker [(range)]="range"
///                                 [presets]="presets">
///     </material-date-range-picker>
///
/// Since a primary use of this picker is for a global per-app date range, this
/// component can also read from and write to an [ObservableReference] instance.
/// (The [DatepickerModel] class is also provided to make using it easier in
/// dependency injection.)
///
///     <material-date-range-picker [reference]="observableReference"
///                                 [presets]="presets">
///     </material-date-range-picker>
///
@Component(
  selector: 'material-date-range-picker',
  styleUrls: const ['material_date_range_picker.scss.css'],
  templateUrl: 'material_date_range_picker.html',
  host: const {
    '[class.compact]': 'compact',
    '[class.disabled]': 'disabled',
  },
  directives: const [
    ButtonDirective,
    DateRangeEditorComponent,
    DeferredContentDirective,
    DropdownButtonComponent,
    GlyphComponent,
    KeyboardOnlyFocusIndicatorDirective,
    MaterialButtonComponent,
    MaterialPopupComponent,
    NextPrevComponent,
    NgIf,
    PopupSourceDirective,
    FocusTrapComponent,
  ],
  providers: const [
    const Provider(DateRangeEditorHost,
        useExisting: MaterialDateRangePickerComponent)
  ],
  // TODO(google): Change to `Visibility.local` to reduce code size.
  visibility: Visibility.all,
)
class MaterialDateRangePickerComponent extends KeyboardHandlerMixin
    implements OnInit, OnDestroy, DateRangeEditorHost {
  DateRangeEditorComponent _dateRangeEditor;
  bool _focusOnDateRangeEditorInit = false;

  List<RelativePosition> get overlapAlignments =>
      RelativePosition.overlapAlignments;

  /// A list of predefined date ranges which the user can choose from.
  ///
  /// These are subject to clamping by `minDate` and `maxDate`, and are excluded
  /// entirely if their end point is before `minDate` or their start point is
  /// after `maxDate`.
  // TODO(google): Eventually these should be `DateRangeOption`s or
  // something, which take in a clock and return a DatepickerDateRange
  @Deprecated('Use [presets] instead.')
  @Input('predefinedRanges')
  set predefinedRanges(List<DatepickerDateRange> ranges) {
    presets =
        ranges.map((range) => new DatepickerPreset.fromRange(range)).toList();
  }

  /// A list of preset date ranges which the user can choose from.
  ///
  /// These are subject to clamping by `minDate` and `maxDate`, and are excluded
  /// entirely if their end point is before `minDate` or their start point is
  /// after `maxDate`.
  @Input()
  List<DatepickerPreset> presets = [];

  /// Whether or not this date range picker supports clearing date range.
  ///
  /// Default to false.
  @Input('supportsClearRange')
  bool supportsClearRange = false;

  /// Whether or not this date range picker supports choosing custom range.
  ///
  /// Calendar will be hidden when custom range is not supported. Custom range
  /// should be supported in "fullyLoaded" or "basic" mode.

  bool get supportsCustomRange =>
      configuration == DateRangePickerConfiguration.fullyLoaded ||
      configuration == DateRangePickerConfiguration.basic;

  /// Whether or not this date range picker is basic.
  ///
  /// Under 'basic' configuration. Only show pre-defined list initially.
  /// When "Custom" date range is selected, .right-column will be shown and
  /// pre-defined list will be hidden.
  bool get isBasic => configuration == DateRangePickerConfiguration.basic;

  /// Whether to use [LastNDaysToTodayRange] to represent "N days up to today".
  @Input('relativeDaysToToday')
  bool relativeDaysToToday = false;

  /// Date range picker configuration.
  ///
  /// Custom range picker and calendar will be hidden when [configuration] is
  /// [DateRangePickerConfiguration.predefinedRangesOnly].
  ///
  /// Defaults to [DateRangePickerConfiguration.fullyLoaded].
  @Input('configuration')
  DateRangePickerConfiguration configuration =
      DateRangePickerConfiguration.fullyLoaded;

  /// An [ObservableReference] of a date range.
  ///
  /// This can be used if it's more convenient to mutate something in-place
  /// instead of getting and setting new date range values. (E.g. the global
  /// date range in CM).
  @Input('reference')
  ObservableReference<DatepickerComparison> selection =
      new ObservableReference(null);

  /// Whether or not this date range picker supports choosing time comparison
  /// ranges.
  ///
  /// If [configuration] is [DateRangePickerConfiguration.predefinedRangesOnly],
  /// comparison is not supported.
  ///
  /// Defaults to true.
  @Input()
  set supportsComparison(value) {
    _supportsComparison = getBool(value);
    if (!supportsComparison && selection.value?.comparison != null) {
      selection.value =
          new DatepickerComparison.noComparison(selection.value.range);
    }
  }

  bool get supportsComparison => _supportsComparison;

  bool _supportsComparison = true;

  /// Whether or not to show the next and previous buttons.
  ///
  /// Defaults to true.
  @Input()
  set showNextPrevButtons(value) {
    _showNextPrevButtons = getBool(value);
  }

  bool get showNextPrevButtons => _showNextPrevButtons;

  bool _showNextPrevButtons = true;

  /// Whether or not this date range picker includes a section to input 'N days
  /// to today' and 'N days to yesterday' ranges.
  ///
  /// Defaults to `true`.
  @Input()
  set supportsDaysInputs(value) {
    _supportsDaysInputs = getBool(value);
  }

  bool get supportsDaysInputs => _supportsDaysInputs;

  bool _supportsDaysInputs = true;

  /// Whether to enable compact calendar styles.
  @Input()
  set compact(value) {
    _compact = getBool(value);
  }

  bool get compact => _compact;

  bool _compact = !window.matchMedia("(pointer: coarse)").matches;

  /// The label for the 'Apply' button. Set this variable only if you want a
  /// different label other than 'Apply'. If set, the input label should be
  /// internationalized.
  @Input()
  String applyButtonLabel;

  /// Whether changing the selected date range should be disabled.
  @Input()
  set disabled(value) {
    _disabled = getBool(value);
    // Hide popup if visible.
    if (_popupVisible && disabled) close();
  }

  bool _disabled = false;
  bool get disabled => _disabled;

  /// Dates earlier than `minDate` cannot be chosen.
  ///
  /// Defaults to January 1, ten years ago. Set this to the earliest date which
  /// makes sense in your domain context.  e.g. The earliest date for which data
  /// is available for analysis. Changes to `minDate` are only applied to the
  /// selected `range' when the user reopens the popup.
  @Input()
  set minDate(Date date) {
    _minDate = date;
    model.minDate = _minDate;
  }

  Date get minDate => _minDate;
  Date _minDate;

  /// Dates later than `maxDate` cannot be chosen.
  ///
  /// Defaults to December 31, ten years in the future. Set this to the latest
  /// date which makes sense in your domain context. e.g. For apps which analyse
  /// historical data, this could be the current day.  Changes to `maxDate` are
  /// only applied to the selected `range' when the user reopens the popup.
  @Input()
  set maxDate(Date date) {
    _maxDate = date;
    model.maxDate = _maxDate;
  }

  Date get maxDate => _maxDate;
  Date _maxDate;

  /// When 'requireFullPeriods' is true, 'prev/next' button will be disabled
  /// if previous or next period is not a full predefined period, like 'week'.
  @Input()
  set requireFullPeriods(bool requireFullPeriods) {
    model.requireFullPeriods = requireFullPeriods;
  }

  bool get requireFullPeriods => model.requireFullPeriods;

  /// An error displayed below the dropdown button.
  @Input()
  String error;

  /// A placeholder message to display if no date range is selected.
  @Input()
  set placeHolderMsg(String msg) {
    if (msg == null) return;
    _customPlaceHolderMsg = msg;
  }

  String get placeHolderMsg => _customPlaceHolderMsg ?? _placeHolderMsg;
  String _customPlaceHolderMsg;

  @ViewChild('focusOnClose')
  KeyboardOnlyFocusIndicatorDirective focusOnClose;

  final model = new DateRangeEditorModel();
  ModelState _lastState;

  bool _popupVisible = false;
  bool applyBarVisible = false;

  // This defers date-range-editor initialization.
  // It's not initialized until the user intends to open the picker.
  bool _isEditorCreated = false;
  bool get isEditorCreated => _isEditorCreated;

  // This splits calendar init from the popup animation,
  // which lets the popup animate while the calendar initializes.
  bool _isCalendarCreated = false;
  bool get isCalendarCreated => _isCalendarCreated;

  bool allowHighlightUpdates = true;

  /// Whether an apply is in progress. Determines whether model changes are
  /// saved or canceled when the popup is closed.
  bool _isApplying = false;

  Disposer _disposer = new Disposer.oneShot();

  DatepickerComparison get range => selection.value;

  /// The selected date range and comparison.
  ///
  /// This datepicker uses [DatepickerComparison] instead of plain
  /// [DateRangeComparison] objects -- this internal implementation adds extra
  /// needed features like names and next/prev support.
  @Input()
  set range(DatepickerComparison cmp) {
    selection.value = _maybeStripComparison(cmp);
  }

  /// Published when the selected date range or comparison range changes.
  @Output()
  Stream<DatepickerComparison> get rangeChange => selection.stream;

  /// Published when the datepicker popup starts opening or closing.
  @Output('popupVisible')
  Stream<bool> get onPopupVisible => _onPopupVisible.stream;
  final _onPopupVisible = new StreamController<bool>.broadcast();

  final DomService _domService;
  final NgZone _ngZone;

  MaterialDateRangePickerComponent(
      @Optional() @Inject(datepickerClock) Clock clock,
      Clock legacyClock,
      this._domService,
      this._ngZone) {
    // TODO(google): Migrate to use only datepickerClock
    clock ??= legacyClock;

    // Init minDate and maxDate to sensible defaults
    var now = clock.now();
    minDate = new Date(now.year - 10, DateTime.JANUARY, 1);
    maxDate = new Date(now.year + 10, DateTime.DECEMBER, 31);
  }

  @override
  void ngOnInit() {
    model
      ..minDate = minDate
      ..maxDate = maxDate
      ..requireFullPeriods = requireFullPeriods
      ..basic = isBasic;
    if (selection.value != null)
      model.value = _maybeStripComparison(selection.value);
    _disposer.addFunction(model.dispose);

    _needsApply(modelValue) =>
        modelValue != selection.value || !_isPreset(modelValue);

    // Wire the internal model and the external value up to each other.
    _updateFormattedRanges(selection.value);
    _disposer
      ..addDisposable(selection.stream.listen((v) {
        model.value = _maybeStripComparison(v);
        _updateFormattedRanges(v);
      }))
      ..addDisposable(model.changes
          .map((v) => v.date)
          .map(_needsApply)
          .listen(_showApplyBar))
      ..addDisposable(model.changes
          .where((_) => !_popupVisible) // handle next/prev buttons while closed
          .listen((v) => selection.value = v.date));
  }

  @override
  void ngOnDestroy() => _disposer.dispose();

  @ViewChild(MaterialPopupComponent)
  MaterialPopupComponent popup;

  /// Open the datepicker popup.
  void open() {
    if (_popupVisible || disabled) return;

    _popupVisible = true;
    _onPopupVisible.add(true);
    popup.open();

    // Initialize the date-range-editor (if it hasn't been already).
    initEditor();

    // This is deferred twice so that the popup animation starts in
    // the next animation frame, and the date range editor init starts
    // after that. The result is that the popup animates open while the
    // date picker is initializing, rather than after it has finished
    // initializing.
    _domService.nextFrame.then((_) {
      _domService.nextFrame.then((_) {
        // Double-check that the popup is still opening.
        if (!_popupVisible) return;

        _ngZone.run(() {
          allowHighlightUpdates = true;
          _showApplyBar(!_isPreset(selection.value));
          _lastState = model.save();

          // Reapply min/maxDate in case they changed while the popup was
          // closed.  Changes to minDate/maxDate are deliberately not processed
          // earlier than this, because that might cause the selection to change
          // without user interaction, which is a bad user experience.  As a
          // general rule, the selection should only change as the direct and
          // immediate result of an action performed by the user.
          model.value =
              new DatepickerComparison.reclamp(model.value, minDate, maxDate);
          model.minDate = minDate;
          model.maxDate = maxDate;

          _initCalendar();
          setFocusToDateRangeEditor();
        });
      });
    });
  }

  /// Close the datepicker popup.
  void close() {
    if (!_popupVisible) return;

    _popupVisible = false;
    _onPopupVisible.add(false);
    popup.close();

    _domService.nextFrame.then((_) {
      // Double-check that the popup is still closing.
      if (_popupVisible) return;

      _ngZone.run(() {
        // Cancel changes if apply isn't in progress.
        if (!_isApplying) {
          model.restore(_lastState);
          selection.value = _lastState.value;
          _showApplyBar(!_isPreset(_lastState.value));
        }
        _isApplying = false;
      });
    });
  }

  @override
  void handleEscapeKey(KeyboardEvent event) {
    close();
    focusOnClose.focus();
  }

  /// Whether or not the given range is "complicated" -- i.e. if it has a
  /// comparison or a custom range.
  bool _isPreset(DatepickerComparison cmp) =>
      cmp?.comparison == null && cmp?.range?.isPredefined == true;

  void _showApplyBar(bool b) {
    applyBarVisible = b;
  }

  void onRangeClicked(UIEvent event) {
    // Close eagerly for preset ranges and the cleared range.
    final shouldCloseEagerly = _isPreset(model.value) ||
        (model.value.range == null && model.value.comparison == null);
    if (shouldCloseEagerly) {
      // Don't render preset changes to the calendar while the popup is closing
      allowHighlightUpdates = false;
      apply(event);
    }
  }

  void apply(UIEvent event) {
    _isApplying = true;
    selection.value = model.value;
    close();
    focusOnClose.focus(event);
  }

  void cancel() {
    model.restore(_lastState);
    selection.value = _lastState.value;
    _showApplyBar(!_isPreset(_lastState.value));
    close();
    focusOnClose.focus();
  }

  bool get hasTitle => selection.value?.range?.title != null;
  String get rangeTitle => selection.value?.range?.title ?? '';

  String _formattedRange;
  String get formattedRange => _formattedRange;
  String _getFormattedRange(DatepickerComparison value) =>
      value?.range != null ? formatRange(value.range) : placeHolderMsg;

  bool get hasComparison => selection.value?.comparison != null;

  String _formattedComparison;
  String get formattedComparison => _formattedComparison;
  String _getFormattedComparison(DatepickerComparison value) =>
      _compareMsg(formatRange(value?.comparison));

  void _updateFormattedRanges(DatepickerComparison value) {
    _formattedRange = _getFormattedRange(value);
    _formattedComparison = _getFormattedComparison(value);
  }

  void dateRangeEditorCreated(DateRangeEditorComponent editor) {
    _dateRangeEditor = editor;
    if (_dateRangeEditor != null && _focusOnDateRangeEditorInit) {
      _focusOnDateRangeEditorInit = false;
      _dateRangeEditor.focus();
    }
  }

  void setFocusToDateRangeEditor() {
    if (_dateRangeEditor != null) {
      _dateRangeEditor.focus();
    } else {
      _focusOnDateRangeEditorInit = true;
    }
  }

  void initEditor() {
    _isEditorCreated = true;
  }

  void _initCalendar() {
    _isCalendarCreated = true;
  }

  /// Remove comparison range from a [DatepickerComparison] if that feature is
  /// not supported by this component instance.
  DatepickerComparison _maybeStripComparison(DatepickerComparison cmp) {
    if (cmp != null && cmp.isComparisonEnabled && !supportsComparison) {
      return new DatepickerComparison.noComparison(cmp.range);
    } else {
      return cmp;
    }
  }

  String get cancelButtonMsg => Intl.message('Cancel',
      meaning: 'Button in a date picker',
      desc: 'Label for a "cancel" button -- abandon the current date selection '
          'and go back to whatever it was before the user opened the date picker');

  String get applyButtonMsg => applyButtonLabel ?? _applyButtonMsg;

  String get _applyButtonMsg => Intl.message('Apply',
      name: '_applyButtonMsg',
      meaning: 'Button in a date picker',
      desc: 'Label for an "Apply" button -- accept and apply the date range '
          'seen in the date picker.');

  String _compareMsg(String to) => Intl.message('Compared: $to',
      name: '_compareMsg',
      desc: 'Indicates what date range the current date range is compared to',
      args: [to],
      examples: const {'to': 'Jul 21, 2014 - Aug 3, 2015'});

  String get _placeHolderMsg => Intl.message('Select a date range',
      name: '_placeHolderMsg',
      desc: 'Placeholder text for a date range picker with an empty range.');
}
