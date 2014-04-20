# Names of God
This is the source code for the free **Names of God** iOS 7 app. It can be compiled with Xcode 5.1+ and it uses ARC.

The Names of God app lists over two hundred names of God from The Bible, and includes compound names for God.

* [Download the free Names of God app](https://itunes.apple.com/us/app/names-of-god-from-the-bible/id860449184?mt=8) from the App Store.

#### Life's Greatest Decision
For more information about forgiveness of sin, peace with God, and the gift of everlasting life, consider [Following Christ: Life's Greatest Decision](http://followchrist.ag.org/decision.cfm).

God bless you!

## License
This source code is distributed under [the MIT license](LICENSE.txt).

## Quoted scripture
Quoted scripture meets each publisher's fair use guidelines, and is properly cited as required.

## Custom fonts
The TeX Gyre Heros font family — a close alternative to Helvetica — provides the necessary small-caps variant to properly render <span style="font-variant: small-caps">Lord</span>.

As the TeX Gyre Heros OpenType fonts did not appear to encode their specific style and weight traits, I re-encoded them with the [Glyphs font editor](http://www.glyphsapp.com).  This enabled switching between the Regular, Bold, Italic, and Bold Italic custom fonts via `[UIFont fontWithDescriptor:...]`, and also cleared up a font metrics issue affecting the baseline position and lineHeight.

*The original fonts can be found at [GUST](http://www.gust.org.pl/projects/e-foundry/tex-gyre/heros/index.html).*

## Design choices for iOS 7 issues

### Swipe back gesture
The 'swipe from left edge' gesture (to navigate back to the previous screen) introduced a few new bugs for iOS 7.

* The ` clearsSelectionOnViewWillAppear` property no longer reliably works.  Swiping back slowly (or using the back button) clears the selection.  Swiping back quickly does ***not*** clear the selection.

	I chose to manually clear the selection in `-viewWillAppear:`.  This produces a nice selection fade, but the trade-off is that the selection is cleared, even if the swipe is cancelled.

* The master's first responder will lose focus if the swipe gesture is cancelled.  It also didn't seem natural for the keyboard to animate on top of (and obscure) the detail view while swiping back.

	I settled on dismissing the keyboard in the master view before pushing the detail view onto the navigation (and letting the master restore the keyboard after its view appeared).

### UISearchDisplayController
UISearchDisplayController would have been an ideal fit for the app, but is too broken in iOS 7 to work around every issue, which included `displaysSearchBarInNavigationBar` auto-rotation animation glitches, and dead areas for the Cancel button.

I ended up using a native UISearchBar control in the navigation bar's `titleView`.  Results filtering is handled by the model, freeing the master view controller from having to deal with a second (search results) tableView.

## Other design choices
* The (iPhone's) detail view can navigate up/down through the names of God.  Instead of asking the master for the model's previous/next row, it seemed less convoluted to let both controllers directly interact with a shared model.  The model data exists in a `YHWHNames` singleton.

* I initially used UILocalizedIndexedCollation to sort and section the list of names.  While this was the most flexible approach (for any future localization), I ended up pre-collating and sectioning the static plist, as it made state restoration much more responsive.