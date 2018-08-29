# App Layout

App layout is a system of styles, directives, and components that when used
together can give a material look and feel to the scafolding of your
application. It provides an App Bar, Drawers, and Navigation styling following
the material spec.

## Setup

The styles are provided by
`package:angular_components/app_layout/layout.scss.css`. To use these styles in
an angular component simply add it as a `styleUrls` value in your `Component`
annotation. It is suggested that the style is added before any component
specific styling so you can easily override style values as needed.

```dart
@Component(
    selector: 'my-component',
    templateUrl: 'my_component.html',
    styleUrls: const [
      'package:angular_components/app_layout/layout.scss.css',
      'my_component.scss.css'])
class MyComponent {}
```

## App Bar

An app bar has the following classes which can be used together to create a
header:

<!-- mdformat off(Basic table formatting for Github markdown compatibility) -->

Class                   | Description
----------------------- | ------------------------------------------------------
**material-header**     | Container element for the header.
shadow                  | Modifier on material-header to apply a shadow to the <br>header.
dense-header            | Makes the App Bar denser for interfaces that primarily <br>use mouse and keyboard.
**material-header-row** | A row within the header.
material-drawer-button  | A button within the row that is placed on the left and <br>is used for navigation.
material-header-title   | A title for the header.
material-spacer         | Consumes space between the title and any navigation <br>links. Needs to be placed after the title and before <br>any navigation elements.
material-navigation     | Navigation elements which will be displayed on the <br>left side of the header. Only use with anchor tags, <br>material-button have there own styling built in.

<!-- mdformat on -->

Here is an example:

```html
<header class="material-header">
  <div class="material-header-row">
    <material-button icon
        class="material-drawer-button" (trigger)="drawer.toggle()">
      <material-icon icon="menu"></material-icon>
    </material-button>
    <span class="material-header-title">Simple Layout</span>
    <div class="material-spacer"></div>
    <nav class="material-navigation">
      <a>Link 1</a>
    </nav>
    <nav class="material-navigation">
      <a>Link 2</a>
    </nav>
    <nav class="material-navigation">
      <a>Link 3</a>
    </nav>
  </div>
</header>
```

![Simple App Bar](/dart-lang/angular_components/master/lib/app_layout/g3doc/simple_app_bar.png)

## Drawers

There are three kinds of drawers that are available: _permanent_, _persistent_,
and _temporary_. All drawers are instantiated by the `material-drawer` element.
These drawers are implemented differently to provide the best performance for
each. For the main content outside of the drawer wrap it in a `material-content`
element, or a element with the class `material-content`.

### Permanent Drawers

Permanent drawers are drawers which can't be closed. They are provided purely by
CSS. To have a permanent drawer add the `permanent` attribute to the
`material-drawer` element. Example:

```html
<material-drawer permanent>
  <!-- Drawer content here -->
</material-drawer>
<material-content>
  <!-- Content goes here -->
</material-content>
```

### Persistent Drawers

Persistent drawers are drawers which can be open and closed by an action, such
as a button trigger. These drawers reposition the content to fit in with the
flow of the drawer. To use a persistent drawer add the `persistent` attribute to
the `material-drawer` element, and add the `MaterialPersistentDrawerDirective`
to the parent's directives list.

Lastly, connect the open/close drawer action to the drawer. This is most easily
done using the [reference
variable](https://webdev.dartlang.org/angular/guide/template-syntax#!#ref-vars)
syntax. The persistent drawer directive exports itself as `drawer` this allows
it to be used easily by other actions. `toggle()` can be used to open/close the
drawer. The drawer supports the `deferredConent` directive allowing a developer
to add/remove content from the page when the drawer is not visible (closed.)
Here is a complete example:

```html
<material-drawer persistent #drawer="drawer">
  <div *deferredContent>
    <!-- Drawer content goes here -->
  </div>
</material-drawer>
<material-content>
  <header class="material-header shadow">
    <div class="material-header-row">
      <!-- This button will toggle (open/close) the drawer -->
      <material-button icon
          class="material-drawer-button" (trigger)="drawer.toggle()">
        <material-icon icon="menu"></material-icon>
      </material-button>
      <!-- Other header info goes here -->
    </div>
  </header>
  <div>
    Content goes here.
  </div>
</material-content>
```

### Temporary drawers

Temporary drawers are drawers that live on top of the conent. They are provided
by `MaterialTemporaryDrawerComponent` which has a similar look and feel to the
other drawers. To use a temporary drawer add the `temporary` attribute to the
`material-drawer` element, and add `MaterialTemporaryDrawerComponent` to the
parent's directive list.

The temporary drawer has an optional `overlay` attribute which can be used to
show a transparent overlay above non-drawer content while the drawer is open.

Here is an example:

```html
<material-drawer temporary #drawer="drawer" overlay>
  <div *deferredContent>
    Here is some drawer content.
  </div>
</material-drawer>
<material-content>
  <header class="material-header shadow">
    <div class="material-header-row">
      <material-button class="material-drawer-button" icon
                       (trigger)="drawer.toggle()">
        <material-icon icon="menu"></material-icon>
      </material-button>
      <span class="material-header-title">Mobile Layout</span>
      <div class="material-spacer"></div>
    </div>
  </header>
  <!-- Content goes here -->
</material-content>
```

### Displaying the drawer on the opposite side

All drawers have an HTML attribute `end` which positions the drawer on the
opposite side of the page as normal (right side in LTR, and left side in RTL.)

Example:

```html
<material-drawer temporary end>
  <!-- This drawer is going to be on the right side in LTR,
       left side in RTL. -->
</material-drawer>
```

### App Bar and Drawer interaction

The app bar and the drawer work in tandem to provide an overal app layout for an
application. The app bar can live both inside, or outside of `material-content`.
If it is inside of `material-content` it will live with the content and if
applicable be repositioned with the content. If it is on top of
`material-content` the drawer and content will be positioned below the app bar
for the `permanent` and `persistent` drawers.

Example:

```html
<header class="material-header shadow">
  <div class="material-header-row">
    <material-button icon
        class="material-drawer-button" (trigger)="drawer.toggle()">
      <material-icon icon="menu"></material-icon>
    </material-button>
    <span class="material-header-title">Simple Layout</span>
    <div class="material-spacer"></div>
    <nav class="material-navigation">
      <a>Link 1</a>
    </nav>
  </div>
</header>
<material-drawer persistent #drawer="drawer">
  <!-- Drawer content here -->
</material-drawer>
<material-content>
  <!-- Content here -->
</material-content>
```

## Navigation Styles

Navigation element styles within the drawer are also provided by app_layout.
This is accomplished using the standard `material-list` component, and some
special CSS classes.

The top level drawer content should be a `MaterialListComponent` with optional
group elements which are specified by the `group` attribute on an element.

The `mat-drawer-spacer` CSS class is optional and ensures that if the header is
inside of `material-content` then the drawer content will start at the bottom of
the header.

Use `MaterialListItemComponent`s for the items in your drawer. For each group if
you need a label on the group use the `label` attribute on a block element
directly inside of your group element.

Here is an example:

```html
<material-drawer permanent>
  <material-list *deferredContent>
    <!-- Position the start of the drawer content correctly -->
    <div group class="mat-drawer-spacer"></div>
    <!-- Here is a group without a label -->
    <div group>
      <material-list-item>
        <material-icon icon="inbox"></material-icon>Inbox
      </material-list-item>
      <material-list-item>
        <material-icon icon="star"></material-icon>Star
      </material-list-item>
      <material-list-item>
        <material-icon icon="send"></material-icon>Sent Mail
      </material-list-item>
      <material-list-item>
        <material-icon icon="drafts"></material-icon>Drafts
      </material-list-item>
    </div>
    <!-- This group has a label -->
    <div group>
      <div label>Tags</div>
      <material-list-item>
        <material-icon icon="star"></material-icon>Favorites
      </material-list-item>
    </div>
  </material-list>
</material-drawer>
```

Due to style encapsulation, if the list content isn't directly in a drawer (that
is, it's wrapped in another component) you'll have to provide the styles above
using a mixin.

Example scss drawer content component:

```scss
@import 'third_party/dart_src/acx/app_layout/lib/mixins';

:host {
  @include mat-drawer-list-items;
}
```
