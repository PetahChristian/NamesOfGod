# Names of God
This is the source code for the free **Names of God** iOS 8 app. It can be compiled with Xcode 6.1+ and it uses ARC.

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

## Design changes for iOS 8
* Use Universal storyboard
* Use Core Data

## New features for 1.1.0
* Add King James Version (KJV)
* Add separate entries for compound names
* Add support for iOS 8, iPhone 6 and iPhone 6 Plus
