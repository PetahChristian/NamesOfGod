//
//  YHWHMasterViewController.m
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

#import "YHWHMasterViewController.h"

#import "YHWHDetailViewController.h" // The iPad's detail view controller

#import "YHWHName.h" // For the name custom object

#import "YHWHNames.h" // For the sharedNames (model) singleton

#import "UIFont+YHWHCustomFont.h" // For +yhwh_preferredCustomFontForTextStyle:

@import CoreText; // For kLowerCaseType declaration

@interface YHWHMasterViewController () <UISearchBarDelegate, UIDataSourceModelAssociation>
/**
   A weak reference to our storyboard's UISearchBar control
 */
@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;
/**
   A reference to the right half (detail view controller) of the iPad's
      splitViewController.

   @note This property will be nil on the iPhone.
 */
@property (strong, nonatomic) YHWHDetailViewController *detailViewController;
/**
   A strong reference to the Done bar button item, so it can be removed when not
      searching

   We have to place our own button in lieu of using the searchBar's built-in
      one, as the navigationBar's constraints for the titleView leave a 8+ point
      gap (dead area) between any button and the trailing edge.
 */
@property (nonatomic, strong) UIBarButtonItem *doneBarButtonItem;
/**
   The (custom) preferred headline font.
 */
@property (nonatomic, strong) UIFont *tableViewCellTitlePreferredFont;
/**
   The (custom) preferred subtitle font.
 */
@property (nonatomic, strong) UIFont *tableViewCellSubtitlePreferredFont;
/**
   Restore first responder on viewDidAppear.

   @note This is a necessary workaround for an iOS 7 swipe back gesture issue,
      or we'd simply have left the master's keyboard visible before pushing the
      detail.
 */
@property (nonatomic, assign) BOOL restoreKeyboardOnViewDidAppear;
/**
   If restoring first responder, also restore this contentOffset on
      viewDidAppear (so the previously selected row is visible above the
      keyboard).
 */
@property (nonatomic, assign) CGPoint restoreContentOffsetOnViewDidAppear;

@end

@implementation YHWHMasterViewController

@synthesize searchBar = _searchBar;
@synthesize detailViewController = _detailViewController;
@synthesize doneBarButtonItem = _doneBarButtonItem;
@synthesize tableViewCellTitlePreferredFont = _tableViewCellTitlePreferredFont;
@synthesize tableViewCellSubtitlePreferredFont = _tableViewCellSubtitlePreferredFont;
@synthesize restoreKeyboardOnViewDidAppear = _restoreKeyboardOnViewDidAppear;
@synthesize restoreContentOffsetOnViewDidAppear = _restoreContentOffsetOnViewDidAppear;

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

- (void)awakeFromNib
{
    // Work around storyboard issue -- clearsSelectionOnViewWillAppear will
    // always be YES even if storyboard TableViewController Clear on appearance
    // is unchecked.
    // Work around swipe gesture issue -- while swiping back to the previous
    // controller, swiping slowly clears the selection, but swiping quickly
    // doesn't.
    self.clearsSelectionOnViewWillAppear = NO;
    [super awakeFromNib];
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

    // detailViewController will be nil on the iPhone
    self.detailViewController = (YHWHDetailViewController *)[[self.splitViewController.viewControllers lastObject]
                                                             topViewController];

    // Create a Done (right) bar button item, which we'll animate in when the
    // user searches for a name.

    self.doneBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                           target:self
                                                                           action:@selector(doneButtonClicked:)];

    // Change searchBar return key type from Search to Done

    for (UIView *subview in self.searchBar.subviews)
    {
        for (UIView *subSubview in subview.subviews)
        {
            if ([subSubview conformsToProtocol:@protocol(UITextInputTraits)])
            {
                UITextField *textField = (UITextField *)subSubview;
                textField.returnKeyType = UIReturnKeyDone;
                textField.enablesReturnKeyAutomatically = NO;
                break;
            }
        }
    }

    self.tableView.rowHeight = [self p_determineRowHeightForPreferredFont];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    // iOS 7 issue -- while swiping back to the previous controller, swiping
    // slowly clears the selection, but swiping quickly doesn't.

    // Manually deselect the selected row to consistently clear the selection.
    if (!self.detailViewController) // If not on the iPad, clear the selection
    {
        NSIndexPath *selectedRowIndexPath = [self.tableView indexPathForSelectedRow];
        // Note that this emulates Apple's (Settings and Contacts) behavior of
        // the clear selection animating as the swipe gesture slowly reveals our
        // tableView.
        // Also, like Apple's behavior, the selection will be cleared even if
        // the view did not appear completely. (I.e., a second swipe gesture
        // won't show a selection.)
        [self.tableView deselectRowAtIndexPath:selectedRowIndexPath animated:YES];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    // Swipe back gesture displays master's keyboard on top of detail view.  Since
    // this doesn't feel natural (and the first responder will be lost if the swipe
    // is cancelled), we wait to manually restore the keyboard (and contentOffset)
    // once the master view has completely appeared
    if (self.restoreKeyboardOnViewDidAppear)
    {
        [self.searchBar becomeFirstResponder];
        // Restore the old content offset, as the previously selected row may
        // now be under the keyboard
        [self.tableView setContentOffset:self.restoreContentOffsetOnViewDidAppear animated:YES];
        self.restoreKeyboardOnViewDidAppear = NO;
    }
    else
    {
        if (self.detailViewController)
        {
            // For the iPad, select a row and display its details
            NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
            if (!indexPath && (![YHWHNames sharedNames].filteringDone || [YHWHNames sharedNames].matchesExist))
            {
                // If no (selected) indexPath, assign a default one
                indexPath = [[YHWHNames sharedNames] indexPathForFirstName];
            }
            if (indexPath)
            {
                [self.tableView selectRowAtIndexPath:indexPath
                                            animated:NO
                                      scrollPosition:UITableViewScrollPositionNone];
                self.detailViewController.indexPath = indexPath;
                [self.detailViewController configureView];
            }
        }
    }
}

// Note that the searchBar will always have ended editing by this point. We have
// to capture the first responder state in prepareForSegue:
// Also note that the view is in a transition state where the searchBar has resigned
// first responder, but the keyboard hasn't performed its hide animation,
// and the tableView's bottom contentInset is still the height of the keyboard.
// - (void)viewWillDisappear:(BOOL)animated
// {
//    [super viewWillDisappear:animated];
// }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Scene management

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)__unused sender
{
    // Preserve the first responder state now, as the searchBar will lose focus
    self.restoreKeyboardOnViewDidAppear = [self.searchBar isFirstResponder];
    if (self.restoreKeyboardOnViewDidAppear)
    {
        // Preserve the contentOffset, so the visible row won't be under the
        // keyboard once it reappears
        self.restoreContentOffsetOnViewDidAppear = self.tableView.contentOffset;
    }
    // We have to resign first responder. Otherwise, a visible keyboard during
    // the swipe back gesture will trigger some iOS 7 animation issues
    [self.searchBar resignFirstResponder];
    if ([[segue identifier] isEqualToString:@"showDetail"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        [[segue destinationViewController] setIndexPath:[indexPath copy]];
    }
}

#pragma mark - Private methods

- (CGFloat)p_determineRowHeightForPreferredFont
{
    // Use Dynamic Type
    // Use the Headline pointSize with the Body weight.
    UIFont *font = [UIFont yhwh_preferredCustomFontForTextStyle:UIFontTextStyleHeadline];
    CGFloat pointSize = font.pointSize + 1.0f;
    UIFont *bodyFont = [UIFont yhwh_preferredCustomFontForTextStyle:UIFontTextStyleBody];
    UIFontDescriptor *bodyFontDesc = [bodyFont fontDescriptor];

    self.tableViewCellTitlePreferredFont = [UIFont fontWithDescriptor:bodyFontDesc size:pointSize];
    font = [UIFont yhwh_preferredCustomFontForTextStyle:UIFontTextStyleFootnote];
    pointSize = font.pointSize - 1.0f;
    NSDictionary *attributes = @{
        UIFontDescriptorFeatureSettingsAttribute: @[
            @{
                UIFontFeatureTypeIdentifierKey : @(kLowerCaseType),
                UIFontFeatureSelectorIdentifierKey : @(kLowerCaseSmallCapsSelector)
            }
        ]
    };
    self.tableViewCellSubtitlePreferredFont =
        [UIFont fontWithDescriptor:[bodyFontDesc fontDescriptorByAddingAttributes:attributes]
                              size:pointSize];
    CGFloat titlePointSize = self.tableViewCellTitlePreferredFont.pointSize;
    CGFloat subtitlePointSize = self.tableViewCellSubtitlePreferredFont.pointSize;
    CGFloat rowHeight = titlePointSize + subtitlePointSize + 14.0f;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
    return MAX(40.0f, rowHeight); // Enforce minimum rowHeight of 40 points

#pragma clang diagnostic pop
}

// Calculate a new row height when the content size changes

- (void)systemContentSizeChanged:(NSNotification *)__unused notification
{
    self.tableView.rowHeight = [self p_determineRowHeightForPreferredFont];
    // Save and restore the selected row
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    [self.tableView reloadData];
    [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
}

- (void)doneButtonClicked:(UIBarButtonItem *)__unused sender
{
    [self.searchBar resignFirstResponder];
}

#pragma mark - UITableviewDatasource Protocol

- (NSInteger)numberOfSectionsInTableView:(UITableView *)__unused tableView
{
    return [[[YHWHNames sharedNames] nameData] count];
}

- (NSInteger)tableView:(UITableView *)__unused tableView numberOfRowsInSection:(NSInteger)section
{
    if ([YHWHNames sharedNames].filteringDone && ![YHWHNames sharedNames].matchesExist && !section)
    {
        // If filtering, and no matches, we need to handle "No Results" case by
        // returning 3 rows for section 0
        return 3;
    }
    return [[[YHWHNames sharedNames] nameData][section] count];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)__unused tableView
{
    // Hide section index while searching/displaying search results
    return [YHWHNames sharedNames].filteringDone ? nil : [YHWHNames sharedNames].sectionIndexData;
}

- (NSString *)tableView:(UITableView *)__unused tableView titleForHeaderInSection:(NSInteger)section
{
    // Suppress section headers while searching
    return [YHWHNames sharedNames].filteringDone ? nil : [YHWHNames sharedNames].sectionIndexData[section];
}

- (NSInteger)         tableView:(UITableView *)__unused tableView
    sectionForSectionIndexTitle:(NSString *)__unused
    title               atIndex:(NSInteger)index
{
    // There is a direct mapping between the section index and table section
    return index;
}

- (UITableViewCell *)tableView:(UITableView *)__unused tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([YHWHNames sharedNames].filteringDone && ![YHWHNames sharedNames].matchesExist)
    {
        // Handle "No Results" case. Set the third cell (for the only section)
        // to "No Results"

        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"No Results" forIndexPath:indexPath];

        if ([indexPath row] == 2)
        {
            cell.textLabel.text = @"No Results";
            cell.textLabel.font = self.tableViewCellTitlePreferredFont;
        }
        else
        {
            cell.textLabel.text = nil;
        }

        return cell;
    }
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    YHWHName *theName = [[YHWHNames sharedNames] nameAtIndexPath:indexPath];

    cell.textLabel.text = [theName name];
    cell.textLabel.font = self.tableViewCellTitlePreferredFont;
    cell.detailTextLabel.text = [theName alternateName];
    cell.detailTextLabel.font = self.tableViewCellSubtitlePreferredFont;
    // Display a disclosure indicator for search results, if not on the iPad
    cell.accessoryType = ([YHWHNames sharedNames].isFilteringDone && !self.detailViewController)
        ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
    return cell;
}

- (BOOL)tableView:(UITableView *)__unused tableView canEditRowAtIndexPath:(NSIndexPath *)__unused indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

#pragma mark - UITableviewDelegate Protocol

- (void)tableView:(UITableView *)__unused tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // show detail on iPad if not filtering or matches exist

    if (![YHWHNames sharedNames].filteringDone || [YHWHNames sharedNames].matchesExist)
    {
        [self.detailViewController setIndexPath:indexPath];
        [self.detailViewController configureView];
    }
}

#pragma mark - UISearchBarDelegate Protocol

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)__unused searchBar
{
    // return NO to not become first responder

    [self.navigationItem setRightBarButtonItem:self.doneBarButtonItem animated:YES];
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)__unused searchBar
{
    // return NO to not resign first responder

    [self.navigationItem setRightBarButtonItem:nil animated:YES];
    return YES;
}

- (void)searchBar:(UISearchBar *)__unused searchBar textDidChange:(NSString *)searchText
{
    // called when text changes (including clear)

    // Don't try to "clear" old results, as the tableView is displaying that old
    // model data; we don't want to create any inconsistencies if the user
    // scrolled the table.

    [[YHWHNames sharedNames] setFilterText:searchText];
    self.tableView.contentOffset = CGPointMake(0, 0 - self.tableView.contentInset.top);
    [self.tableView reloadData];
    if (self.detailViewController && !self.restoreKeyboardOnViewDidAppear)
    {
        // select row and show detail on iPad

        NSIndexPath *nameIndexPath = [[YHWHNames sharedNames] indexPathForFirstName];
        self.detailViewController.indexPath = nameIndexPath;
        [self.detailViewController configureView];
        [self.tableView selectRowAtIndexPath:nameIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    // called when keyboard search button pressed

    [searchBar resignFirstResponder];
}

#pragma mark - UIStateRestoring Protocol

/**
 self.searchBar.text
 */
static NSString * const kYHWHsearchTextKey  = @"yhwh_stateSearchText";
/**
 [self.searchBar isFirstResponder]
 */
static NSString * const kYHWHisResponderKey = @"yhwh_stateSearchFirstResponder";
/**
 self.restoreKeyboardOnViewDidAppear
 */
static NSString * const kYHWHkeyboardKey    = @"yhwh_stateRestoreFirstResponder";
/**
 self.restoreContentOffsetOnViewDidAppear
 */
static NSString * const kYHWHoffsetKey      = @"yhwh_stateRestoreContentOffset";

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
    // Handle an edge case where state restoration sets the tableView's
    // contentOffset to a post-keyboard (scrolled) value, before the keyboard is
    // visible (on the iPad).
    // When the contentSize is smaller than the screen size, the content will
    // bounce back before the keyboard appears, losing the restored offset.

    if (self.detailViewController && [self.searchBar.text length] && [self.searchBar isFirstResponder])
    {
        // Preserve the contentOffset so we can restore it after the keyboard
        // appears
        self.restoreKeyboardOnViewDidAppear = YES;
        self.restoreContentOffsetOnViewDidAppear = self.tableView.contentOffset;
    }

    [super encodeRestorableStateWithCoder:coder];
    // Preserve the search text, as well as searchBar's first responder state
    [coder encodeObject:self.searchBar.text forKey:kYHWHsearchTextKey];
    [coder encodeBool:[self.searchBar isFirstResponder] forKey:kYHWHisResponderKey];

    [coder encodeBool:self.restoreKeyboardOnViewDidAppear forKey:kYHWHkeyboardKey];
    if (self.restoreKeyboardOnViewDidAppear)
    {
        // Also save the contentOffset while the keyboard was shown (so the
        // selected row won't be hidden under the keyboard)
        [coder encodeCGPoint:self.restoreContentOffsetOnViewDidAppear forKey:kYHWHoffsetKey];
    }

    // Never display a snapshot, as the snapshot makes the UI appear live but
    // "unresponsive" until restoration is finished
    [[UIApplication sharedApplication] ignoreSnapshotOnNextApplicationLaunch];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder
{
    if (self.detailViewController)
    {
        // Clear default (first row) selection, and let state restoration
        // restore previous selection
        NSIndexPath *selectedRowIndexPath = [self.tableView indexPathForSelectedRow];
        [self.tableView deselectRowAtIndexPath:selectedRowIndexPath animated:NO];
    }

    [super decodeRestorableStateWithCoder:coder];
    // Restore the search bar's search text, as well as firstResponder state
    self.searchBar.text = [coder decodeObjectForKey:kYHWHsearchTextKey];
    BOOL searchBarIsFirstResp = [coder decodeBoolForKey:kYHWHisResponderKey];
    self.restoreKeyboardOnViewDidAppear = [coder decodeBoolForKey:kYHWHkeyboardKey];
    if (self.restoreKeyboardOnViewDidAppear)
    {
        // Also restore the contentOffset while the keyboard was shown (so the
        // selected row won't be hidden under the keyboard)
        self.restoreContentOffsetOnViewDidAppear = [coder decodeCGPointForKey:kYHWHoffsetKey];
    }

    // Populate the filteredNameData by invoking the searchBar's textDidChange
    // delegate

    if ([self respondsToSelector:@selector(searchBar:textDidChange:)])
    {
        [self searchBar:self.searchBar textDidChange:self.searchBar.text];
    }

    if (searchBarIsFirstResp && !self.restoreKeyboardOnViewDidAppear)
    {
        // Set the searchBar as first responder
        [self.searchBar becomeFirstResponder];
    }
}

#pragma mark - UIDataSourceModelAssociation Protocol

- (NSIndexPath *)indexPathForElementWithModelIdentifier:(NSString *)identifier inView:(UIView *)__unused view
{
    return [[YHWHNames sharedNames] indexPathForElementWithModelIdentifier:identifier];
}

- (NSString *)modelIdentifierForElementAtIndexPath:(NSIndexPath *)indexPath inView:(UIView *)__unused view
{
    return [[YHWHNames sharedNames] modelIdentifierForElementAtIndexPath:indexPath];
}

@end
