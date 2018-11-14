## 0.10.1

### Component Updates

#### Material Chips
* Improved support for generics.
* Stop setting popup attributes as those attributes are set on the input
  directly.
* Only set the `aria-owns` property and `inputAriaActivedescendent` when the
  popup is open.
* Add Sass mixin to allow text wrapping.

#### Material Date Picker
* Use `PopupSizeProvider` to control the height of the picker.
* Add `rangeFormatter` input to the range picker.

#### Material Expansion Panel
* Improve accessibility.
* Smooth expansion/collapse animations when headers are hidden.

#### Material Icon
* Add Sass mixin to use an SVG for an icon instead of the standard font icons.

#### Material Input
* Add Sass mixins to disable wrapping for hint text and hide leading and
  trailing text.
* Fix `MaterialPercentInputDirective` for LTR languages with leading % symbol.
* Fix inconsistent margins in Safari browser.

#### Material Menu
* Add ability to provide extra label annotations for menu items.

#### Material Select
* Add Sass mixins to restrict item width, font size, line height, and padding.
* Added generics support.
* Add `activateFirstOption` input.

#### Material Slider
* No longer focusable when disabled.

#### Material Stepper
* Ensure items that can't be selected also can't be tabbed to.

#### Material Tab
* Add Sass mixin for a shadow below the tab strip.

#### Material Tree
* Add a dynamic content to accommodate custom elements.

#### Material Toggle
* Update the theme Sass mixin to include a grey color when the toggle is
  disabled.

#### Material Tooltip
* Add Sass mixins to control padding, and max height.

#### Material Yes/No Buttons
* Allow No button to be disabled.

#### Modal/Overlay
* Add null guard check to event.
* A11y improvements.
* Attempt to restore focus when modal closes.

### Miscellaneous
* Update MDC Web styles to v0.40.0.
* Improved support for generics in `HighlightAssistant`.
* Handle unsupported `WheelEvent.deltaX` in scroll host.
* Update scroll host support on iOS.
* Allow dropdown components to contain an `auto_focus` directive.

### Documentation
* Minor docs fixes.

## 0.10.0

### Component Updates

#### Material Auto Suggest Input
* Rename `shouldClearOnSelection` to `shouldClearInputOnSelection`.
* Improve keyboard navigation after mouse interactions in the popup.
* Only allow deselection via in multi-selection mode in material auto suggest
  input.
* Disallow selecting disabled options via keyboard.
* Remove deprecated `suggestions` and `sorted` inputs.
* Update to support generics.

#### Material Button
* Mark certain fields as `visibleForTemplate` and drop the copied value where
  not needed.

#### Material Chips
* Add Sass mixins to adjust border and font size of a single chip and border
  padding, and background color, border, and padding of a set of chips.

#### Material Expansion Panel
* Wrap the buttons in a `defferredContent` directive. This is to help
  accessibility and have those buttons not be available for screen readers.

#### Material Input
* Fix bug in `MaterialNumberValueAccessor` where null value won't clear previous
  input.

#### Material Dropdown Select
* Provide the simplified selection and options inputs. Pull the common logic
  into SelectionInputAdapter mixin class.
* Migrate `ComponentRenderer` to `FactoryRenderer`.
* Disallow selecting disabled options via keyboard.
* Highlight disabled items when activated via keyboard.

#### Material Menu
* Add a secondary-label field. The appearance of this label is subject to minor
  changes in the near future as the UX is still experimental.
* Properly use the sub-menu's width, not the parent menu's width, to determine
  the width of the menu.

#### Material Radio
* Tighten down the public API surface of the radio component by marking many of
  them as `visibleForTemplate`.

#### Material Select Searchbox
* Add in null pointer protection when input is set without a filterable.

#### Modal/Overlay
* Enable useMultiModalDismissal by default.

### Miscellaneous
* Use typed provider for location providers.
* Also corrected the type signature of `runOutsideAngular`, which in turn may
  enable hint-level warnings by the analyzer. Users may be impacted if they fail
  the build on hints.
* Add `StickyController.onUpdate`, a stream which fires events immediately after
  `StickyController` writes to the DOM, and expose it as an output on
  `ElementScrollHost`.
* Trigger the sticky controller sync on `scrollToPosition` calls.

### Documentation
* Add new readme for Material Dropdown Select.
* Minor docs fixes.

## 0.9.2

### Component Updates

#### Material Auto Suggest Input
* Implement `HasDisabled`.
* Allow `selection` input to take selected value for single selection in
  addition to `SelectionModel`.
* Expose `selection` output to emit selected value(s) on selection changes.
* Add `shouldClearSelectionOnInput` input.

#### Material Button
* Remove unused `hover-color` argument from button color Sass mixins.

#### Material Datepicker
* Add Sass mixins for rendering the range title to the left of the dropdown
  component and for removing some padding to save vertical space.
* Harden `DatepickerComparison.comparesTo()` against nulls.

#### Material Expansion Panel
* Add transition to save/cancel collapse.
* Add Sass mixin for custom `box-shadow`.

#### Material Input
* Add Sass mixin to set the bottom section margins.
* Allow `MaterialPercentInputDirective` to follow `NumberFormat` specification
  for percent.
* Allow `selectionOptions` input to accept a `List` in addition to
  `SelectionOptions`.

#### Material Menu
* Remove Sass mixin `material-fab-menu-icon-size`.

#### Material Tooltip
* Change the ink tooltip stay open if the mouse is currently in it's bounds.

#### Material Tree
* Allows dropdown component to accept custom popup positions.
* Fix off-center alignment issue between radio button and text in
  `MaterialTreeGroupFlatRadioComponent`.

#### Scorecard
* Expose `ScorecardBarDirective` so it can be resued by other card bar
  implementations.

### Miscellaneous
* Improvements to `StickyController` for the __single-stickyKey case__: Add
  `enableSmoothPushing` setting, and partially support stickyKey'd elements of
  differing heights.
* Replace all deprecated Material typography variables/mixins with their
  canonical versions, and inline mixins with no replacement.
* Fix `unawaited_futures` lint warnings by adding missing `await`s.

### Documentation
* Add new readme for Material Auto-suggest Input.
* Minor docs fixes.

## 0.9.1

### Component Updates

#### Material Date Range Picker
* Add an option to disable maintaining the length of the date range when
  clicking on the calendar to move the start date.

#### Material Expansion Panel
* Add Sass mixin for border radius.
* Only register immediate child panels in a panel set.
* Add listener for expand change to fix bug where an expansion panel set would
  not recognize a programmatically pre-expanded panel.

#### Material Select
* Add Sass mixin for the selected item color.

#### Material Stepper
* Add Sass mixins for the step name color.

#### Material Toolip
* Add Sass mixin to set the card tooltip max width.
* Add an icon attribute to specify any icon by name.
* Add positioning options on icon tooltip.

#### Selection Options
* Add interface to segment options into option groups.

### Miscellaneous
* Fix `ActiveItemDirective`'s scroll into view functionality in popups and
  modals.
* Add `ObservableView.firstNonNull` and `ObservableView.nonNullValues`.
* Update MDC Web styles to v0.38.0.
* Fix missing return errors.
* Fix default line-height values to match MDC versions.

### Documentation
* Minor doc fixes.
* Cleanup some docs for with optional new/const.

## 0.9.0

> Pub _transformers_ are no longer used. Instead, use the new
> [webdev](https://pub.dartlang.org/packages/webdev) CLI, or, for advanced
> users, the [build_runner](https://pub.dartlang.org/packages/build_runner) CLI.
>
> Please see the Dart 2 [migration guide](https://webdev.dartlang.org/dart-2) for
> more details.

### Breaking Changes
* Remove `is SelectableWithComposition`.
* Remove `SelectableChangeNotifier` and deprecate `SelectableWithComposition`
  with the intention to remove. They are widely unused, complicated the
  implementations, and unsound in Dart 2.
* `ActiveItemMixin` has been removed in favor of the new `ActiveItemDirective`.

### New Components
* Material Card styling
  * Provided by the Google material team also known as mdc-web. The styles
    included in this package are provided as a convenience to users in the Dart
    package ecosystem.
* Material Stacking Drawer
* Material Stepper
* Material Slider
* Material Date/Time Picker components
* Material Menu components

### Component Updates

#### App Layout
* Update Material Header `z-index` to 1.
* Add support for 0 or 2 drawers.
* Add mixin for permanent/persistent drawers and fix mixin for temporary
  drawers.
* Add mixin for drawer width.
* Provide list-item changes as a mixin to be used in components that wrap drawer
  contents.

#### Button Decorator
* Allow role to be customized.

#### Material Auto-Suggest Input
* Improve keyboard navigation behavior.
* Prevent marking itself as dirty when it receives initial form value.
* Add aria label to close button.
* Wait for the popup to be visible before activating dropdown items.
* Stop escape keyboard events from propagating after they are handled.
* Disallow deselection when clicked on a selected item with single selection
  models.
* Ensure input text is initialized correctly regardless of input order.
* Fix auto-scrolling issue on Firefox.
* Add ability to give a tooltip for the clear icon.
* Replace `ngOnChanges()` with `ngAfterChanges()`.
* Protect against method being called after it is destroyed.

#### Material Button
* Update elevation on buttons that have focus.
* Remove styles for vertically aligned icon with text buttons.
* Update size and position of text labels for icon buttons.
* Allow icon button items to be created vertically.
* Remove override of `min-width` for `yes-no-buttons` as it is now the right
  value in material-button.
* Update highlight styling.
* Add compact mode.
* Update min-width to new spec.
* Update dense mixin to only apply to non-icon buttons.
* Add mixins for no hover highlight.
* Add mixins to set icon button padding.
* Update hover, focus, and disabled styles to be inline with Material Spec.
* Update mixin names and fix to prevent styles leaking outside of the component.

#### Material Checkbox
* Remove deprecated `material-checkbox-theme` mixin.
* Add `material-checkbox-color` mixin and deprecate `material-checkbox-theme`.
* Change `include-in-checkbox` default to false in `checkbox-color` mixin to
  prepare for it's removal.
* Migrate from the deprecated Glyph component to Material Icon.
* Support `onDisabledChanged` callback from angular_forms.
* Add mixin to hide text label.
* Prevent marking itself as dirty when it receives initial form value.
* Add mixin to remove right margin.
* Remove negative top margin.
* Implement `Focusable`.
* Implement onTouched logic.
* Fix disabled state to match Material Spec which is a light grey not a certain
  opacity of the checkbox.

#### Material Chips
* Allow overriding left-icon-color.
* Update margin on dense theme.

#### Material Dialog
* Fix bug with full screen dialogs.
* Fix bug where a disposable could be added to its disposer after it had already
  been destroyed.
* Set default `max-height` and `max-width`.
* Add full screen mode.
* Add support for `<h1>` element in title.
* Add mixin for bottom border on header.
* Remove `preserveWhitespace: false`.

#### Material Dropdown Select
* Add back `keyboardOnlyFocusIndicator` to dropdown items.

#### Material FAB
* Update shadow styles.

#### Material Icon
* Add aria label and use them for trailing/leading icons of Material Input.
* Add mixin for font weight.
* Update mixins to allow overriding elements which have the size attribute set.
* Add flag to mirror icon.
* Roll back change that flipped help icon in RTL.
* Add help icon to the list of icons flipped when direction is RTL.
* Flip half_star icon when in RTL.

#### Material Input
* Remove element used for resizing if the textarea does not need to be resized.
* Added an `aria-labelledby` attribute.
* Add mixin to adjust padding for multi-line inputs.
* Return `null` when input is `"NaN"` or `null`.
* Don't override unfocused underline color when the input is invalid.
* Add field to mixin to specify the label color when there is an error and the
  label is focused.
* Support `onDisabledChanged` callback from angular_forms.
* Push change detection when marked as disabled.
* Add disabled class to `"top-section"` when the input is disabled.
* Add mixin to allow hiding only the placeholder in the bottom section.
* Support to fill in error text trailing.
* Fix error color for floating label when an error is shown in the input.
* Add mixin to change the font size.
* Add `aria-label` and `aria-invalid` attributes back to the input field.
* Allow values to be selectable when disabled on all browsers. This is
  potentially BREAKING.
* Pass aria attributes through to the inner input element. Includes material
  auto suggest component.
* Add an aria-label that can override the label.
* Add mixin for hiding underline.
* Add mixins for trailing text color and padding.
* Show character count when maxCount is null.
* Add attribute to set aria-label when a visible label is not desired.
* Extend the style rules applied on `input[type=text]` to cover the hover and
  focus states.
* Add mixin padding.
* Don't override underline color when the input is invalid.
* Protected against input being destroyed and blur event still happening.
* Add mixin for fixed width error text.
* Use markForChanges on inputs since they are being set by a directive and not
  the template and so change detection doesn't happen automatically.
* Allow numerical values to be internationalized in number validators.
* Add option to have a material number input component format its contents on
  blur.
* Fix unexpected `)` in selector for `MaterialInputDefaultValueAccessor`.

#### Material Expansionpanel
* Do not change background color on focus or hover when disabled.
* Fix issue where header could extend beyond the max-width of its container.
* Add a mixin for no borders.
* Add a mixin to show header actions on the bottom instead of on the left.
* Add mixin to set alignment in the header.
* Remove `transform: scaley` from expand animation.
* Add mixin for top-aligning expand button.
* Add option to move the expand button to the left side.
* Improve animations.
* Add mixin for additional padding.
* Allow icon to be hidden and allow additional buttons in the header.
* Increase mixin specificity.
* Add option show/hide the cancel button.
* Add mixin for flat on collapse.
* Smooth appearance/disappearance of expansion panel contents.
* Add mixin to allow change the panel name min width.
* Remove `preserveWhitespace: false`.

#### Material Popup
* Change `<main>` html tag to a `<div>`. HTML5 states there should only be one
  main tag per application.
* Automatically restore focus on the popup source element when user tabs out.
* Fix border radius mixin.
* Enforce space constraints on content.
* Simplify positioning algorithm.
* Disable constrain-to-viewport in dropdowns via a new, separate `@Input`.
* Guard against `container = null` in `PopupHierarchy.onTriggersOutside()`.
* Increase the animation speed according to material specs.
* Listen to `DomService.trackLayoutChange` streams for `overlayRepositionLoop`
  popups.

#### Material Progress
* Add mixin for taller bars with rounded ends.
* Fall back to the non-optimized animation if the width is 0 after view init.

#### Material Radio
* Remove `material-radio-theme` mixin.
* Add `role` attribute.
* Add `material-radio-color` mixin and deprecate `material-radio-theme`.
* Support `onDisabledChanged` callback from angular_forms.
* Internal cleanup.
* Protect against the group being destroyed before the `tabIndex` gets reset.
* Migrate away from QueryList.
* Update disabled color to match spec.

#### Material Ripple
* Allow the ripple to be created programmatically.
* Update animation to match new spec.

#### Material Select
* Update ARIA `labelledby` for improved a11y.
* Update to `activedescendant` ARIA pattern for a11y.
* Ensure button text displays correctly when an error message shows below it.
* Support focus on dropdown button when dismissed via keyboard.
* Fix focus bug when clicking on a different focusable element.
* Pipe through customized aria role, `labelby`, and `haspopup` to the dropdown
  button.
* Fix selected color mixin on vertical selection indicator.
* Add aria states/properties to indicate selected/checked in item.
* Add proper aria attributes to make `material-dropdown-select` screen reader
  accessible.
* Add mixin to set disabled color.
* Add mixin to allow for error text margin.
* Refactor `constructEncapsulatedCss` to utils.
* Add option to dropdown to disable deselecting on trigger.
* Allow content to be projected as list header and list footer in dropdown.
* Implement `Focusable` in `DropdownButtonComponent`.
* Fixed an alignment issue with the icon on dropdowns.
* Add a `FactoryRenderer` input.
* Wait for the popup to be visible before activating dropdown items.
* Stop escape keyboard events from propagating after they are handled.
* Fix `MaterialSelectItem` displaying two times the label when `factoryRenderer`
  is used.
* Fix auto-scrolling issue on Firefox.
* Add mixin to change `material-select-dropdown-item` padding.
* Add mixin to set select item padding.
* Add mixin to set selected item color.
* Allow customization of Material Dropdown Select's role.
* Add mixin for pointer events on Material Dropdown Select Items.
* Fix baseline alignment of dropdown-button in Firefox.
* Add `showButtonBorder` input to Material Dropdown Select component.
* Cleanup unused styles.

#### Material Spinner
* Add mixin to adjust the stroke width.

#### Material Tabs
* General cleanup: remove unneeded directive, use absolute imports, and fix
  spelling error.
* Add support for `disabled` attribute.
* Make `text-wrap` mixin more generic.
* Add two-way binding on fixed strip activeTabIndex.
* Increase space between labels.

#### Material Toggle
* Implement `ControlValueAccessor`.
* Fix `aria-pressed` state.
* Add mixin to display label on the right.

#### Material Tooltip
* Fix comment which was using deprecated `ElementRef`.
* Allow paper tooltip CSS to be customizable.
* Allow `'error_outline'` as a valid icon.
* Prevent paper tooltips from overflowing on small screens.
* Change `tooltipSource` directive to use `style.cursor`.
* Update line height to `20px` per internal spec.
* Fix `material-paper-tooltip` content that are change detected and using
  deferred content by having the visible property be set in an async manner so
  that the value isn't added in the middle of a change detection loop.

#### Material Tree
* Add `visibleChange` output stream to `MaterialTreeDropdownComponent`.
* Use item identity to remember expanded state.
* Add a `shouldExpandAllWhenFiltered` input.
* Adds an option to select parent nodes in a single selection model tree.
* Bugfix for auto selection all siblings due to an error being thrown which
  stops event.stopPropagation from firing.
* Add an option to material tree group to render a "View more" link for hidden
  options.
* Migrate away from QueryList.
* Autofocus the filter when `MaterialTreeDropdown` is opened, but not when it
  closes.
* Improve latency of `MaterialTreeFilter`.
* Clear filter inside the popup when `MaterialTreeDropdown` closes.

#### Material Yes/No Buttons
* Fix bug where text color was not applying to highlighted/raised yes button.
* Fix no button to not override disabled text label color.
* Remove `Visibility.all`.
* Update mixins to use CSS shimming.

#### Reorder List
* Add ability to specify a handle element in a complex component.
* Calculate the full height/width of the elements.
* Restrict when a dragged item's target index is incremented or decremented.

#### Scorecard
* Add mixin for changing the display to flex.
* Remove the `:host` from the padding mixin so it is not required to be used at
  the top level.
* Add stacking context.
* Only update selected state if the scorecard is selectable.
* Fix misalignment on OS X with hl=ja.
* Selected color input overrides default color value in a selectable scoreboard.
* Add a tooltip field.

### Other Updates
#### Selection Model
* Add `is{Selectable|Disabled|Hidden}In()`, `getOptionIn()` and, `filterWhere()`
  as static helpers to `Selectable`.
* Add empty, single, and multi constructors.
* Add `ignoreDeselect` option to `SelectionModel.single` and deprecate
  `RadioGroupSingleSelectionModel`.
* Update to `SelectionModel.single()`, `SelectionModel.multi()` etc. instead of
  deprecated `SelectionModel.withList()`.
* Add support for `SingleSelectionModel` to `SelectionModel.empty`.
* Add `SingleSelectionModel` interface with `selectedValue()` method.
* Better support for the zippy expansion case.
* Add option to disable select all in the table selection model.
* Use generic type for table selection model `SelectableGetter`.

#### Modal/Overlay
* Add attribute on `PopupSourceDirective` to decide whether to set the popup
  related aria attributes.
* Ensure parent modal is shown when the current modal is destroyed.
* Add DI modules to Laminate Overlay & Popup components.
* Update `PopupHierarchy` to better handle cases with multiple modals.
* Handle null pointer in `popup_source_directive`.
* Protect against a null pointer exception in laminate popup.
* Propagate CSS classes to the overlay element.
* Turn `overlayRepositionLoop` on by default.
* Use a reified Provider for `defaultPopupPositions`.
* Add support for minimum width and height to `PopupSizeProvider`.

#### Miscellaneous
* Make `DomService` run callbacks in the correct zone.
* Fix bug in `DomTreeIterator.moveNext()` where it was using equality instead of
  assignment.
* EntityFormatters now implement the regular Formatters.
* Add a lookup method for finding the closest Material Color name based on any
  input color.
* Scope the `Focusable` item for `AutoFocusDirective` so that any node in the
  hierarchy isn't mistakenly focused.
* Modify `TextHighlighter` to return separate results for adjacent matches,
  rather than concatenating them into a single result.
* Migrate to using event tearoffs.
* Deprecate convenience list for `materialDirectives`. It has been demonstrated
  that it's use increases code size when only some of the components are being
  used. It is preferable to use only the directives needed for your application
  for improved dart2js tree shaking.
* Add `@mustCallSuper` to the Disposer interface.
* Add Add `ObservableView.values` -- like `.stream`, except also with the
  current value.
* Add new CSS class names used by `ShowHideDirective` to avoid conflicts with
  Angular JS apps and remove the legacy versions.
* Only focus when `autoFocus` is `true` when using `AutoFocusDirective`.
* Update various components to use finals for `Intl.message`s to improve
  performance.
* Add `HasDisabled` interface.
* Annotate `Domservice.leap()` visible for testing.
* Add `mat-link-deep` mixin to push the Material link styles everywhere.
* Make mouse events with the shift modifier key a non-standard mouse event in
  `isStandardMouseEvent()`.
* Remove `IntersectionObserver` bindings now that they exist in dart:html.
* Add `onDisabledChanged()` to all `ControlValueAccessor` implementations.
* Add ShowHideDirective and GlobalEscapeDirective.
* Make `ShowHideDirective` constants private. This is potentially BREAKING.
* Add a parameter to fail loudly when `TimeZoneAwareClock` is used before it's
  initialized, to prevent incorrect return values from being ignored.
* Delete deprecated `LazyEventEmitter` since it was no longer lazy and a
  StreamController can be a simple drop in replacement.
* Allow '\[' for start of word of highlight match.
* Use `@visibleForTesting` annotations.
* Remove position: -webkit-sticky support.
* Update type of materialProviders so it can be used when bootstrapping.
* Create a new API for caching item renderers.
* Only add touch listeners if the primary input is touch.
* Add `IntersectionObserver` bindings & `onIntersection` stream to `ScrollHost`.
* Deprecate `getBool()`, Angular supports it now natively.
* Fix RTE when using item renderers as highlight renderers when there is a
  custom factory renderer.
* Fix componentRenderer logic.
* Add a feature detector for `position: sticky`.
* Migrate from Glyph to Material Icon.
* Remove unused table model.
* Remove the `getDynamic()` method from properties helpers.
* Remove uses of `.runtimeType`.
* Cleanup unused variables.
* Allow `material-scrollbar` mixin to be used in global css (without angular).
* Provide a path to use Component Factories when using code that was previously
  using the `ComponentRenderer` pattern.
* Continue migration from `SlowComponentLoader` to `ComponentLoader`.
* Continue migration from `LazyStreamController` to `StreamController`.
* Cleanup Angular static analysis warnings.
* Add optional punctuation around trackBy functions.
* Avoid reliance on dynamic typing to access properties.
* Add `@Input` to number validators.
* Add Observable utilities.
* Add color contrast ratio utility.
* Remove deprecated box-sizing styles.
* Deprecate `ManagedZone` and replace with `NgZone`.
* Remove unnecessary uses of `::ng-deep`.
* Support RTL selectors on any element.
* Remove usage of package UUID.
* Update sass_builder dependency to latest and use the post-process builder to
  remove `.scss` files from the output.

#### Angular API Updates
* Migrate from `host` to new `@HostListener` and `@HostBinding` syntax.
* Migrate from `ElementRef` to `Element` or `HtmlElement`.
* Set `visibility` to `Visibility.all` on Directives that are expected to
  be provided. Others will default to `Visibility.local`. This is potentially
  BREAKING.
* Cleanup unneeded `preserveWhitespace: false` and `preserveWhitespace: true`
  when components manage spacing around themselves and have been validated.

#### Dart 2 Updates
* Fixes for Dart 2 compile-time and runtime errors.
* Application of `dartfmt --fix`.
* Migrate from `Stream<Null>` to `Stream<void>`.
* Updates to conform to new Effective Dart guidelines.
* Prepare for change of `async` behavior in Dart 2.
* Updates to stronger types for Dart 2.
* Fix uses_bottom_as_dynamic ("fuzzy arrow") errors.
* Fix Dart2 runtime cast failures and other Dart 2 fixes.

#### Documentation
* General documentation cleanup for `@Input`s and `@Output`s. Improves
  documentation generated by the component gallery.

## 0.8.0

 * Move entry points to all components out of the lib/src/ directory.
 * Remove all precompiled .css files.
 * Update all import statements in .scss files to use dart style package
   imports.
 * Add dependency on sass_builder package to compile .css files.

## 0.7.1

 * Add Material Auto Suggest Input component.
 * Material Checkbox: Fix disabled state to match material-spec which is a light
   grey not a certain opacity of the checkbox.
 * Material Chips: Add high density mixin.
 * Material Input:
   * Add selectAll function for calling the underlying input element's select
     method that focuses the input and selects all its content.
   * Add ability to update the data on a change instead of keypress or blur for
     the standard Material Input.
   * Remove error color from floating label to conform to material spec.
 * Material Popup:
   * Fix mismatch between the variable used as a reference point for
     repositioning the popup and the variable used to initially set the popup's
     position. This caused issues when the tab was in the background because
     these variables could have changed significantly before the next animation
     frame fired (since requestAnimationFrame is throttled when the tab isn't
     visible).
   * Use `_sourceDimensions` instead of `layoutRects[1]` to take overlay
     container offset into account. Using popupSourceLayoutStream directly
     caused issues when the .acx-overlay-container offset was not (0, 0).
 * Material Select: Fix orientation when groups are used.
 * Scorecard:
   * Fix styling for extra-big cards.
   * Fix to allow selectable scorecards in a "custom" scoreboard.
   * Add a tooltip field enabling scenarios where more information about the
     value can be displayed.
 * Theme: Prepare dark theme for upcoming Visibility.None change.
 * Cleanup unused fields.
 * Update default material scrollbar width to 8px. This is easier to use with a
   mouse or touch input compared to the previous default of 4px.
 * Cleanup unused styles and reorganize `.scss` files.
 * Remove link hover style.
 * Migrate uses of `ElementRef` to `Element`.
 * Remove `visibility: Visibility.none` from all components since compatibility
   is not yet fully supported. Will be added in an upcoming release.
 * Update documentation.

## 0.7.0

 * Material Button: Add raised mixin so that buttons can be made to be raised
   without using the attribute.
 * Material Expansionpanel: Add header minimum height mixin.
 * Material Input: Add support for custom number formatters.
 * Material Popup:
   * Remove `PopupEvent` and reduce asynchrony.
   * Update PopupSizeProvider max-width/height once the popup has been
     positioned.
   * Remove unused `contenWidth` and `contentHeight`.
 * Material Radio: Avoid selecting null when the new selected value is not found
   in the options.
 * Material Tab:
   * Fix logic for the active tab when tabs themselves are changed. Before logic
     was activating/deactivating based on index, but when tabs change the index
     has probably changed.
   * Make mixin to allow text wrapping.
 * Material Tree:
   * Fix bug where state of material tree option cannot be changed by selection
     model.
   * Fix bug where tree_dropdown_select did not auto open correctly using focus.
 * Scorecard: Update colors to match material spec.
 * Deprecate obsolete box-sizing style mixin.
 * Add link color styles and mixin.
 * Add typography style mixins.
 * Set preserveWhitespace: true in preparation for angular flipping the default
   to false.
 * Make functional directive name lowercase to conform with Dart style guide.
 * Replaces deprecated inputs and outputs with inline annotations.
 * Update visibility for provider resolution fix.
 * Update documentation.

### Known Issues
 * Warnings are present when building with dart2js. Specifically:
   _Method type variables are treated as `dynamic` in `as` expressions._

## 0.6.0

 * Update dependency to angular: ^4.0.0.
 * Update SDK dependencies.
 * Add Material Select Searchbox component.
 * Add Application Layout styles and directives.
 * Add Material Icon.
   * Deprecate `GlyphComponent` in favor of `MaterialIconComponent`.
 * App Layout: Fix margins for header icons/links.
 * Dynamic Component: Add ability to use `ComponentFactory` instead of a `Type`.
 * Material Button: Refactor raised styling so it can be used in a mixin.
 * Material Checkbox:
   * Add ability to make readonly.
   * Add mixin for checkbox with no left margin.
 * Material Chips: Add ability to specify background color for left icon.
 * Material Dialog:
   * Support a minimum height.
   * Fix header mixin.
 * Material Expansionpanel:
   * Add high density mixin.
   * Add mixin to allow changes to panels without affecting nested panels.
 * Material Icon: Add back and forward arrows to the list of flipped icons.
 * Material Input:
   * Add support for material dark theme.
   * Fix disabled color.
   * Add leading text color mixin.
   * Make local required errors to make controls invalid even when the control
     has not been interacted with.
   * Add upper and lower bounds validators.
   * Re-calculate text length when custom character counter is set.
   * Prevent mirror-text overflow in multiline material input.
   * Remove unnecessary selector argument from mixins.
 * Material Popup:
   * Constrain popups to the viewport if both `enforceSpaceConstraints` and
     `overlayRepositionLoop` are enabled.
   * Create the material-popup view synchronously.
   * Remove `animationComplete` event.
   * Integrate with Angular CSS shimming and remove `shadowCssClass`.
   * Material design scrollbars by default (instead of the native scrollbars).
   * Add ARIA attributes.
   * Add an option to reposition visible popups every frame with
     `trackLayoutChanges`.
   * Merge laminate/components/popup into Material Popup.
   * Only set content removed if the popup is still not visible when the timer
     is finished.
 * Material Radio:
   * Add mixin for radio button with no left margin.
   * Fix mixin to respect disabled status when a theme is applied.
 * Material Select:
   * Fix selectable menu item property functionality.
   * Allow dropdown to display an error while it's closed.
   * Fix `MaterialSelectItemComponent` to not cache the label.
   * Add input to material-dropdown-select to define custom a renderer for group
     labels.
   * Fix checkbox display handling and label padding in dropdown.
 * Material Toggle: Set the attribute instead of the property to fix a bug with
   incorrect type, and not setting the right property.
 * Material Tooltips: Add ARIA attributes.
 * Material Tree:
   * Update positioning options and borders.
   * Add optional row separator borders.
   * Fix dropdown closing on toggle issue.
   * Added shift selection/deselection.
   * Fix glyphs always shown expanded when `expandAll = true`.
   * Add ability to preserve expansion state.
   * Fix indentation of first child group.
   * Add input `showDisabledCheckboxes`.
   * Add a max-height mixin.
 * Material Yes/No Buttons: Add dense style.
 * Reorder List:
   * Update to recommended syntax for ngFor.
   * Migrate from ManagedZone to NgZone.
 * Scorecard:
   * Update tab index to prevent scroll errors when going through
     buttons with tabs.
   * Replace deprecated Glyph with Material Icon.
   * Invoke inherited click handler from derived click handler.
 * Selection Models:
   * Add deselect all option.
   * Add a limited filtering model.
   * Fix `selectAll` to only trigger a selection change event for the values
     that were added.
   * Add comparator as optional param to tree selection options for custom
     sorting.
 * Avoid adding placeholder for deferred content if the element is detached.
 * Add new color utils.
 * Update animations to new Material specs.
 * Migrate uses of `GlyphComponent` to `MaterialIconComponent`.
 * Migrate uses of `ElementRef` to `Element`.
 * Remove duplicate PopupSourceDirective.
 * Remove deprecated popup `matchSourceWidth` options.
 * Add missing `MaterialIconComponent`, `MaterialPersistentDrawerDirective`,
   `MaterialTemporaryDrawerDirective`, and `MaterialSelectSearchboxComponent` to
   `materialDirectives`.
 * Improve performance of `TreeSelectionOptions` constructor from O(n^2) to O(n)
    in the size of `listOfOptions`.
 * Change DisplayNameRenderDirective to a functional directive.
 * Deprecate LazyEventEmitter and migrate uses to the StreamController model.
 * Additional styling cleanup to support `ng-deep`.
 * Reduce visibility of common directives/components for smaller code size and
   better performance.
 * Remove use of Compass in SASS files.
 * Remove uses of `getBool` in boolean typed inputs.
 * Remove unused alignment parameters.
 * Updates to use metadata inheritance.
 * Migrate away from comment-style generic syntax.
 * Migrate stylesheet combinators `/deep/` and `>>>` to `::ng-deep`.
 * Migrate away from use of angular's `@View`.
 * Remove unused library statements.
 * Refactor Angular annotations to inline versions.
 * Update documentation.

### Known Issues
 * Warnings are present when building with dart2js. Specifically:
   _Method type variables are treated as `dynamic` in `as` expressions._

## 0.5.3+1

> NOTE: SASS files are not used during the build step of this package and are
> provided as reference only. These .scss files were used to generate the
> corresponding .css files in a separate process. We are working on a solution
> to include CSS generation from SASS files during the build process.

 * Add SASS files.
 * Rename .analysis_options -> analysis_options.yaml

## 0.5.3

 * Add Material Tree component.
 * Material Dialog: Add `shouldShowScrollStrokes` option for displaying
   stroke lines when the content is scrollable.
 * Material Dropdown Select: Avoid checking isSelected with deselectLabel.
 * Material Input: UpperBoundsValidator, and LowerBoundsValidator now use
   `Comparable` instead of `num`.
 * Material Popup: Use the real viewport (aka window) size.
 * Scorecard: Add `ng-content` area for a description.
 * Adjust positioning algorithm to account for scrolling within elements.
 * Migrate use of LazyEventController to StreamController.

## 0.5.2

 * Material Progress: Cleanup animations on destroy to prevent memory leaks.
 * Material Select:
   * Support deselect item in Material dropdown select with single selection
     model.
   * Unified template files (deleted material_select_dropdown_item.html).
   * Add support for `Selectable` `SelectionOptions`.
   * Create a `ControlValueAccessor`.
 * Add backspace and delete keys to `KeyboardHandlerMixin`.
 * Add `selectedValue` getter to `RadioGroupSingleSelectionModel`.
 * Add null check to `ObservableComposite`'s `register` method.
 * Add `totalEntitiesCountChange` getter to table selection models.
 * Add `isStandardMouseEvent` utility to test for clicks without modifier keys.
 * Add string selection sanitizing options.
 * Remove `NoopStream` in favor of `Stream.empty()` as provided by the SDK.
 * Migrate use of LazyEventController to StreamController.
 * Fix bug in lazy group creation that would cause multiple groups to be
   created.
 * Strong mode fixes.

## 0.5.1

 * Glyph: Add baseline attribute.
 * Material Expansionpanel:
   * Allow programmatic `expand` and `collapse` requests even if the panel is
     `disabled`.
   * Change `preserveWhitespace` default to false.
   * Add `enterAccepts` flag.
 * Material Input:
   * Show counter regardless of focus.
   * Add error message to `MaterialPercentInputDirective`.
 * Material List: Allow pointer events when disabled.
 * Material Popup: Fix positioning when `matchMinSourceWidth` is true.
 * Material Ripple: Show a centered ripple on keypress.
 * Material Select:
   * Only display underline when border is also set.
   * Add `useCheckMarks` to use check marks instead of checkboxes.
 * Material Tooltips: Resize to fit contents.
 * Material Yes/No Buttons: Add `enterAccepts` flag.
 * Deprecate LazyStreamController and migrate to StreamController.
 * Migrate use of LazyEventController to StreamController.
 * Documentation fixes.
 * Strong mode fixes.

## 0.5.0

 * Rename library to angular_components.

> All previous versions were published as the
> [Pub Package](https://pub.dartlang.org/packages/angular2_components) named
> `angular2_components`.

## 0.4.1-beta

 * Updated dependencies on `pkg/quiver` and `pkg/intl`.

## 0.4.1-alpha

This code is considered production quality, but depends on angular2:
3.0.0-alpha+1. The alpha tag represents the evolving nature of the AngularDart
API, not code quality (3.0.0-alpha+1 is used in production Google apps).

 * Add Dynamic Component.
 * Add Material Select.
 * Add core Material Design .scss files as a reference. Currently not used
   during build.
 * Material Chip: Add option for icon on the left.
 * Material Expansionpanel: Add option to always display expansion icon.
 * Material Input:
   * Add an optional errorRenderer that will allow clients to override/specify
     their own error messages.
   * Add percent input directive.
 * Material Multiline Input: Fix 'hint' typo in inputs list.
 * Material Radio Group: Support deselecting all radio buttons for unmatched
   value.
 * Material Tooltip: Reduce delay.
 * i18l improvements.

## 0.4.0-alpha

This code is considered production quality, but depends on angular2:
3.0.0-alpha+1. The alpha tag represents the evolving nature of the AngularDart
API, not code quality (3.0.0-alpha+1 is used in production Google apps).

### Breaking Changes
 * Update for generic syntax and `FutureOr` type introduced in Dart SDK 1.22.0.
 * Material Toggle: Remove the deprecated `color` theme input.
 * Material Button, Fab, Yes/No:
   * Remove is-disabled and is-raised HTML classes used for styling.
     Custom styles should now use `[disabled]` and `[raised]` instead of
     `.is-disabled` and `.is-raised` when targeting buttons.
   * Remove z-index of 0.

### Other Changes
 * Focus: Fix AX_ARIA_08 a11y issue.
 * Glyph: Option to horizontally flip glyphs when the direction is RTL.
 * Material Chips: Use :host to remove need for wrapper div.
 * Material Expansionpanel: Fix panel overflow issues.
 * Material Input:
   * Add new number accessors and validators.
   * Add ability to override/specify error messages.
   * Fix AX_TEXT_01 a11y issue.
 * Material List:
   * Block pointer events for disabled list items.
   * Remove duplicate mixin.
 * Material Popup: Disable animation delay when there is nothing to animate.
 * Material Radio: Fix styling issue, flex for IE11.
 * Material Tab Panel: Fix issue that prevents displaying tabs on
   initialization.
 * Material Yes/No Buttons: Add submit/cancel buttons.
 * Scorecard:
   * Add support for RTL languages in scrollable scoreboards.
   * Add support for themes.
   * Prevent exceptions during width calculations when scorecard width is
     `auto`.
 * Compute the ARIA roles only once per instance.
 * Fix dom update issues.
 * Add proper types to injected providers.
 * Add missing imports and remove unsupported Angular imports.
 * Strong mode fixes.

## 0.3.1-alpha

This code is considered production quality, but depends on angular2:
3.0.0-alpha. The alpha tag represents the evolving nature of the AngularDart
API, not code quality (3.0.0-alpha is used in production Google apps).

 * Add Material List.
 * Material Expansionpanel: Add `autoDismissable` directive.
 * Material Progress: Handle changes to "indeterminate" state.
 * Scorecard: Add input to display vertically.
 * Update styles to meet Material UI spec.

## 0.3.0-alpha

This code is considered production quality, but depends on angular2:
3.0.0-alpha. The alpha tag represents the evolving nature of the AngularDart
API.

 * Add Material Tooltip.
 * Material Ripple:
   * Add GPU acceleration.
   * `rippleBindings` have been removed as they are no longer used.
 * Internal updates for compatibility with Angular 3.0.0-alpha.
 * Material Expansion Panel:
   * Fix CSS rule that causes header text to turn gray on hover/focus.
   * Support auto-focus on a content element when the material expansion panel
     expands.
   * Fix Yes/No button ordering.
 * Material Input:
   * Add a blur update value accessor.
   * Add multiple attribute.
   * Remove unused properties: rows and maxRows.
 * Material Input Multiline: Add auto grow in size.
 * Material Popup: Update change detection for OnPush.
 * Material Progress: Update to animate when main thread is blocked.
 * Material Radio: Adjust size to 24px.
 * Material Yes/No: Add toggle for yes button visibility.
 * Scorecard: Update change detection.
 * Fix flipped alignment positions when isRtl is used.
 * Fix popup event handling.
 * Remove 'uninitialized' as a default value.
 * Remove unused CSS rules.
 * Update styles to meet Material UI spec.
 * Bug fixes.
 * Strong Mode fixes.

## 0.2.2

 * Add Material Popup, a basic popup component.
 * Update Material Checkbox icon size.
 * Cleanup framework stabilizers since
   [issue #24843](https://github.com/dart-lang/sdk/issues/24843) in the Dart
   SDK has been resolved.
 * Remove unused files.

## 0.2.1

* Rollup of recent changes.
* Includes fix for breaking change in Angular 2.2.0.

## 0.2.0

* Add a modal dialog window called material_dialog.
* Rename MultilineMaterialInputComponent to MaterialMultilineInputComponent.
* Make the deferredContent placeholder element optional, off by default.
* Remove InputTextModel.
* Cleanup linter warnings.
* Refactor color support.
* Many components now support removing whitespace in the templates.
* Refactor tab key index to a mixin.
* Various updates and cleanup.

## 0.1.1

* Small change to README.md

## 0.1.0

* Initial Open Source release.
