//
//  YHWHNames.m
//  NamesOfGod
//
//  Created by Peter Jensen on 3/15/14.
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

#import "YHWHNames.h"
#import "YHWHName.h" // Each name, along with related data, is stored in a `YHWHName`
                     // custom object.

@interface YHWHNames ()

///---------------------------
/// @name Unfiltered name data
///---------------------------

/**
 An unfiltered array of name data.
 */
@property (nonatomic, strong) NSArray *unfilteredNameData;
@property (nonatomic, strong, readwrite) NSArray *sectionIndexData;

///-------------------------
/// @name Filtered name data
///-------------------------

/**
 Filtered name data results.
 */
@property (nonatomic, strong) NSMutableArray *filteredNameData;
@property (nonatomic, assign, readwrite, getter = isFilteringDone) BOOL filteringDone;
@property (nonatomic, assign, readwrite, getter = isMatchesExist) BOOL matchesExist;

@end

@implementation YHWHNames

@synthesize unfilteredNameData = _unfilteredNameData;
@synthesize sectionIndexData = _sectionIndexData;
@synthesize filterText = _filterText;
@synthesize filteredNameData = _filteredNameData;
@synthesize filteringDone = _filteringDone;
@synthesize matchesExist = _matchesExist;

#pragma mark - Initialization

#pragma mark Class methods

+ (instancetype)sharedNames
{
    static id sharedNames = nil;

    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        sharedNames = [[self alloc] init];
    });

    return sharedNames;
}

#pragma mark - Custom getters and setters

- (NSArray *)unfilteredNameData
{
    if (_unfilteredNameData)
    {
        return _unfilteredNameData;
    }

    // Lazily instantiate the name data from its plist
    NSMutableArray *sectionIndexData = [NSMutableArray arrayWithCapacity:22];
    NSMutableArray *unfilteredNameData = [NSMutableArray arrayWithCapacity:22];

    NSString *namesPlistPath = [[NSBundle mainBundle] pathForResource:@"YHWHNamesOfGod" ofType:@"plist"];

    NSArray *names = [NSArray arrayWithContentsOfFile:namesPlistPath];

    // The most flexible approach would be to collate the names (using
    // UILocalizedIndexedCollation), as it would easily support any future
    // localization of the data.
    // Chose most efficient approach (to pre-collate the names in the plist), so
    // we don't have to collate them even once (first launch).

    for (NSArray *aSection in names)
    {
        // The first object in the section is an NSString
        [sectionIndexData addObject:aSection[0]]; // Section index title/heading
        // The second object in the section is an array of raw name data. Store
        // each name's raw data in our custom name object
        NSMutableArray *sectionNames = [NSMutableArray arrayWithCapacity:1];
        for (NSArray *aName in aSection[1])
        {
            // aName[0] One or more related names, separated by newlines
            // aName[1] Index value for looking up the names' verses
            // aName[2] (Optional) A formal title for the name

            YHWHName *theName = [[YHWHName alloc] initWithName:aName[0]
                                                 alternateName:[aName count] >= 3 ? aName[2]:nil
                                                    verseIndex:[aName[1] integerValue]
                ];
            [sectionNames addObject:theName];
        }
        // unfilteredNameData is an array of arrays (of custom name objects)
        // make an immutable copy of the section before adding it to the array

        [unfilteredNameData addObject:[sectionNames copy]];
    }

    self.sectionIndexData = [sectionIndexData copy];
    _unfilteredNameData = [unfilteredNameData copy];

    return _unfilteredNameData;
}

- (NSArray *)nameData
{
    return [self isFilteringDone] ? self.filteredNameData : self.unfilteredNameData;
}

/**
 @param filterText A search string to filter on.

 @note When the filterText is empty, the singleton will return unfiltered name data.
 */
- (void)setFilterText:(NSString *)filterText
{
    if (_filterText != filterText)
    {
        // Changing the filter text changes the filter state
        self.filteringDone = NO;
        _filterText = [filterText copy];

        // Only filter results if there the filter text is not clear (empty)

        if ([filterText length])
        {
            NSPredicate *resultPredicate = [NSPredicate predicateWithBlock:
                                            ^BOOL (id obj, NSDictionary __unused *dict) {
                YHWHName *aName = obj;
                return ([[aName name] rangeOfString:filterText
                                            options:NSCaseInsensitiveSearch].location != NSNotFound ||
                        ([aName alternateName] &&
                         [[aName alternateName] rangeOfString:filterText
                                                      options:NSCaseInsensitiveSearch].location != NSNotFound));
            }];

            NSMutableArray *filteredData = [NSMutableArray arrayWithCapacity:22];
            bool matchesExist = NO;
            // nameData is an array of sections; for every section...
            for (NSMutableArray *section in self.unfilteredNameData)
            {
                // generate an array of names passing the search criteria
                NSArray *filteredSection = [section filteredArrayUsingPredicate:resultPredicate];
                if ([filteredSection count])
                {
                    matchesExist = YES;
                }
                [filteredData addObject:filteredSection];
            }

            self.matchesExist = matchesExist;
            self.filteredNameData = filteredData;
            self.filteringDone = YES;
        }
    }
}

#pragma mark - Public methods

- (YHWHName *)nameAtIndexPath:(NSIndexPath *)indexPath
{
    YHWHName *name = nil;

    NSUInteger section = [indexPath section];

    if (indexPath && section < [[self nameData] count])
    {
        NSUInteger row = [indexPath row];
        if (row < [[self nameData][section] count])
        {
            name = [self nameData][section][row];
        }
    }
    return name;
}

- (NSIndexPath *)indexPathForFirstName
{
    NSIndexPath *indexPath = nil;
    NSUInteger numberOfSections = [[self nameData] count];

    for (NSUInteger section = 0; section < numberOfSections; section++)
    {
        if ([[self nameData][section] count])
        {
            indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
            break;
        }
    }
    return indexPath;
}

- (NSIndexPath *)indexPathAfterIndexPath:(NSIndexPath *)indexPath
{
    // Return if indexPath is nil, or filtering and no matches exist
    if (!indexPath || ([self isFilteringDone] && ![self isMatchesExist]))
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
        if (section < [[self nameData] count] && [[self nameData][section] count])
        {
            // There is one more section, and it is not empty
            break;
        }
        // If there was not one more section, wrap the section around to 0
        if (section >= [[self nameData] count])
        {
            section = 0;
            if ([[self nameData][section] count])
            {
                // Section 0 is not empty
                break;
            }
        }
        // This section is empty. Try the next one.
        section++;
    }

    return [NSIndexPath indexPathForRow:row inSection:section];
}

- (NSIndexPath *)indexPathBeforeIndexPath:(NSIndexPath *)indexPath
{
    // Return if indexPath is nil, or filtering and no matches exist
    if (!indexPath || ([self isFilteringDone] && ![self isMatchesExist]))
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
        if (section > 0 && [[self nameData][--section] count])
        {
            // There is a preceeding section, and it is not empty
            row = [[self nameData][section] count] - 1;
            break;
        }
        // If there was no preceeding section, wrap the section around to the final
        // section
        if (section == 0)
        {
            section = [[self nameData] count] - 1;
            if ([[self nameData][section] count])
            {
                // The final section is not empty
                row = [[self nameData][section] count] - 1;
                break;
            }
        }
        // This section is empty. Try the preceeding one.
    }

    return [NSIndexPath indexPathForRow:row inSection:section];
}

#pragma mark - Utility methods for UIDataSourceModelAssociation Protocol

- (NSIndexPath *)indexPathForElementWithModelIdentifier:(NSString *)name
{
    if (![name length])
    {
        return nil;
    }

    NSIndexPath *indexPath = nil;

    // Figure out which section to search

    NSUInteger section = [self.sectionIndexData indexOfObject:[name substringToIndex:1]];

    if (section != NSNotFound)
    {
        NSUInteger row = [[self nameData][section] indexOfObjectPassingTest:^BOOL (id obj,
                                                                                   NSUInteger __unused idx,
                                                                                   BOOL *stop) {
            YHWHName *aName = obj;
            *stop = [[aName name] isEqualToString:name];
            return *stop;
        }];

        if (row != NSNotFound)
        {
            indexPath = [NSIndexPath indexPathForRow:row inSection:section];
        }
    }

    return indexPath;
}

- (NSString *)modelIdentifierForElementAtIndexPath:(NSIndexPath *)indexPath
{
    return [[self nameAtIndexPath:indexPath] name];
}

@end
