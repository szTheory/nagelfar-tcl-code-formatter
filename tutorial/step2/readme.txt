USING ANNOTATIONS

The first and easiest step to fix some false negatives is to add inline
annotations to give Nagelfar information that it needs.

This can be done directly in the source code or in a separate file.
In this example one annotation is done next to the proc it belongs to,
and one is done in the myproj.syntax file.

Having the proc annotation at the proc definition is rather clean but
if you prefer not to have annotations in your source that could be placed
in the separate file as well.

The syntax in those annotations is defined using syntax tokens. See that
documentation for details.

Also see the documentation page about call by name for more details about
the upvar situation in bepa2

Inline comments can also be used to ignore specific errors and many other
things. See the doc about inline comments for details.
