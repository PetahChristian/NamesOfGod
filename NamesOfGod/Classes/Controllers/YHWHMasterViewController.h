//
//  YHWHMasterViewController.h
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

@import UIKit;
@import CoreData;

@class YHWHName;

@protocol YHWHNameDataSource <NSObject>

/**
 Returns the name object at the specified index path.

 @param indexPath The index path for the requested name object.

 @return The name object at the specified index path, or nil if the index path is out
 of range.
 */
- (YHWHName *)nameAtIndexPath:(NSIndexPath *)indexPath;
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
 Returns the number of name objects.
 
 @note Filtered search results may return no matches.

 @return The number of names, or 0 if no names exist
 */
- (NSUInteger)numberOfNames;

@end

@interface YHWHMasterViewController : UITableViewController <NSFetchedResultsControllerDelegate, YHWHNameDataSource>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end

