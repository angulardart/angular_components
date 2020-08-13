## 0.14.0-alpha+1
### Component Updates

#### Application Layout
* Add `canClose` input the temporary drawer to prevent the drawer from toggling.

#### Dynamic Component
* Use type promotion instead of dynamic dispatch to update a `RendersValue`
  instance.
* Change to "OnPush" change detection.

#### Material Auto Suggest Input
* Stop event propagation when key nav events are handled.
* Update to work within components using `ChangeDetectionStrategy.OnPush`.

#### Material Button
* Add Sass mixins to change the padding on the internal button content, adjust
  vertical alignment, and reset `text-transform`.
* Remove Sass mixin `button-text-capitalize()`.
* Fix visibility in Microsoft Edge on Windows when using High Contrast mode.

#### Material Datepicker
* Add Sass mixins for margins around and between the next and previous buttons.
* Increase the color ratio for the apply/cancel buttons.
* Allow picking times using specified increments.
* Handle `<ESC>` key press when picker is visible.
* Removed deprecated `comparesToPreviousPeriod()` and
  `comparesToSamePeriodLastYear()`.
* Delegate to `FocusItemDirective`.
* Fix the a11y role for the date range preset list.
* Improved accessibility for presets.

#### Material Dialog
* Add Sass mixin for the footer margin.
* Always keep a transparent scroll stroke to prevent dialog from shifting.

#### Material Expansion Panel
* Improve accessibility.
* Accommodate contents taller than the screen size.

#### Material Input
* Make text size limits available to screen readers.
* Change attribute `inputRole` to and input `role`.
* Add a CSS class `.ltr` so input can set `direction: ltr` on the top section.
* Add Sass mixin to adjust the location of floating label.

#### Material Menu
* Prevent screen readers from reading a non-collapsible label as "button".
* Apply the same background color on focused and active items.
* Update `icon` attribute to use a Dart boolean instead of a string `'true'`.
* Add Sass mixin for adding ellipsis to overflowing item text.
* Auto-activate FAB menu items when a screen reader triggers the fab.
* Only auto focus an active item when it exists.
* Protect against null pointer exception when closing.
* Move focus-trap outside of the menu-item-groups.
* Add a way to pass context to the `MenuItem` actions.

#### Material Popup
* Add `ariaLabel` input.
* Encapsulate the popup class name.

#### Material Select
* Fix selected item visibility in Microsoft Edge on Windows when using High
  Contrast mode.
* Add Sass mixins for adding ellipsis to overflowing item text and a custom
  outline.

#### Material Slider
* Support two sided sliders.

#### Material Stepper
* Add `yesText` input.
* Add input to keep inactive steps in DOM.
* Add partially complete state.
* Update icon and index colors for improved a11y.

#### Material Tab
* Set tabbable tab to always be activeTab.
* Improve `allow-text-wrap` Sass mixin.
* Rename Sass mixin `allow-text-wrap` to `tab-text-wrap` and default
  `$break-word` to `true`.
* Add Sass mixin to apply text transform.

#### Material Tooltip
* Fix deferred content within tooltip.
* Add Sass mixin for paper tool tips with multiple sections.

#### Material Tree
* Add input to toggle selection of non-leaf nodes.

### Other Updates

#### Miscellaneous
* Remove `mat-icon-image()` in favor of `inline-image()`.
* Add `subtract()` to Date model.
* Migrate event handlers with multiple statements to component methods.
* Fix violations of the `strict-raw-types` analysis option.
* Fix violations of `prefer_initializing_formals`, `prefer-collection-literals`,
  and `prefer-final-fields` lints.
* Properly remove items when invoking `StickyContainerLayout.remove()`.
* Create mixins for error_panel.
* General code readability fixes.
* Deprecate outdated Sass mixins: `button-bar-layout()`, `mat-input-header()`,
  `clear-button()`, `icon-background()`, `cursor-grab()`, and
  `cursor-grabbing()`.
* Fix graphical issue with sticky elements with `height: 0`.
* Add option to disable `GestureListener` in `ScrollHost`.
* Rename `palette.dart` to `material_chart_colors.dart`.

### Documentation
* Minor documentation fixes.

## 0.14.0-alpha
### Component Updates

#### Material Auto Suggest Input
* Adding generic type to `factoryRenderers` in items.
* Update blur event logic.
* Add `inputAutocomplete` input.
* Improve a11y with added aria controls.

#### Material Checkbox
* Add Sass mixin to remove all margins.

#### Material Date Picker
* Fix issue where given `dateFormat` was not used to decode the input value.
* Apply `FocusableMixin`.
* Modularize and deprecate `timeZoneAwareDatepickerProviders`.
* Prevent wordwrap for the range title.

#### Material Dialog
* Add Sass mixin to justify footer content.

#### Material Dropdown Select
* Pass `aria-describedby` through to the dropdown button.

#### Material Expansion Panel
* Only auto focus a child, when the panel is expanded.
* Only fire events and DOM changes on on-target TransitionEnd events.
* Improve a11y by toggling content visibility when the panel expands or
  collapses.
* Add `focusOnOpen` input.

#### Material Input
* Add Sass mixin to change bottom section width and trailing text.
* Add `inputAriaControls` input.

#### Material Menu
* Add `popupClass` and `buttonAriaLabelledBy` inputs.
* Add Sass mixin to configure the background color of a selected menu item.

#### Material Popup
* Fix memory leak.

#### Material Radio
* Ensure changes are picked up by Angular's change detection.
* Add Sass mixin to configure the content margin.
* Fix issue where programmatic changes to the value model were not shown.

#### Material Select
* Adding generic type to `factoryRenderers` in items.
* Add Sass mixins to configure item colors.

#### Material Stepper
* Fix an issue where when `activeStepIndex` is set to a value but the step state
  is not updated accordingly.

#### Material Tab
* Loop items and ignore up and down arrow key presses when focusing.

#### Material Tooltip
* Add Sass mixin to configure the max width of a tooltip.
* Improve a11y with focus control.

#### Material Tree
* Properly apply `nested-material-tree-item-style` Sass mixin to nested items.
* Introduce a `allowDeselectInHierarchy` configuration that allows clients to
  specify if a user should be allowed to deselect an option that they have
  already selected (by clicking on it again).

#### Material Yes/No Buttons
* Make `EnterAcceptsDirective` use key press instead of key up to align with
  button decorator.
* Added `aria-describedby`.

#### Scorecard
* Only apply tabindex 0 to scorecards that are selectable.

### Other Updates

#### Selection Model
* Change `SelectionModel.isSingleSelect` from a field to an abstract getter.
* Add a missing `super.dispose()` call to `_StreamSelectionOptions`

#### Miscellaneous
* Improve `OverlayService` singleton error message.
* Modularize ruler bindings.
* Fix a bug where scroll host would try to add events to a closed
  `StreamController`.
* Update `FocusItemDirective` and `FocusListDirective` to work consistently
  under `OnPush` components.
* Use GPU accelerated CSS translate rather than 2D translate in sticky
  controller.
* Make the new trigger logic the default for popups. This ignores drag mouse up
  calls to that users can more easily select text in popups.
* Mark `DeferredContentDirective` for change detection, after handling event
  from deferred content aware parent.
* Fix a scroll host issue where scroll events were not ignored when the `Meta`
  key was pressed.
* Cleanup uses of deprecated `getBool()`.
* Replace uses of `detectChanges()` with `runAfterChanges...`.
* Add generic type argument to `AcxImperativeViewUtils.insertComponent<T>()`.
* Add the ability to ignore up and down keys (for moving focus around within
  children) when using the focus list.
* Update all components to use `ref="noopener noreferrer"` for `target="_blank"`
  links.

### Documentation
* Minor documentation fixes.

## 0.13.0
### Component Updates

#### Material Autosuggest Input
* Toggle multi-select items with `<Space>` instead of `<Enter>`.
* Make the pointer for the clear icon consistent with other buttons when
  disabled.

#### Material Button
* Apply media query to `_button_hover` mixin call so that we will skip hover for
  all touchscreens (only apply hover for media supporting hover).
* Add Sass mixins to customize icon colors and left align button text.
* Avoid double trigger of button with a space bar keypress.

#### Material Checkbox
* Use both label and content as aria label.
* Add types to the outputs.

#### Material Date Picker
* Make the calendar component invisible to screen readers.
* Add `selectDatePlaceHolderMsg`, `placeholderMsg`, and
  `dropdownButtonAriaLabel` inputs.

#### Material Date Range Picker
* Add `preferredPositions` input.
* Improve handling of pt-BR date range formatting to remove repetitive "de"s
  when the endpoints fall into different years.
* Make comparison toggle label clickable.

#### Material Dialog
* Add Sass mixin to customize font size.
* Use header as default dialog label.
* Mark current landmarks as `role="presentation"` to avoid unnecessary grouping.
* Add missing modal visible output.

#### Material Expansion Panel
* Add missing modal visible output.
* Allow header to have an outline, and control it with keyboard only focus.
* Add aria-expanded to announce when it is opened/closed.
* Add Sass mixin to make save button raised and highlighted.
* Improve a11y.
* Add the ability to tag the content that you would like to focus when an
  expansion panel opens.

#### Material Icon
* Add Sass mixin to customize svg icon size.

#### Material Input
* Update error message for negative percentage value to be "not negative"
  instead of "positive", because zero is allowed.
* Ensure that `aria-disabled` is set for the input when the input is disabled.
* Use aria-describedby attribute in the to call out errors.
* Remove TAB focus from disabled multiline input.
* Add Sass mixin for multiline inputs to flex and scroll the text entry.
* Add Sass mixins for setting `flex-grow` property and the clear icon color.
* Stop hiding character counter from Aria.
* Add `role="alert"` to error text region.
* Add generic types to `MaterialInputDefaultValueAccessor` and
  `MaterialNumberValueAccessor`.
* Create new `Int64` value accessor.
* Pass down the aria-label for leading and trailing glyphs.

#### Material Menu
* Remove unnecessary escape key handling in MenuItemGroupsComponent.
* Add in aria-label support into the items and groups.
* Open dropdown when navigation keys are pressed.
* Add Sass mixin to customize the item icon size.
* Add aria-expanded to collapsible menu groups.
* Fix item focus bug when the fab menu is opened.
* Improve aria roles for `MenuItemGroup` items.
* Add keyboard accessibility functionality for active item handling.

#### Material Progress
* Fix screen reader status messages.

#### Material Popup
* Add `autoDismissBlockers` input to block click events in certain elements from
  closing the popup.
* Support defining custom boundaries around window viewport.
* Ensure footer stays inside popup boundaries.
* Add Sass mixin to override overflow value.
* Fix memory leaks.

#### Material Stepper
* Announce the current step via the screen reader.
* Provide custom aria label for steps.

#### Material Select
* Fix issue where a keypress on selected item would re-open dropdown.
* Remove `tabIndex` from items and let the dropdown control focus instead. Focus
  is now controlled by the dropdown itself.
* Support keyboard navigation.
* Add Sass mixins to customize:
  * Background color of the selected item.
  * Minimum height of the dropdown buttons.
  * Color of the dropdown icon.
  * Font size of items.
* Allow auto-focusing on the active item.
* Update Sass mixin `dropdown-icon-spacing` to accept all four margins.

#### Material Tab
* Add Sass mixin to customize tab strip elevation.

#### Material Toggle
* Add focus effect.

#### Material Tooltip
* Remove `initAriaAttributes` for ink tooltips by default.
* Fix hiding tooltip for `MaterialTooltipTargetDirective` when focusing inside
  of it.

#### Material Tree
* Add `allowParentSingleSelection` input.
* Don't override state when `expandAll` hasn't been set.
* Add component generics and pass type through to nodes.

#### Material Yes/No Buttons
* Add Sass mixin to make yes button raised and highlighted.
* Add Sass mixin to make no button highlighted.

#### Scorecard
* Fix improper heading hierarchy.
* Fixed scrolling when the average size of the cards is bigger than the client.

#### Simple HTML Component
* Add attribute `doNotVerifyUrlDestinations` to allow "normal" external URLs.

### Other Updates

#### Selection Model
* Allow `is NullSelectionModel` as a replacement for
  `== const SelectionModel.empty()`, necessary for typed selection models which
  can't use const.
* Expose null selection model type to allow type checks.
* Remove deprecated `SelectionModel()`.
* Add `isSingleSelect` field.

#### Miscellaneous
* Allow `HasTabIndex` to not set a `TabIndex`.
* Fix a bug where sticky elements do not stack when sticky position is BOTTOM.
* Use named providers instead of the soft deprecated provide(...) and
  Provider(...).
* Update MDC Web styles to v1.1.0
* Tighten public APIs with `@visibleForTemplate`.
* Enable trigger logic that only considers `mouseup` events as part of
  `triggersOutside()` if the corresponding `mousedown` event came from the same
   element.
* Fix runtime cast errors.
* Remove use of `ChangeDetectionStrategy.Detached`.
* Non-tabbable `buttonDirectivesRemove` now have no tabIndex instead of -1.
* Many components migrated to `OnPush` change detection.

## 0.12.0

### Component Updates

#### Material Auto-Suggest Input
* Disable clear icon when the input is disabled.
* Hide an empty suggestion group.

#### Material Button
* Add Sass mixin to change the color of a disabled button.

#### Material Card
* Update elevation appearance to match spec.

#### Material Chips
* Allow setting a custom aria label for the delete button.
* Fix issue that prevented removing chips while using JAWS screen reader.
* Add Sass mixins for font-weight and padding.

#### Material Datepicker
* Remove `globalDateRangeBindings`.
* Allow setting a custom aria label to the dropdown button.
* Allow passing custom `DateFormat` from the `material-date-range-picker` to the
  `date-range-input`.

#### Material Dialog
* Allow setting a custom aria label and describe by.

#### Material Expansion Panel
* Ensure height calculations are completed after the main content is destroyed.
* Fix keyboard controls to prevent focusing a hidden header button.
* Allow setting a custom aria label to the panel.
* Make the entire content of the panel deferred rather than just the buttons.
* Make the expansion button not be tabbable since the heading is tabbable.
* Prevent hidden buttons from being focused in the header.
* Improve panel resizing.
* Implement `focusableItem` so that it can work with a `focusList`.
* Move name ng-content above the input name and description.

#### Material Icon
* Correctly stretch SVG icon.
* Remove aria label from the icon.

#### Material Input
* Add Sass mixin for label text vertical-align.
* `'percent'` is an invalid type attribute, `'text'` instead.
* If the multi-line input is not currently in the DOM listen to DOM updates
  until the line height can be read.
* Ensure only whitespace is considered an invalid number input.
* Allow specifying an aria described by id on the input.
* Add Sass mixin to center align text.
* Hide place holder on input field from screen reader.
* Fix focus behavior in disabled state.

#### Material List
* Change the default roles to `list` and `listitem`.

#### Material Menu
* Create standalone menu item affix components.
* Load standalone menu item affix components via `DynamicComponent` instead of
  using `NgIf`s.
* Allow described by id to be specified for a dropdown button.
* Create `MenuItemMixin`.

#### Material Month Picker
* Re-render highlights when view is reset.

#### Material Popup
* Move the overlay focus placeholder elements inside of Material Popup.
* Enable `OnPush` change detection.

#### Material Ripple
* Remove ripple elements when component is destroyed.

#### Material Select
* Support custom aria handling for each list item in dropdown.
* Support `OnPush` change detection.
* Revert change that attempted to fix strange behavior when mixing keyboard and
  mouse input because it broke some keyboard navigation.
* Allow setting a custom aria label and describe by.
* Add Sass mixin to customize dropdown item selected background color.

#### Material Tab
* Add Sass mixin to make the tab contents `display: block`.

#### Material Time Picker
* Fix regression where time cannot be set by user a programmatic change.

#### Material Tooltip
* `initPopupAriaAttributes` is now passed through to all the tooltip variations.
* Restore any previously defined `aria-describedby` value, after popup closes.
* Add Sass mixin to set `word-break`.
* Fix nested tooltip targets preventing tooltips from staying open when hovered.

#### Material Tree
* Add ability to specify a label renderer for dropdown button text.
* Add ability to style items in the tree dropdown.

#### Material Yes/No Buttons
* Add optional ARIA label inputs.
* Add Sass mixin to remove the `margin-left`.
* Add autofocus functionality for use in confirmation dialogs.

#### Scorecard
* Vertically align the change glyph to the middle.

#### Simple HTML Component
* Allow 'class' attribute for all elements.

### Miscellaneous
* Add home/end key modifiers to focus_list to focus the first or last value.
* Remove `$mat-gray` as an alias for `$mat-grey` in Sass mixins.
* Add `shouldFilterEmpty` parameter to `StringSelectionOptions` to return empty
  filtered values when query is empty.
* Make the role of a button mutable, after initialization.
* Update MDC Web styles to v0.44.0.
* Add `HtmlDocument` in addition to `Document` as a provided `windowBinding`.
* Modularize clock bindings.
* Remove default values for optional parameters on `notifySelectionChange()`.
* Use `WheelEvent` instead of `MouseEvent` in scroll host.
* Fix previously uncaught violations of invalid override method parameter
  default values.

### Documentation
* Minor docs fixes.

## 0.11.0

### New Component
* Simple HTML Component.

### Component Updates

#### Material Chips
* Add a focused style to delete icon.
* Remove default value from `$max-chip-width` in the `material-chip-max-width`
  Sass mixin.
* Remove `material-chips-margin` Sass mixin.

#### Material Date Range Picker
* Make dropdown not tabbable so it can be opened using the top level button
  decorator.
* Add NextNDaysFromToday class.
* Auto scroll to the bottom when comparison is turned on by the user.
* Fix constrained sizing on Firefox browser.
* Make intl messages `final`.

#### Material Dialog
* Fix size of full screen dialog.
* Close parent modal on escape key by default.

#### Material Icon
* Add `MaterialIconToggleDirective` to allow for an icon with two states.

#### Material Input
* Update the integer error message per Editorial feedback.
* Add Sass mixin for changing the color of the counter.
* Fix a11y when there is a `labeledby` id and a aria label specified.

#### Material Menu
* Add a drop-in replacement for `secondaryIcon` - `itemSuffix` that removes the
  boilerplate of creating an observable list for a single element.
* Automatically expand a collapsed category when keyboard navigating to a child
  item.
* Remove usages of secondary icon and related fields/methods from menu item
  model.
* Prevent refocus on a menu item when the menu is closing.
* Add `isTabbable` to `MenuItemComponent`.
* Improve a11y in Material Fab Menu.
* Fix focus target when pressing Up Arrow key.

#### Material Popup
* Correctly restore focus in nested popups.

#### Material Select
* Add type parameters on `BaseDropdownSelectValueAccessor` and subclasses.
* Set max-width to 100% on `dynamic-item`.
* Removing Sass mixin for setting the width of the container element in
  dropdowns with factoryRenderers to 100%, as this was adopted as the standard.
* Use the generic type parameter from `MaterialDropdownSelectComponent` on the
  `ActivateItemOnKeyPressMixin`.
* Fix focus bugs when mixing keyboard and mouse navigation.
* Add temporary fix for scrolling bug in Chrome browser.
* Fix `MaterialDropdownSelect` type error when clicking a deselect item.
* Fix the type of `itemRenderer` in `MaterialDropdownSelectComponent`.

#### Material Tabs
* Make default width of `tab-content` to 100%.

#### Material Tooltip
* Improve a11y and keyboard navigation.
* Fix removing describe-by.

#### Modal/Overlay
* Add ability to create an accessible overlay container for clients that
  currently provide custom overlay container.
* Fix selector of `PopupSizeProviderDirective`.
* Restore focus to popup source element if the popup is closed via keyboard from
  inside itself.
* Close popup on escape if the focus is inside the popup or on the popup source
  element.

### Miscellaneous
* Improve error message when selection type is wrong in `SelectionInputAdapter`.
* Add `primaryStyle` to `StyleFormatter`.
* Refactor the keyboard only focus indicator so that when an element is focused
  programmatically it will obey the focus state of the last known interaction.
* Only consider mouseup events as part of `triggersOutside()` if the
  corresponding mousedown event came from the same element.
* Set attached portals on portals attached to `DomPortalHosts`
* Fix focus issues with modal dialogs.
* Add `FocusIndicatorController` for use in debug environments.

### Documentation
* Minor docs fixes.

## 0.10.1

### Component Updates

#### Material Chips
* Improve support for generics.
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
