//
//  YHWHDetailViewController.m
//  NamesOfGod
//
//  Created by Peter Jensen on 2/18/14.
//  Copyright (c) 2014 Peter Christian Jensen.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "YHWHDetailViewController.h"

#import "YHWHName.h" // For the name custom object

#import "YHWHNames.h" // For the sharedNames (model) singleton

#import "UIFont+YHWHCustomFont.h" // For +yhwh_preferredCustomFontForTextStyle:

#import "UISegmentedControl+YHWHSegmentIndex.h" // For -yhwh_selectSegmentWithTitle:

#import "UITextView+YHWHContentOffset.h" // -yhwh_scrollToTopAndSetAttributedText:

#import "YHWHConstants.h" // For user defaults preference keys

@import CoreText; // For kLowerCaseType declaration

@interface YHWHDetailViewController ()
/**
 A weak reference to our storyboard's textView control.

 Displays content, such as name of God, meaning, and bible verse that uses the name.
 */
@property (nonatomic, weak) IBOutlet UITextView *textView;
/**
 A bible version segmented control.

 Displays names of selected/alternate bible translations.
*/
@property (nonatomic, strong) UISegmentedControl *versionSegmentedControl;
/**
 Copyright message corresponding to the selected bible version.
 */
@property (nonatomic, strong) NSString *versionCopyright;
/**
 The (custom) preferred headline font.
 */
@property (nonatomic, strong) UIFont *preferredHeadlineFont;
/**
 The (custom) preferred subheadline font, using the small-caps feature.
 */
@property (nonatomic, strong) UIFont *preferredSubheadlineFont;
/**
 The (custom) preferred body font.
 */
@property (nonatomic, strong) UIFont *preferredBodyFont;
/**
 The (custom) preferred footnote custom font, using the italic trait.
 */
@property (nonatomic, strong) UIFont *preferredFootnoteFont;

@end

@implementation YHWHDetailViewController

@synthesize indexPath = _indexPath;

@synthesize textView = _textView;
@synthesize versionSegmentedControl = _versionSegmentedControl;
@synthesize versionCopyright = _versionCopyright;
@synthesize preferredHeadlineFont = _preferredHeadlineFont;
@synthesize preferredSubheadlineFont = _preferredSubheadlineFont;
@synthesize preferredBodyFont = _preferredBodyFont;
@synthesize preferredFootnoteFont = _preferredFootnoteFont;

#pragma mark - Initialization

// Override to support custom initialization.
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        // Custom initialization
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(systemContentSizeChanged:)
                                                     name:UIContentSizeCategoryDidChangeNotification
                                                   object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIContentSizeCategoryDidChangeNotification
                                                  object:nil];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        // Add up/down arrow buttons for iPhone (to let the user navigate through the
        // names without having to return back to the master view)

        [self setupUpDownRightBarButtonItems];
    }

    // Add top, leading, and trailing padding to provide some white space around the
    // content

    self.textView.textContainerInset = UIEdgeInsetsMake(10.0f, 6.0f, 0.0f, 6.0f);

    // Using toolbarItems lets the controller manage its bottom layout guide, which
    // will control the content's edge insets. (This is doubly important for auto
    // rotation, as the iPhone's toolbar height changes depending on orientation.)

    [self setupBibleVersionToolbarItems];

    // Initialize preferred fonts, then display the detail content

    [self p_determinePreferredFonts];
    [self configureView];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.toolbarHidden = NO;
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.toolbarHidden = YES;
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private methods

- (void)p_determinePreferredFonts
{
    // Use Dynamic Type
    self.preferredHeadlineFont = [UIFont yhwh_preferredCustomFontForTextStyle:UIFontTextStyleHeadline];
    self.preferredSubheadlineFont = [UIFont yhwh_preferredCustomFontForTextStyle:UIFontTextStyleSubheadline];
    self.preferredBodyFont = [UIFont yhwh_preferredCustomFontForTextStyle:UIFontTextStyleBody];
    self.preferredFootnoteFont = [UIFont yhwh_preferredCustomFontForTextStyle:UIFontTextStyleFootnote];

    // Change the Footnote font's trait to italics

    UIFontDescriptor *descriptor = [self.preferredFootnoteFont fontDescriptor];
    UIFontDescriptorSymbolicTraits symbolicTraits = descriptor.symbolicTraits | UIFontDescriptorTraitItalic;
    self.preferredFootnoteFont = [UIFont fontWithDescriptor:[descriptor fontDescriptorWithSymbolicTraits:symbolicTraits]
                                                       size:0.0f];

    // Change the Subheadline font's variant to small-caps

    descriptor = [self.preferredSubheadlineFont fontDescriptor];
    NSArray *array = @[@{ UIFontFeatureTypeIdentifierKey : @(kLowerCaseType),
                          UIFontFeatureSelectorIdentifierKey : @(kLowerCaseSmallCapsSelector) }];
    descriptor = [descriptor fontDescriptorByAddingAttributes:@{ UIFontDescriptorFeatureSettingsAttribute : array }];
    self.preferredSubheadlineFont = [UIFont fontWithDescriptor:descriptor size:0.0f];
}

- (void)systemContentSizeChanged:(NSNotification *)__unused notification
{
    [self p_determinePreferredFonts];

    // Since the preferred fonts have changed (due to a content size change), update
    // our detail view

    [self configureView];
}

- (void)setupUpDownRightBarButtonItems
{
    UIBarButtonItem *upArrow = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"UIButtonBarArrowUp"]
                                                                style:UIBarButtonItemStyleBordered
                                                               target:self
                                                               action:@selector(upArrowPressed:)];

    UIBarButtonItem *downArrow = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"UIButtonBarArrowDown"]
                                                                  style:UIBarButtonItemStyleBordered
                                                                 target:self
                                                                 action:@selector(downArrowPressed:)];

    self.navigationItem.rightBarButtonItems = @[downArrow, upArrow];

    // Determine if we have more than one name (or not), and enable (or disable)
    // the up/down arrow buttons.

    [self tallyNameDataAndEnableOrDisableUpDownArrowBarButtonItems];
}

/**
 Setup a segmented control of bible versions, and add it to the toolbar
 */
- (void)setupBibleVersionToolbarItems
{
    self.versionSegmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"ESV",
                                                                               @"NASB",
                                                                               @"NIV",
                                                                               @"NKJV",
                                                                               @"NLT"]];
    self.versionSegmentedControl.opaque = NO;
    [self.versionSegmentedControl addTarget:self
                                     action:@selector(versionChanged:)
                           forControlEvents:UIControlEventValueChanged];

    UIBarButtonItem *bibleVersionItem = [[UIBarButtonItem alloc]
                                         initWithCustomView:(UIView *)self.versionSegmentedControl];
    bibleVersionItem.width = 300.0f;
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                           target:nil
                                                           action:nil];

    self.toolbarItems = @[flexibleSpace, bibleVersionItem, flexibleSpace];

    // Default to the last bible version that the user had selected

    NSString *version = [[NSUserDefaults standardUserDefaults] stringForKey:kYHWHUserVersionKey];

    [self.versionSegmentedControl yhwh_selectSegmentWithTitle:version];

    self.versionCopyright = [self copyrightForVersion:[self.versionSegmentedControl yhwh_titleForSelectedSegment]];
}

- (void)configureView
{
    // Update the user interface

    YHWHName *name = [[YHWHNames sharedNames] nameAtIndexPath:self.indexPath];

    if (!name)
    {
        // If there is no name, there is nothing to display in our detail view
        [self.textView yhwh_scrollToTopAndSetAttributedText:nil];
        return;
    }

    // Create an attributed string of name details to be displayed in the textView

    NSMutableAttributedString *styledText = [self headlineTextForName:name];

    // Append the bible verses and references

    [styledText appendAttributedString:[self bodyTextForName:name]];

    // Append any bible version copyright

    if ([self.versionCopyright length])
    {
        [styledText appendAttributedString:[self footnoteTextForVersionCopyright:self.versionCopyright]];
    }

    [self.textView yhwh_scrollToTopAndSetAttributedText:styledText];
}

/**
 Create a styled headline for the name

 @param aName The name details to display.

 @return The styled headline text.
 */
- (NSMutableAttributedString *)headlineTextForName:(YHWHName *)aName
{
    NSString *name = [NSString stringWithFormat:@"%@\n", [aName name]];

    NSMutableAttributedString *headline = [[NSMutableAttributedString alloc] initWithString:name];

    [headline addAttribute:NSFontAttributeName
                     value:self.preferredHeadlineFont
                     range:NSMakeRange(0, [headline length])];

    // Add any (optional) alternate name to the headline

    if ([[aName alternateName] length])
    {
        NSString *alternateName = [NSString stringWithFormat:@"%@\n", [aName alternateName]];

        NSMutableAttributedString *subheadline = [[NSMutableAttributedString alloc] initWithString:alternateName];

        [subheadline addAttribute:NSFontAttributeName
                            value:self.preferredSubheadlineFont
                            range:NSMakeRange(0, [subheadline length])];

        [headline appendAttributedString:subheadline];
    }

    return headline;
}

/**
 Create a styled body of verses for the name

 @param aName The name details to display.

 @return The styled text of verses.
 */
- (NSAttributedString *)bodyTextForName:(YHWHName *)aName
{
    // Setup an attributed string to hold our assembled set of styled verses and
    // bible references

    NSMutableAttributedString *body = [[NSMutableAttributedString alloc] init];

    // Setup a paragraph style attribute to right-align bible references

    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];

    [paragraphStyle setAlignment:NSTextAlignmentRight];

    // Add bible verse and reference pairs

    NSArray *verseAndReference = [self verseAtIndex:[aName verseIndex]];

    NSUInteger count = [verseAndReference count];

    for (NSUInteger index = 0; index < count; index++)
    {
        NSString *verseOrReferenceText = [NSString stringWithFormat:@"%@%@\n", (index % 2 ? @"—" : @"\n"),
                                          verseAndReference[index]];
        NSMutableAttributedString *verseOrReference = [[NSMutableAttributedString alloc]
                                                       initWithString:verseOrReferenceText];

        NSRange verseOrRefRange = NSMakeRange(0, [verseOrReference length]);

        [verseOrReference addAttribute:NSFontAttributeName value:self.preferredBodyFont range:verseOrRefRange];

        if (index % 2)
        {
            // Right-align bible references (odd indices)

            [verseOrReference addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:verseOrRefRange];
        }
        else
        {
            // Bible verses (even indices)

            verseOrReference = [self applySmallCapsToDelimitedText:verseOrReference];
        }

        [body appendAttributedString:verseOrReference];
    }

    return body;
}

/**
 Use the small caps variant for any text delimited by zero-width spaces

 @param text The bible verse text.

 @return The styled bible verse text.
 */
- (NSMutableAttributedString *)applySmallCapsToDelimitedText:(NSMutableAttributedString *)text
{
    // Setup the small caps font variant

    UIFontDescriptor *descriptor = [self.preferredBodyFont fontDescriptor];
    NSArray *array = @[@{ UIFontFeatureTypeIdentifierKey : @(kLowerCaseType),
                          UIFontFeatureSelectorIdentifierKey : @(kLowerCaseSmallCapsSelector) }];

    descriptor = [descriptor fontDescriptorByAddingAttributes:@{ UIFontDescriptorFeatureSettingsAttribute : array }];
    UIFont *smallCapsFont = [UIFont fontWithDescriptor:descriptor size:0.0f];

    NSUInteger textLength = [text length];
    NSRange textRange = NSMakeRange(0, textLength);

    // Look for any words (e.g., Lord) delimited by zero-width spaces, and display
    // them in small caps

    NSString *bracketedByDelimiter = @"\u200b[^\u200b]+\u200b";

    NSRange bracketedRange = [[text string] rangeOfString:bracketedByDelimiter
                                                  options:NSRegularExpressionSearch
                                                    range:textRange];

    while (bracketedRange.location != NSNotFound)
    {
        // Apply small-caps to this substring
        [text addAttribute:NSFontAttributeName value:smallCapsFont range:bracketedRange];

        // Advance the search range past the previous match
        textRange.location = bracketedRange.location + bracketedRange.length;

        if (textRange.location >= textLength)
        {
            // At end of string. Stop searching
            bracketedRange.location = NSNotFound;
        }
        else
        {
            // Adjust searchRange length
            textRange.length = textLength - textRange.location;
            // Check for another set of delimiters
            bracketedRange = [[text string] rangeOfString:bracketedByDelimiter
                                                  options:NSRegularExpressionSearch
                                                    range:textRange];
        }
    }

    return text;
}

/**
 Create a styled footnote for the bible version (copyright)

 @param versionCopyright The bible version copyright.

 @return The styled footnote copyright.
 */
- (NSAttributedString *)footnoteTextForVersionCopyright:(NSString *)versionCopyright
{
    NSString *footnoteCopyright = [NSString stringWithFormat:@"\n%@\n", versionCopyright];

    NSMutableAttributedString *footnote = [[NSMutableAttributedString alloc] initWithString:footnoteCopyright];

    [footnote addAttribute:NSFontAttributeName
                     value:self.preferredFootnoteFont
                     range:NSMakeRange(0, [footnote length])];

    return footnote;
}

- (void)downArrowPressed:(UIBarButtonItem *)__unused sender
{
    // Increment the indexPath, and display the next name.
    self.indexPath = [[YHWHNames sharedNames] indexPathAfterIndexPath:self.indexPath];
    [self configureView];
}

- (void)upArrowPressed:(UIBarButtonItem *)__unused sender
{
    // Decrement the indexPath, and display the previous name.
    self.indexPath = [[YHWHNames sharedNames] indexPathBeforeIndexPath:self.indexPath];
    [self configureView];
}

- (NSArray *)verseAtIndex:(NSUInteger)index
{
    NSString *version = [self.versionSegmentedControl yhwh_titleForSelectedSegment];
    NSString *versionFileName = [NSString stringWithFormat:@"YHWHVerses%@", version];
    NSString *versesPlistPath = [[NSBundle mainBundle] pathForResource:versionFileName ofType:@"plist"];

    NSArray *verses = [NSArray arrayWithContentsOfFile:versesPlistPath];

    if (index < [verses count])
    {
        return verses[index];
    }
    return nil;
}

- (NSString *)copyrightForVersion:(NSString *)version
{
    NSDictionary *copyright = @{
        @"ESV" : @"Scripture quotations are from The Holy Bible, English Standard Version® (ESV®). "
        "Copyright © 2001 by Crossway, a publishing ministry of Good News Publishers. "
        "Used by permission. All rights reserved.",
        @"NASB" : @"Scripture quotations are from the New American Standard Bible® (NASB®). "
        "Copyright © 1960, 1962, 1963, 1968, 1971, 1972, 1973, 1975, 1977, 1995 by The Lockman Foundation. "
        "Used by permission.",
        @"NIV"  : @"Scripture quotations are from The Holy Bible, New International Version® (NIV®). "
        "Copyright © 1973, 1978, 1984, 2011 by Biblica, Inc.® "
        "Used by permission. All rights reserved worldwide.",
        @"NKJV" : @"Scripture quotations are from the New King James Version® (NKJV®). "
        "Copyright © 1982 by Thomas Nelson, Inc. "
        "Used by permission. All rights reserved.",
        @"NLT"  : @"Scripture quotations are from the Holy Bible, New Living Translation® (NLT®). "
        "Copyright © 1996, 2004, 2007 by Tyndale House Foundation. "
        "Used by permission of Tyndale House Publishers, Inc., Carol Stream, Illinois 60188. All rights reserved."
    };

    return copyright[version];
}

- (void)versionChanged:(UISegmentedControl *)sender
{
    NSString *title = [sender yhwh_titleForSelectedSegment];

    // Save the new version in user defaults

    [[NSUserDefaults standardUserDefaults] setValue:title forKey:kYHWHUserVersionKey];

    // Change the copyright message to match the selected version

    self.versionCopyright = [self copyrightForVersion:title];

    [self configureView];
}

- (void)tallyNameDataAndEnableOrDisableUpDownArrowBarButtonItems
{
    // Determine if there is more than one name in nameData

    NSUInteger tally = 0;

    for (NSArray *section in [[YHWHNames sharedNames] nameData])
    {
        tally += [section count];
        if (tally > 1)
        {
            // Stop enumerating if there is more than one name
            break;
        }
    }

    // Enable or disable up/down arrow buttons, depending on tally (not) greater than
    // 1 (name)
    for (UIBarButtonItem *barButtonItem in self.navigationItem.rightBarButtonItems)
    {
        barButtonItem.enabled = (tally > 1);
    }
}

#pragma mark - UISplitViewController Protocol

- (BOOL) splitViewController:(UISplitViewController *)__unused splitViewController
    shouldHideViewController:(UIViewController *)__unused viewController
               inOrientation:(UIInterfaceOrientation)__unused orientation
{
    return NO;
}

#pragma mark - UIStateRestoring Protocol

static NSString * const kYHWHnameIDKey = @"yhwh_stateNameIdentifier";

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
    [super encodeRestorableStateWithCoder:coder];
    // Preserve a name identifier instead of an index path (as an index path may
    // change).
    NSString *nameIdentifier = [[YHWHNames sharedNames] modelIdentifierForElementAtIndexPath:self.indexPath];
    [coder encodeObject:nameIdentifier forKey:kYHWHnameIDKey];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder
{
    [super decodeRestorableStateWithCoder:coder];
    // Restore the index path, as the user may have moved up or down to a different
    // name.
    NSString *nameIdentifier = [coder decodeObjectForKey:kYHWHnameIDKey];
    self.indexPath = [[YHWHNames sharedNames] indexPathForElementWithModelIdentifier:nameIdentifier];
}

- (void)applicationFinishedRestoringState
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        // Restoration may have filtered the name data. Retally it (to enable or
        // disable the up/down arrows)
        [self tallyNameDataAndEnableOrDisableUpDownArrowBarButtonItems];
    }
    // Restore the detail view's content
    [self configureView];
}

@end
