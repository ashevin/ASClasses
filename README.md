ASClasses
=========

This repository includes a random collection of classes.  Some are used in production code.  Many are experiments.  All are usable.

Classes of Note
---------------
	ASLineSegmentRecognizer: This class recognizes a series of line segments drawn in a single gesture.  It uses a list of rules to determine if the gesture has matched.  This repository includes sample rules for matching letters of the alphabet.
	
	ASDrawerView: This class provides a view with an attached pull tab.  The tab can be used to pull the drawer open, or push it closed.  In this implementation, the view always anchors to the bottom of its parent.
	
	ASTriangleButton: A simple UIControl descendant that draws a triangle.  The angle and size of the triangle are configurable, as well as the color.
	
	ASHitTester: This class determines in which region a given point lies.  A bitmap is provided that outlines regions in black.  A list of points which lie inside the region are provided for each region.  This class does the hard work of figuring out if a given point lies within any of the defined zones.
