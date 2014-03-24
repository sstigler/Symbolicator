Symbolicator
============

Symbolicator is a Mac app for symbolicating crash reports. It leverages the built-in ```symbolicatecrash``` command-line tool that comes with Xcode to provide you, as an iOS or Mac developer, an easy-to-use graphical frontend for symbolicating crash reports that come in for your app.

Documentation
--------------

Symbolicator is really easy to use: Simply choose a .crash file, choose the .dSYM file for the build that the crash was reported on, and click the "Symbolicate" button. Symbolicator will show you the symbolicated crash report in a text view, and then give you the option to export it as a .crash file.


System Requirements
--------------------

Symbolicator is Mac-only. Tested on OS X v10.9 "Mavericks", but will likely also work on Mac OS X v10.7 "Lion" or later.
