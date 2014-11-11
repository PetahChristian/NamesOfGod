//
//  YHWHDetailViewController.m
//  NamesOfGod
//
//  Created by Peter Jensen on 9/18/14.
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

#import "UIFont+YHWHCustomFont.h" // For +yhwh_preferredCustomFontForTextStyle:

#import "UISegmentedControl+YHWHSegmentIndex.h" // For -yhwh_selectSegmentWithTitle:

#import "YHWHConstants.h" // For user defaults preference keys

#import "YHWHName.h"
#import "YHWHVerse.h"

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
 (Abbreviation for) The selected bible version.
 */
@property (nonatomic, strong) NSString *selectedVersion;
/**
 Key for the selected bible version.
 */
@property (nonatomic, strong) NSString *selectedVersionKey;
/**
 Copyright message corresponding to the selected bible version.
 */
@property (nonatomic, strong) NSString *versionCopyright;
/**
 The (custom) preferred headline font
 */
@property (nonatomic, strong) UIFont *titlePreferredFont;
/**
 The (custom) preferred headline small caps font
 */
@property (nonatomic, strong) UIFont *smallCapsTitlePreferredFont;
/**
 The (custom) preferred body font.
 */
@property (nonatomic, strong) UIFont *bodyPreferredFont;
/**
 The (custom) preferred footnote font, using the italic trait.
 */
@property (nonatomic, strong) UIFont *footnotePreferredFont;

@end

@implementation YHWHDetailViewController

@synthesize indexPath = _indexPath;
@synthesize dataSource = _dataSource;

@synthesize textView = _textView;
@synthesize versionSegmentedControl = _versionSegmentedControl;
@synthesize selectedVersion = _selectedVersion;
@synthesize selectedVersionKey = _selectedVersionKey;
@synthesize versionCopyright = _versionCopyright;
@synthesize titlePreferredFont = _titlePreferredFont;
@synthesize smallCapsTitlePreferredFont = _smallCapsTitlePreferredFont;
@synthesize bodyPreferredFont = _bodyPreferredFont;
@synthesize footnotePreferredFont = _footnotePreferredFont;

#pragma mark - Initialization

// Override to support custom initialization.
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        // Custom initialization
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(contentSizeChanged:)
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

    // Add up/down arrow buttons for collapsed detail view (to let the user navigate
    // through the names without having to return back to the master view)

    [self setupUpDownRightBarButtonItems];

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
    [super viewWillAppear:animated];
    [self adjustViewControllerTitleForHorizontalSizeClass:self.view.traitCollection.horizontalSizeClass];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Public methods

- (void)configureView
{
    if (![self.dataSource respondsToSelector:@selector(nameAtIndexPath:)])
    {
        return;
    }

    // Ask our data source for the name at our index path

    YHWHName *name = [self.dataSource nameAtIndexPath:self.indexPath];

    if (!name)
    {
        // Fall back to the first name in the list

        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];

        name = [self.dataSource nameAtIndexPath:indexPath];

        if (!name)
        {
            // No name (likely due to no results).  There is nothing to display in our detail view
            self.textView.attributedText = nil;
            return;
        }
        else
        {
            self.indexPath = indexPath; // The fallback index path is valid
        }
    }

    // Update the user interface

    [self displayDetailsForName:name];
}

- (void)enableOrDisableUpDownArrowBarButtonItems
{
    if (![self.dataSource respondsToSelector:@selector(numberOfNames)])
    {
        return;
    }

    NSUInteger numberOfNames = [self.dataSource numberOfNames];

    // Enable or disable up/down arrow buttons, depending on number of names

    BOOL enabled = (numberOfNames > 1);

    for (UIBarButtonItem *barButtonItem in self.navigationItem.rightBarButtonItems)
    {
        barButtonItem.enabled = enabled;
    }
}

#pragma mark - <UITraitEnvironment>

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection
{
    if (self.view.traitCollection.horizontalSizeClass != previousTraitCollection.horizontalSizeClass)
    {
        [self adjustViewControllerTitleForHorizontalSizeClass:self.view.traitCollection.horizontalSizeClass];
    }
}

#pragma mark - <UIStateRestoring>

static NSString *IndexPathKey = @"IndexPathKey";

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
    [super encodeRestorableStateWithCoder:coder];
    // Since the database is static (and the app won't restore state from a previous
    // build, it's safe to rely on restoring from an indexPath between launches.

    // encode the indexPath
    [coder encodeObject:self.indexPath forKey:IndexPathKey];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder
{
    [super decodeRestorableStateWithCoder:coder];

    // Restore the index path
    self.indexPath = [coder decodeObjectForKey:IndexPathKey];
}

- (void)applicationFinishedRestoringState
{
    if ([[[self.splitViewController viewControllers] firstObject] isKindOfClass:[UINavigationController class]])
    {
        UINavigationController *primaryViewController = [[self.splitViewController viewControllers] firstObject];

        if ([[[primaryViewController viewControllers] firstObject] isKindOfClass:[YHWHMasterViewController class]])
        {
            // Restore the detail view's data source
            self.dataSource = [[primaryViewController viewControllers] firstObject];
        }
    }

    self.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
    self.navigationItem.leftItemsSupplementBackButton = YES;

    // State restoration may have filtered the name data.
    [self enableOrDisableUpDownArrowBarButtonItems];

    // Restore the detail view's content
    [self configureView];
}

#pragma mark - Notification handlers

- (void)contentSizeChanged:(NSNotification *)__unused notification
{
    [self p_determinePreferredFonts];

    // Since the preferred fonts have changed (due to a content size change), update
    // our detail view

    [self configureView];
}

#pragma mark - Actions

- (void)versionChanged:(UISegmentedControl *)sender
{
    self.selectedVersion = [sender yhwh_titleForSelectedSegment];
    self.selectedVersionKey = [NSString stringWithFormat:@"text%@", self.selectedVersion];

    // Save the new version in user defaults

    [[NSUserDefaults standardUserDefaults] setValue:self.selectedVersion forKey:kYHWHUserVersionKey];

    // Change the copyright message to match the selected version

    self.versionCopyright = [self copyrightForVersion:self.selectedVersion];

    [self configureView];
}

- (IBAction)displayNextName
{
    if ([self.dataSource respondsToSelector:@selector(indexPathAfterIndexPath:)])
    {
        // Increment the indexPath, and display the next name.
        self.indexPath = [self.dataSource indexPathAfterIndexPath:self.indexPath];
        [self configureView];
    }
}

- (IBAction)displayPreviousName
{
    if ([self.dataSource respondsToSelector:@selector(indexPathBeforeIndexPath:)])
    {
        // Decrement the indexPath, and display the previous name.
        self.indexPath = [self.dataSource indexPathBeforeIndexPath:self.indexPath];
        [self configureView];
    }
}

#pragma mark - Private methods

- (void)p_determinePreferredFonts
{
    // Use Dynamic Type

    self.titlePreferredFont = [UIFont yhwh_preferredCustomFontForTextStyle:UIFontTextStyleHeadline];

    // Create small-caps title variant

    NSArray *fontFeatureSettings = @[
                                     @{
                                         UIFontFeatureTypeIdentifierKey : @(kLowerCaseType),
                                         UIFontFeatureSelectorIdentifierKey : @(kLowerCaseSmallCapsSelector)
                                         },
                                     ];

    NSDictionary *attributes = @{
                                 UIFontDescriptorFeatureSettingsAttribute: fontFeatureSettings
                                 };

    UIFontDescriptor *fontDesc = self.titlePreferredFont.fontDescriptor;

    fontDesc = [fontDesc fontDescriptorByAddingAttributes:attributes]; // enable small caps feature

    self.smallCapsTitlePreferredFont = [UIFont fontWithDescriptor:fontDesc size:[self.titlePreferredFont pointSize]];

    self.bodyPreferredFont = [UIFont yhwh_preferredCustomFontForTextStyle:UIFontTextStyleBody];

    self.footnotePreferredFont = [UIFont yhwh_preferredCustomFontForTextStyle:UIFontTextStyleFootnote];

    // Change the Footnote font's trait to italics

    fontDesc = [self.footnotePreferredFont fontDescriptor];
    UIFontDescriptorSymbolicTraits symbolicTraits = fontDesc.symbolicTraits | UIFontDescriptorTraitItalic;
    self.footnotePreferredFont = [UIFont fontWithDescriptor:[fontDesc fontDescriptorWithSymbolicTraits:symbolicTraits]
                                                       size:0.0f];
}

- (void)adjustViewControllerTitleForHorizontalSizeClass:(UIUserInterfaceSizeClass)horizontalSizeClass
{
    NSString *viewControllerTitle = nil;

    switch (horizontalSizeClass)
    {
        case UIUserInterfaceSizeClassRegular:
            viewControllerTitle = @"Names of God";
            break;
        case UIUserInterfaceSizeClassCompact:
        case UIUserInterfaceSizeClassUnspecified:
            viewControllerTitle = @"God";
            break;
    }
    self.title = viewControllerTitle;
}

- (void)setupUpDownRightBarButtonItems
{
    UIBarButtonItem *upArrow = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"UIButtonBarArrowUp"]
                                                                style:UIBarButtonItemStylePlain
                                                               target:self
                                                               action:@selector(displayPreviousName)];

    UIBarButtonItem *downArrow = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"UIButtonBarArrowDown"]
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(displayNextName)];

    self.navigationItem.rightBarButtonItems = @[downArrow, upArrow];

    // Determine if we have more than one name (or not), and enable (or disable)
    // the up/down arrow buttons.

    [self enableOrDisableUpDownArrowBarButtonItems];
}

/**
 Setup a segmented control of bible versions, and add it to the toolbar
 */
- (void)setupBibleVersionToolbarItems
{
    self.versionSegmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"ESV",
                                                                               @"KJV",
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

    self.selectedVersion = [self.versionSegmentedControl yhwh_titleForSelectedSegment];

    self.selectedVersionKey = [NSString stringWithFormat:@"text%@", self.selectedVersion];

    self.versionCopyright = [self copyrightForVersion:self.selectedVersion];
}

- (void)displayDetailsForName:(YHWHName *)name
{
    // Create an attributed string of name details to be displayed in the textView

    NSMutableAttributedString *styledText = [self headlineTextForName:name];

    // Append the bible verses and references

    [styledText appendAttributedString:[self bodyTextForName:name]];

    // Append any bible version copyright

    if ([self.versionCopyright length])
    {
        [styledText appendAttributedString:[self footnoteTextForVersionCopyright:self.versionCopyright]];
    }

    self.textView.attributedText = styledText;
}

/**
 Create a styled headline for the name

 @param aName The name details to display.

 @return The styled headline text.
 */
- (NSMutableAttributedString *)headlineTextForName:(YHWHName *)aName
{
    NSString *name = [NSString stringWithFormat:@"%@\n", [aName name]];

    NSMutableAttributedString *headline = [[NSMutableAttributedString alloc] initWithString:name
                                                                                 attributes:@{NSFontAttributeName : [aName smallCapsValue] ? self.smallCapsTitlePreferredFont : self.titlePreferredFont}];

    // Also display any other related names

    YHWHName *nextName = [aName nextRelatedName];

    while (nextName && nextName != aName) // Stop once the linked list has wrapped around to the initial name
    {
        name = [NSString stringWithFormat:@"%@\n", [nextName name]];

        [headline appendAttributedString:[[NSAttributedString alloc] initWithString:name
                                                                         attributes:@{NSFontAttributeName : [nextName smallCapsValue] ? self.smallCapsTitlePreferredFont : self.titlePreferredFont}]];
        nextName = nextName.nextRelatedName; // Advance to the next name in the list
    }

    [headline appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];

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

    // Add bible verse(s)

    BOOL initialVerse = YES;

    for (YHWHVerse *verse in aName.versesWithName)
    {
        // Append verse

        [body appendAttributedString:[self applySmallCapsToDelimitedText:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@\n",
                                                                                                                            initialVerse ? @"" : @"\n",
                                                                                                                            [verse valueForKey:self.selectedVersionKey]]
                                                                                                                attributes:@{NSFontAttributeName : self.bodyPreferredFont}]]];

        // Append reference

        [body appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"—%@ %@\n", [verse reference], self.selectedVersion]
                                                                     attributes:@{NSFontAttributeName : self.bodyPreferredFont,
                                                                                  NSParagraphStyleAttributeName : paragraphStyle}]];
        initialVerse = NO;
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

    UIFontDescriptor *descriptor = [self.bodyPreferredFont fontDescriptor];
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
                     value:self.footnotePreferredFont
                     range:NSMakeRange(0, [footnote length])];

    return footnote;
}

- (NSString *)copyrightForVersion:(NSString *)version
{
    NSDictionary *copyright = @{
                                @"ESV" : @"Scripture quotations are from The Holy Bible, English Standard Version® (ESV®). "
                                "Copyright © 2001 by Crossway, a publishing ministry of Good News Publishers. "
                                "Used by permission. All rights reserved.",
                                @"KJV" : @"Scripture quotations are from The Authorized (King James) Version (KJV). "
                                "Rights in the Authorized Version in the United Kingdom are vested in the Crown. "
                                "Used by permission of the Crown’s patentee, Cambridge University Press.",
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

@end
