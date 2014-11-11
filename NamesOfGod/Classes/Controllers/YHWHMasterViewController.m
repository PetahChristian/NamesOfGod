//
//  YHWHMasterViewController.m
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

#import "YHWHMasterViewController.h"
#import "YHWHDetailViewController.h"

#import "YHWHName.h"

#import "UIFont+YHWHCustomFont.h" // For +yhwh_preferredCustomFontForTextStyle:

@import CoreText; // For kLowerCaseType declaration

@interface YHWHMasterViewController () <UISearchBarDelegate, UISearchResultsUpdating>
/**
 A strong reference to our UISearchBar
 */
@property (nonatomic, strong) UISearchBar *searchBar;
/**
 A strong reference to the Done bar button item, so it can be removed when not
 searching

 We have to place our own button in lieu of using the searchBar's built-in
 one, as the navigationBar's constraints for the titleView leave a 8+ point
 gap (dead area) between any button and the trailing edge.
 */
@property (nonatomic, strong) UIBarButtonItem *doneBarButtonItem;
/**
 The (custom) preferred headline font
 */
@property (nonatomic, strong) UIFont *titlePreferredFont;
/**
 The (custom) preferred headline small caps font
 */
@property (nonatomic, strong) UIFont *smallCapsTitlePreferredFont;
/**
 The (custom) preferred subtitle small caps font.
 */
@property (nonatomic, strong) UIFont *smallCapsSubtitlePreferredFont;

@end

@implementation YHWHMasterViewController

@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize managedObjectContext = _managedObjectContext;

@synthesize searchBar = _searchBar;
@synthesize doneBarButtonItem = _doneBarButtonItem;
@synthesize titlePreferredFont = _titlePreferredFont;
@synthesize smallCapsTitlePreferredFont = _smallCapsTitlePreferredFont;
@synthesize smallCapsSubtitlePreferredFont = _smallCapsSubtitlePreferredFont;

#pragma mark - Initialization

// Override to support custom initialization.
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        // Custom initialization
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        [notificationCenter addObserver:self
                               selector:@selector(contentSizeChanged:)
                                   name:UIContentSizeCategoryDidChangeNotification
                                 object:nil];
        [notificationCenter addObserver:self
                               selector:@selector(keyboardWillShow:)
                                   name:UIKeyboardWillShowNotification
                                 object:nil];
        [notificationCenter addObserver:self
                               selector:@selector(keyboardWillHide:)
                                   name:UIKeyboardWillHideNotification
                                 object:nil];

        // Manage showing/hiding disclosure indicator as the detail view controller target changes (e.g. due to autorotation)

        [notificationCenter addObserver:self
                               selector:@selector(showDetailTargetDidChange:)
                                   name:UIViewControllerShowDetailTargetDidChangeNotification
                                 object:nil];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
}

- (void)dealloc
{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self name:UIContentSizeCategoryDidChangeNotification object:nil];
    [notificationCenter removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [notificationCenter removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [notificationCenter removeObserver:self name:UIViewControllerShowDetailTargetDidChangeNotification object:nil];

}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    [self setupSearchBar];

    self.tableView.rowHeight = UITableViewAutomaticDimension;

    self.tableView.estimatedRowHeight = [self p_determineRowHeightForPreferredFont];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    // Hide the keyboard when the master view disappears

    if ([self.searchBar isFirstResponder])
    {
        [self.searchBar resignFirstResponder];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Getters and setters

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil)
    {
        return _fetchedResultsController;
    }

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[YHWHName entityInManagedObjectContext:self.managedObjectContext]];

    // Setting a fetchLimit or fetchBatchSize will have no effect while caching.

    [fetchRequest setFetchBatchSize:20];

    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"normalizedName" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];

    [fetchRequest setSortDescriptors:sortDescriptors];

    // nil for section name key path means "no sections".

    NSString *cacheName = @"normalizedName";

    if (self.searchBar.text.length > 0)
    {
        // [n] for performance optimization since strings are normalized

        NSString *start = [self.searchBar.text lowercaseString];
        NSString *stop = [start stringByAppendingString:@"~"];

        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(normalizedName >= %@ AND normalizedName <= %@) OR normalizedName CONTAINS[n] %@", start, stop, start];
        [fetchRequest setPredicate:predicate];
        cacheName = nil;
    }

    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:cacheName cacheName:cacheName];
    aFetchedResultsController.delegate = self;
    _fetchedResultsController = aFetchedResultsController;

    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error])
    {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedResultsController;
}

#pragma mark - Scene management

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetailFromBasic"] || [[segue identifier] isEqualToString:@"showDetailFromSubtitle"])
    {
        if ([self.searchBar isFirstResponder])
        {
            [self.searchBar resignFirstResponder];
        }
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        YHWHDetailViewController *controller = (YHWHDetailViewController *)[[segue destinationViewController] topViewController];
        controller.dataSource = self;
        controller.indexPath = indexPath;
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}

#pragma mark - <UITableviewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self isSearchingAndNoResults] ? 1 : [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self isSearchingAndNoResults] ? 3 : [[self.fetchedResultsController sections][section] numberOfObjects];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return [self isSearchingAndNoResults] ? nil : [self.fetchedResultsController sectionIndexTitles];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return [self.fetchedResultsController sectionForSectionIndexTitle:title atIndex:index];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self isSearchingAndNoResults])
    {
        // Handle "No Results" case. Set the third cell (for the only section)
        // to "No Results"

        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"No Results" forIndexPath:indexPath];

        cell.textLabel.text = ([indexPath row] == 2) ? @"No Results" : @"";
        cell.textLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];

        // Work around for changing text resets existing formatting.
        // See rdar://14125345

        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.textColor = [UIColor colorWithWhite:0.8f alpha:1.0f];

        return cell;
    }
    else
    {
        YHWHName *name = [self.fetchedResultsController objectAtIndexPath:indexPath];

        // Work around for iOS 8 detailTextLabel not visible if previously nil.
        // See rdar://17682058 (Filed rdar://18397397 Duplicate)

        NSString *cellIdentifier = @"Basic";

        if (name.romanizedName)
        {
            cellIdentifier = @"Subtitle";
        }

        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];

        cell.textLabel.text = name.name;
        cell.textLabel.font = name.smallCapsValue ? self.smallCapsTitlePreferredFont : self.titlePreferredFont;

        if (name.romanizedName)
        {
            cell.detailTextLabel.text = name.romanizedName;
            cell.detailTextLabel.font = self.smallCapsSubtitlePreferredFont;
        }
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Only show a disclosure indicator if collapsed and searching and there are results

    BOOL showDisclosureIndicator = self.splitViewController.collapsed && [self.searchBar.text length] && [self numberOfNames];

    cell.accessoryType = showDisclosureIndicator ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;

    // Deselect any row selection if collapsed
    if (cell.selected && self.splitViewController.collapsed)
    {
        [cell setSelected:NO animated:YES];
    }

    // Work around for iPhone 6+ left separatorInset varies depending on orientation
    // 16.0 for iOS 8 Xcode 6, was 15.0 for iOS 7 Xcode 5

    cell.separatorInset = UIEdgeInsetsMake(0.0, 16.0, 0.0, 0.0);
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

#pragma mark - <YHWHNameDataSource>

- (YHWHName *)nameAtIndexPath:(NSIndexPath *)indexPath
{
    YHWHName *name = nil;

    NSUInteger section = [indexPath section];

    if (indexPath && section < [[self.fetchedResultsController sections] count])
    {
        id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];

        NSUInteger row = [indexPath row];
        if (row < [sectionInfo numberOfObjects])
        {
            name = [self.fetchedResultsController objectAtIndexPath:indexPath];
        }
    }
    return name;
}

- (NSIndexPath *)indexPathAfterIndexPath:(NSIndexPath *)indexPath
{
    // Return if indexPath is nil, or no results exist
    if (!indexPath || ![[self.fetchedResultsController fetchedObjects] count])
    {
        return nil;
    }

    NSUInteger section = [indexPath section];
    NSUInteger row = [indexPath row] + 1;

    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForRow:row inSection:section];

    if ([self nameAtIndexPath:nextIndexPath])
    {
        // There was another row in the current section.
        return nextIndexPath;
    }

    // There are no more rows in the current section. Set the row to 0, and increment
    // the section.

    row = 0;
    section++;

    while (1)
    {
        nextIndexPath = [NSIndexPath indexPathForRow:row inSection:section];

        if ([self nameAtIndexPath:nextIndexPath])
        {
            // There is one more section, and it is not empty
            break;
        }

        // If there was not one more section, wrap the section around to 0
        if (section >= [[self.fetchedResultsController sections] count])
        {
            section = 0;
            nextIndexPath = [NSIndexPath indexPathForRow:row inSection:section];

            if ([self nameAtIndexPath:nextIndexPath])
            {
                // Section 0 is not empty
                break;
            }
        }
        // This section is empty. Try the next one.
        section++;
    }

    return nextIndexPath;
}

- (NSIndexPath *)indexPathBeforeIndexPath:(NSIndexPath *)indexPath
{
    // Return if indexPath is nil, or no results exist
    if (!indexPath || ![[self.fetchedResultsController fetchedObjects] count])
    {
        return nil;
    }

    NSUInteger section = [indexPath section];
    NSUInteger row = [indexPath row];

    NSIndexPath *prevIndexPath = [NSIndexPath indexPathForRow:row - 1 inSection:section];

    if ([self nameAtIndexPath:prevIndexPath])
    {
        // There is a preceeding row in the current section.
        return prevIndexPath;
    }

    // There are no preceeding rows in the current section. Decrement the section,
    // and determine the new row value.

    while (1)
    {
        if (section > 0)
        {
            // Decrement the section count, then adjust the row number to the last
            // row for the section
            section--;
            row = [[self.fetchedResultsController sections][section] numberOfObjects] - 1;

            prevIndexPath = [NSIndexPath indexPathForRow:row inSection:section];

            if ([self nameAtIndexPath:prevIndexPath])
            {
                // There was a row in the preceeding section.
                break;
            }
        }

        // If there was no preceeding section, wrap the section around to the final
        // section
        if (section == 0)
        {
            section = [[self.fetchedResultsController sections] count] - 1;
            row = [[self.fetchedResultsController sections][section] numberOfObjects] - 1;

            prevIndexPath = [NSIndexPath indexPathForRow:row inSection:section];

            if ([self nameAtIndexPath:prevIndexPath])
            {
                // There was a row in the final section.
                break;
            }
        }
        // This section is empty. Try the preceeding one.
    }

    return prevIndexPath;
}

- (NSUInteger)numberOfNames
{
    return [[self.fetchedResultsController fetchedObjects] count];
}

#pragma mark - <UISearchBarDelegate>

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)__unused searchBar               // return NO to not become first responder
{
    [self.navigationItem setRightBarButtonItem:self.doneBarButtonItem animated:YES];
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)__unused searchBar                 // return NO to not resign first responder
{
    [self.navigationItem setRightBarButtonItem:nil animated:YES];
    return YES;
}

- (void)searchBar:(UISearchBar *)__unused searchBar textDidChange:(NSString *)__unused searchText    // called when text changes (including clear)
{
    self.tableView.contentOffset = CGPointMake(0, 0 - self.tableView.contentInset.top);
    self.fetchedResultsController = nil;
    [self.tableView reloadData];

    // Update any detail view

    if ([self.splitViewController.viewControllers.lastObject isKindOfClass:[UINavigationController class]])
    {
        UINavigationController *secondaryViewController = self.splitViewController.viewControllers.lastObject;
        if ([[secondaryViewController topViewController] isKindOfClass:[YHWHDetailViewController class]])
        {
            YHWHDetailViewController *detailViewController = (YHWHDetailViewController *)[secondaryViewController topViewController];
            detailViewController.indexPath = nil;
            [detailViewController enableOrDisableUpDownArrowBarButtonItems];
            [detailViewController configureView];
        }
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar                       // called when keyboard search button pressed
{
    [searchBar resignFirstResponder];
}

#pragma mark - <UISearchResultsUpdating>

- (void)updateSearchResultsForSearchController:(UISearchController *)__unused searchController
{
    return;
}

#pragma mark - <UIStateRestoring>

static NSString *SearchBarTextKey = @"SearchBarTextKey";
static NSString *SearchBarIsFirstResponderKey = @"SearchBarIsFirstResponderKey";

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
    [super encodeRestorableStateWithCoder:coder];

    // encode the first responder status
    [coder encodeBool:[self.searchBar isFirstResponder] forKey:SearchBarIsFirstResponderKey];

    // encode the search bar text
    [coder encodeObject:self.searchBar.text forKey:SearchBarTextKey];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder
{
    [super decodeRestorableStateWithCoder:coder];

    // restore the search bar text
    self.searchBar.text = [coder decodeObjectForKey:SearchBarTextKey];

    self.fetchedResultsController = nil;
    [self.tableView reloadData];

    // restore the first responder status
    if ([coder decodeBoolForKey:SearchBarIsFirstResponderKey])
    {
        [self.searchBar becomeFirstResponder];
    }
}

#pragma mark - Notification handlers

// Calculate a new estimated row height when the content size changes

- (void)contentSizeChanged:(NSNotification *)__unused notification
{
    self.tableView.estimatedRowHeight = [self p_determineRowHeightForPreferredFont];
    [self.tableView reloadData];
}

- (void)keyboardWillShow:(NSNotification *)sender
{
    CGSize keyboardSize = [[sender userInfo][UIKeyboardFrameEndUserInfoKey] CGRectValue].size;

    UIEdgeInsets edgeInsets = self.tableView.contentInset;
    edgeInsets.bottom = keyboardSize.height;

    [self animateTableViewContentInset:edgeInsets forNotification:sender];
}

- (void)keyboardWillHide:(NSNotification *)sender
{
    UIEdgeInsets edgeInsets = self.tableView.contentInset;
    edgeInsets.bottom = self.bottomLayoutGuide.length;

    [self animateTableViewContentInset:edgeInsets forNotification:sender];
}

- (void)showDetailTargetDidChange:(NSNotification *)__unused notification
{
    // Whenever the target for showDetailViewController: changes, update all of our cells (to ensure they have the right accessory type)
    for (UITableViewCell *cell in self.tableView.visibleCells)
    {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        [self tableView:self.tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    }
}

#pragma mark - Actions

- (void)doneButtonClicked:(UIBarButtonItem *)__unused sender
{
    [self.searchBar resignFirstResponder];
}

#pragma mark - Private methods

- (CGFloat)p_determineRowHeightForPreferredFont
{
    CGFloat estimatedRowHeight = 14.0f;

    // Title: Use the Headline pointSize with the Body weight
    CGFloat pointSize = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline].pointSize;

    estimatedRowHeight += pointSize;

    UIFontDescriptor *fontDesc = [[UIFont yhwh_preferredCustomFontForTextStyle:UIFontTextStyleBody] fontDescriptor];

    self.titlePreferredFont = [UIFont fontWithDescriptor:fontDesc size:pointSize];

    NSArray *fontFeatureSettings = @[
                                     @{
                                         UIFontFeatureTypeIdentifierKey : @(kLowerCaseType),
                                         UIFontFeatureSelectorIdentifierKey : @(kLowerCaseSmallCapsSelector)
                                         },
                                     ];

    NSDictionary *attributes = @{
                                 UIFontDescriptorFeatureSettingsAttribute: fontFeatureSettings
                                 };

    fontDesc = [fontDesc fontDescriptorByAddingAttributes:attributes]; // enable small caps feature

    self.smallCapsTitlePreferredFont = [UIFont fontWithDescriptor:fontDesc size:pointSize];

    // Subtitle: Use the Footnote pointsize with small caps
    pointSize = [UIFont yhwh_preferredCustomFontForTextStyle:UIFontTextStyleFootnote].pointSize;

    estimatedRowHeight += pointSize;

    self.smallCapsSubtitlePreferredFont = [UIFont fontWithDescriptor:fontDesc size:pointSize];

    return estimatedRowHeight;
}

- (void)animateTableViewContentInset:(UIEdgeInsets)edgeInsets forNotification:(NSNotification *)sender
{
    NSTimeInterval animationDuration = [[sender userInfo][UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationOptions animationCurve = [[sender userInfo][UIKeyboardAnimationCurveUserInfoKey] doubleValue];

    [UIView animateWithDuration:animationDuration delay:0.0 options:animationCurve animations:^{
        [self.tableView setContentInset:edgeInsets];
        [self.tableView setScrollIndicatorInsets:edgeInsets];
    } completion:nil];
}

- (BOOL)isSearchingAndNoResults
{
    return [self.searchBar.text length] && ![self numberOfNames];
}

- (void)setupSearchBar
{
    // Interface Builder won't let you place a search bar directly in the titleView
    // Do it in code, to avoid having to wrap the search bar in a view

    self.searchBar = [UISearchBar new];

    self.searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    self.searchBar.placeholder = @"Search names of God";
    self.searchBar.delegate = self;

    // Include the search bar within the navigation bar.

    self.navigationItem.titleView = self.searchBar;

    //    self.definesPresentationContext = YES;

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

    // Create a Done (right) bar button item, which we'll animate in when the
    // user searches for a name.

    self.doneBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                           target:self
                                                                           action:@selector(doneButtonClicked:)];
}

@end
