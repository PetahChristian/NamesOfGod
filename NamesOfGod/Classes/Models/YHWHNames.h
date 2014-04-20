//
//  YHWHNames.h
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

@class YHWHName;

/**
 YHWHNames is a singleton that manages names of God (model) data.

 The names are stored as a collated array of arrays (of name objects), and may be
 accessed via a conventional (section and row) indexPath.

 Each name, along with related data, is stored in a `YHWHName` object.

 ## Filtering the name data

 In addition to managing the complete (unfiltered) names of God, the singleton also
 manages a filtered set of names.
 */
@interface YHWHNames : NSObject
/**
 An A-Z title for each section header/index.
 */
@property (nonatomic, strong, readonly) NSArray *sectionIndexData;
/**
 The filter text used in the predicate for searching the name data.
 */
@property (nonatomic, copy) NSString *filterText;
/**
 A flag indicating we have filtered name data.

 We use a flag to avoid any race condition between the filterText being set, but the
 filtering not being completed
 */
@property (nonatomic, assign, readonly, getter = isFilteringDone) BOOL filteringDone;
/**
 A flag indicating if the filtered name data contains any results (matches).

 We can quickly test this value, instead of checking filteredNameData to see if all
 its sections are empty
 */
@property (nonatomic, assign, readonly, getter = isMatchesExist) BOOL matchesExist;

/**
 The sharedNames (model) singleton.

 If the sharedNames singleton doesn't already exist, it is created, otherwise the
 existing singleton is returned.

 @return The sharedNames singleton for the application.
 */
+ (YHWHNames *)sharedNames;

/**
 The name data.

 @return The (filtered or unfiltered) name data, depending on whether or not we're
 currently filtering the data
 */
- (NSArray *)nameData;
/**
 Returns the name object at the specified index path.

 @param indexPath The index path for the requested name object.

 @return The name object at the specified index path, or nil if the index path is out
 of range.
 */
- (YHWHName *)nameAtIndexPath:(NSIndexPath *)indexPath;
/**
 Returns the index path for the first name object.

 @return The index path of the first name, or nil if no names exist.
 */
- (NSIndexPath *)indexPathForFirstName;
/**
 Returns the index path for the next name object.

 @note The index path will wrap around to the first name, if at the last name.

 @return The index path of the next name, or nil if no names exist.
 */
- (NSIndexPath *)indexPathAfterIndexPath:(NSIndexPath *)indexPath;
/**
 Returns the index path for the previous name object.

 @note The index path will wrap around to the last name, if at the first name.

 @return The index path of the previous name, or nil if no names exist.
 */
- (NSIndexPath *)indexPathBeforeIndexPath:(NSIndexPath *)indexPath;
/**
 Returns the index path of the name object with the specified name.

 @param name The name to search for. This is the same string that your app’s
 `modelIdentifierForElementAtIndexPath:inView:` method returned when encoding the
 data originally.

 @return The current index path of the object whose data matches the specified name,
 or nil if the object was not found.
*/
- (NSIndexPath *)indexPathForElementWithModelIdentifier:(NSString *)name;
/**
 Returns the string that uniquely identifies the name object at the specified index
 path.

 @param indexPath The index path for the requested name object.

 @return A string that uniquely identifies the name object.
 */
- (NSString *)modelIdentifierForElementAtIndexPath:(NSIndexPath *)indexPath;

@end
