# Overview

Most selection widgets care about two data points: what is selectable and what
is selected.

In ACX selection widgets, what is selectable is represented by the
[`SelectionOptions`](https://github.com/dart-lang/angular_components/blob/master/angular_components/lib/model/selection/selection_options.dart)
interface, while what is selected is represented by the
[`SelectionModel`](https://github.com/dart-lang/angular_components/blob/master/angular_components/lib/model/selection/selection_model.dart)
interface.

Material Auto Suggest Input is an input field which provides suggestions to
auto-complete the input as the user types. It uses these two interfaces via the
`selectionOptions` and `selection` inputs, but additionally it has `inputText`
which presents the text the user has entered.

Which input combinations to use for Material Auto Suggest Input depends on your
use case.

If you are using the component to accept user entered content, and the list of
options is used to assist content entry, you want to use `selectionOptions` and
`inputText`. Together with the `inputTextChange` output, you can setup two-way
binding for the input text.

HTML:

```html
<material-auto-suggest-input
    [selectionOptions]="myOptions"
    [(inputText)]="myInput"
    ...>
</material-auto-suggest-input>
```

Dart:

```dart
class MyView {
  final myOptions = ['Foo', 'Bar', 'Baz'];
  String myInput = 'Bar';
}
```

If you are using the component to select one or more items from a list of
options, and the input is used for filtering, you want to use `selectionOptions`
and `selection`. Together with the `selectionChange` output, you can setup
two-way binding for the selected value.

HTML:

```html
<material-auto-suggest-input
    [selectionOptions]="myOptions"
    [(selection)]="mySelection"
    ...>
</material-auto-suggest-input>
```

Dart:

```dart
class MyView {
  final myOptions = [1, 2, 3];
  int mySelection = 2;
}
```

# The selectionOptions input

The `selectionOptions` input accepts either a `SelectionOptions` class or a
generic `List`.

If a `List` is passed, a
[`StringSelectionOptions`](https://github.com/dart-lang/angular_components/blob/master/angular_components/lib/model/selection/string_selection_options.dart)
will be created with the list and the `ItemRenderer` if specified to support
basic filtering.

If you need more advanced features, like grouped options, custom filtering or
async search, you could also pass an implementation of `SelectionOptions`.

# The selection input & output

The `selection` input accepts either a `SelectionModel`, a selected value or
null.

By default Material Auto Suggest Input uses
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
