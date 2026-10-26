# Layout Lab Answers

**Name:** YOUR NAME  
**Roll Number:** YOUR ROLL NUMBER

## A1
The clock stop value is `stopAt`, taken from the seeded settings in `main.dart`.

**My value:** [Write your actual stopAt value]

## A2
The number of `Clock.build()` calls from the first display until the clock stops.

**My observed count:** [Write the final Builds value shown in your app]

## A3
The number displayed on the left tile after removing the keys, tapping the left tile `tapsToMake` times, and pressing Swap.

**My observed value:** [Write your actual result]

## A4
The percentage is calculated using:

`floor(flexA / (flexA + flexB) * 100)`

**My result:** [Write your calculated percentage]

## B1. StatelessWidget and StatefulWidget
A `StatelessWidget` does not manage changing state of its own. A `StatefulWidget` uses a separate `State` object to manage changes, such as the number of times a tile is tapped.

## B2. Widget, Element and RenderObject
A Widget describes the UI. An Element represents a widget's position in the widget tree. A RenderObject handles layout and painting. The `Probe` widget uses `BuildContext` to inspect its location and check whether a `Scaffold` exists above it.

## B3. Constraints go down and sizes go up
In Flutter, parent widgets pass layout constraints down to their children, and children report their sizes back up. In Step 7, `Expanded` helps children share the available row width. In Step 8, `Expanded` and `Flexible` control how the buttons share available space.
