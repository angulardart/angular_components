# Overview

Most selection widgets care about two data points: what is selectable and what
is selected.

In ACX selection widgets, what is selectable is represented by the
[`SelectionOptions`](https://github.com/dart-lang/angular_components/blob/master/angular_components/lib/model/selection/selection_options.dart)
interface, while what is selected is represented by the
[`SelectionModel`](https://github.com/dart-lang/angular_components/blob/master/angular_components/lib/model/selection/selection_model.dart)
interface.

Material Dropdown Select is a button-triggered dropdown. It uses these two
interfaces via the `options` and `selection` inputs. Together with the
`selectionChange` output, you can setup two-way binding for the selected value.

HTML:

```html
<material-dropdown-select
    [options]="myOptions"
    [(selection)]="mySelection"
    [buttonText]="...">
</material-dropdown-select>
```

Dart:

```dart
class MyView {
  final myOptions = [1, 2, 3];
  int mySelection = 2;
}
```

# The options input

The `options` input accepts either a `SelectionOptions` class or a generic
`List`.

If a `List` is passed, a
[`StringSelectionOptions`](https://github.com/dart-lang/angular_components/blob/master/angular_components/lib/model/selection/string_selection_options.dart)
will be created with the list and the `ItemRenderer` if specified to support
basic filtering.

If you need more advanced features, like grouped options, custom filtering or
async search, you could also pass an implementation of `SelectionOptions`.

# The selection input & output

The `selection` input accepts either a `SelectionModel`, a selected value or
null.

By default Material Dropdown Select uses
[`SingleSelectionModel`](https://github.com/dart-lang/angular_components/blob/master/angular_components/lib/src/model/selection/single_selection_model_impl.dart).
If a selected value is passed to the `selection` input, this value will be
selected by the default selection model. If a null value is passed to the input,
the default selection model will clear the selection.

If you need to use a `MultiSelectionModel` or a custom implementation of
`SelectionModel`, you could also use the same input.

The `selectionChange` output emits the selected value(s) whenever selection
changes. For single select, it will either be the selected value or null. For
multi select, it will a list of selected values or an empty list.

For simpler single select use cases, you can use the `[(selection)]` syntax to
setup two-way binding for your selected value.

**Important** If using SingleSelectionModel, this component will both deselect
and then reselect on selection changes (two events) and
SingleSelectionModel.selectedValue may become null unless
[`deselectOnActivate`](https://github.com/dart-lang/angular_components/blob/master/angular_components/lib/material_select/material_dropdown_select.dart?q=deselectOnActivate)
is set to false.
