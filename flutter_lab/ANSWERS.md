Name: Rafay Sultan
Roll no: 04072312037

A1: 4
A2: 10
A3: 12
A4: 38

B1: LabApp, HomePage, StudentCard and GoalBanner are Stateless because they only draw the data they are given and never change by themselves. Tally, Countdown and BuggyCounter are Stateful because they keep data that changes over time, and the screen must update when it changes.

B2: The Timer keeps running even after the widget is removed. If it is not cancelled in dispose(), it keeps calling setState() on a State that no longer exists, which causes the "setState() called after dispose()" error and a memory leak.

B3: Const can be used on the MaterialApp in LabApp, HomePage(), Tally(), Countdown(), BuggyCounter(), the SizedBox widgets, EdgeInsets, Duration, Text('Reset') and Text('Time is up!'). StudentCard, GoalBanner and the Texts with seeded values cannot be const because their values are computed at runtime. Const buys fewer rebuilds and less memory, because Flutter reuses the same widget object.