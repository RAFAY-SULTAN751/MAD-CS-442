# OOP Lab Answers
Name: Rafay Sultan
Roll no: 04072312037

1. A subclass using extends gets the parent's fields and method bodies for free, while a class using implements only gets the shape and must write every member itself.

2. I pick a mixin when unrelated classes need the same ready-made code (renew for Book and Dvd but not Magazine). I pick an abstract parent when the classes are the same kind of thing and share common state and a contract.

3. Equal objects must have equal hash codes because Sets and Maps use hashCode first to find the bucket. If only == is overridden, two equal objects can land in different buckets and be treated as different.

4. An extension just adds methods from outside and creates no new type, so it works on any String. A subclass of String is not possible because String is a final class in Dart and cannot be extended.