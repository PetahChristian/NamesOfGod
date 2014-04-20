//
//  YHWHNamesTests.m
//  NamesOfGod
//
//  Created by Peter Jensen on 4/8/14.
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

@import XCTest;

#import "YHWHName.h"
#import "YHWHNames.h"

/**
 @warning These tests use static data from the YHWHNamesOfGod plist.

 Since this is not mock data, changes to the plist may affect the test results.
 */
@interface YHWHNamesTests : XCTestCase

@end

@implementation YHWHNamesTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test
    // method in the class.
    [[YHWHNames sharedNames] setFilterText:nil]; // Clear any filter before starting
                                                 // each test
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each
    // test method in the class.
    [super tearDown];
}

#pragma mark - +sharedNames Singleton Tests

- (void)testThatSharedNamesSingletonReturnsAnInstance
{
    XCTAssertNotNil([YHWHNames sharedNames], @"no singleton returned");
}

- (void)testThatSharedNamesSingletonReturnsAKindOfYHWHNamesClass
{
    XCTAssert([[YHWHNames sharedNames] isKindOfClass:[YHWHNames class]], @"singleton is not kind of YHWHNames class");
}

- (void)testThatSharedNamesSingletonReturnsASingleton
{
    YHWHNames *sut1 = [YHWHNames sharedNames];
    YHWHNames *sut2 = [YHWHNames sharedNames];

    XCTAssert(sut1 == sut2, @"sharedNames is not a singleton");
}

#pragma mark - -sectionIndexData Tests

- (void)testThatSectionIndexDataReturnsExpectedSectionIndexArray
{
    NSArray *expectedSectionIndex = @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"V", @"W"];

    XCTAssertEqualObjects([[YHWHNames sharedNames] sectionIndexData], expectedSectionIndex, @"unexpected sectionIndexData");
}

- (void)testThatSectionIndexDataCountIsEqualToNameDataCount
{
    XCTAssertEqual([[[YHWHNames sharedNames] sectionIndexData] count], [[[YHWHNames sharedNames] nameData] count], @"sectionIndexData and nameData counts differ");
}

#pragma mark - -indexPathForFirstName Tests

- (void)testThatIndexPathForFirstNameIsZeroZero
{
    XCTAssertEqualObjects([[YHWHNames sharedNames] indexPathForFirstName], [NSIndexPath indexPathForRow:0 inSection:0],  @"index path for first name is not 0 - 0");
}

- (void)testThatIndexPathForFirstFilteredNameIsElevenZero
{
    [[YHWHNames sharedNames] setFilterText:@"Lily of the Valleys"];
    XCTAssertEqualObjects([[YHWHNames sharedNames] indexPathForFirstName], [NSIndexPath indexPathForRow:0 inSection:11],  @"index path for first name is not 11 - 0");
}

- (void)testThatIndexPathForFirstFilteredNameIsNilForNoResults
{
    [[YHWHNames sharedNames] setFilterText:@"Sky Blue Pink"];
    XCTAssertNil([[YHWHNames sharedNames] indexPathForFirstName], @"index path for first name is not nil for No Results");
}

- (void)testThatIndexPathForFirstFilteredNameIsNineZero
{
    [[YHWHNames sharedNames] setFilterText:@"Kanna"]; // alternateName for Jealous
    XCTAssertEqualObjects([[YHWHNames sharedNames] indexPathForFirstName], [NSIndexPath indexPathForRow:0 inSection:9],  @"index path for first name is not 9 - 0");
}

#pragma mark - -nameData Tests

- (void)testThatNameDataIsNotNil
{
    XCTAssertNotNil([[YHWHNames sharedNames] nameData], @"no (unfiltered) name data");
}

- (void)testThatFilteredNameDataIsNotNil
{
    [[YHWHNames sharedNames] setFilterText:@"Holy One of Israel"];
    XCTAssertNotNil([[YHWHNames sharedNames] nameData], @"no (filtered) name data");
}

#pragma mark - -nameAtIndexPath: Tests

// Since this is not mock data, changes to the names plist may affect the test
// results.

- (void)testThatNameAtIndexPathZeroZeroReturnsAbba
{
    YHWHName *aName = [[YHWHNames sharedNames] nameAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];

    XCTAssertEqualObjects([aName name], @"Abba", @"name at index path 0 - 0 is not Abba");
}

- (void)testThatNameAtIndexPathNineThreeReturnsJesusChristOurLord
{
    YHWHName *aName = [[YHWHNames sharedNames] nameAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:9]];

    XCTAssertEqualObjects([aName name], @"Jesus Christ our Lord", @"name at index path 9 - 3 is not Jesus Christ our Lord");
}

- (void)testThatNameAtIndexPathTwentyOneSixReturnsWordOfGod
{
    YHWHName *aName = [[YHWHNames sharedNames] nameAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:21]];

    XCTAssertEqualObjects([aName name], @"Word of God", @"name at index path 21 - 6 is not Word of God");
}

- (void)testThatFilteredNameAtIndexPathElevenSevenReturnsLivingWater
{
    [[YHWHNames sharedNames] setFilterText:@"li"];
    YHWHName *aName = [[YHWHNames sharedNames] nameAtIndexPath:[NSIndexPath indexPathForRow:7 inSection:11]];

    XCTAssertEqualObjects([aName name], @"Living Water", @"name at index path 11 - 7 is not Living Water");
}

- (void)testThatNameAtIndexPathReturnsNilForInvalidSection
{
    XCTAssertNil([[YHWHNames sharedNames] nameAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:999]], @"name returned for invalid section 999");
    XCTAssertNil([[YHWHNames sharedNames] nameAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:-1]], @"name returned for invalid section -1");
}

- (void)testThatNameAtIndexPathReturnsNilForInvalidRow
{
    XCTAssertNil([[YHWHNames sharedNames] nameAtIndexPath:[NSIndexPath indexPathForRow:999 inSection:0]], @"name returned for invalid row 999");
    XCTAssertNil([[YHWHNames sharedNames] nameAtIndexPath:[NSIndexPath indexPathForRow:-1 inSection:0]], @"name returned for invalid row -1");
}

- (void)testThatNameAtIndexPathReturnsNilForNoResults
{
    [[YHWHNames sharedNames] setFilterText:@"Nathan"];
    XCTAssertNil([[YHWHNames sharedNames] nameAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]], @"name returned for No Results");
}

- (void)testThatNameAtIndexPathReturnsNilForNilValue
{
    XCTAssertNil([[YHWHNames sharedNames] nameAtIndexPath:nil], @"name returned for nil value");
}

#pragma mark - filteringDone Tests

- (void)testThatFilteringDoneIsFalseWhenNotFiltering
{
    XCTAssertFalse([[YHWHNames sharedNames] isFilteringDone], @"filtering done when not filtering");
}

- (void)testThatFilteringDoneIsTrueWhenFiltering
{
    [[YHWHNames sharedNames] setFilterText:@"God"];
    XCTAssertTrue([[YHWHNames sharedNames] isFilteringDone], @"filtering not done when filtering");
}

#pragma mark - matchesExist Tests

- (void)testThatMatchesExistIsFalseForNoResults
{
    [[YHWHNames sharedNames] setFilterText:@"Serpent"];
    XCTAssertFalse([[YHWHNames sharedNames] isMatchesExist], @"matches exist when No Results expected");
}

- (void)testThatMatchesExistIsTrueForResults
{
    [[YHWHNames sharedNames] setFilterText:@"Jehovah"];
    XCTAssertTrue([[YHWHNames sharedNames] isMatchesExist], @"matches do not exist when results expected");
}

#pragma mark - -indexPathForElementWithModelIdentifier: Tests

- (void)testThatIndexPathForElementWithModelIdentifierHandlesNilValue
{
    XCTAssertNil([[YHWHNames sharedNames] indexPathForElementWithModelIdentifier:nil], @"index path returned for nil value");
}

- (void)testThatIndexPathForElementWithModelIdentifierHandlesEmptyString
{
    XCTAssertNil([[YHWHNames sharedNames] indexPathForElementWithModelIdentifier:@""], @"index path returned for empty string");
}

- (void)testThatIndexPathForElementWithModelIdentifierHandlesNonexistentName
{
    XCTAssertNil([[YHWHNames sharedNames] indexPathForElementWithModelIdentifier:@"Tom\nDick\nHarry"], @"index path returned for nonexistent name");
}

- (void)testThatIndexPathForElementWithModelIdentifierHandlesValidModelIdentifier
{
    NSString *sutIdentifier = @"Hiding Place";
    NSIndexPath *sutIndexPath = [NSIndexPath indexPathForRow:4 inSection:7];

    XCTAssertEqualObjects([[YHWHNames sharedNames] indexPathForElementWithModelIdentifier:sutIdentifier], sutIndexPath, @"wrong index path returned for %@", sutIdentifier);

    // Check return trip
    XCTAssertEqualObjects([[YHWHNames sharedNames] modelIdentifierForElementAtIndexPath:sutIndexPath], sutIdentifier, @"wrong identifier returned for index path");
}

- (void)testThatIndexPathForElementWithModelIdentifierHandlesValidModelIdentifierContainingNewlines
{
    NSString *sutIdentifier = @"Shepherd of our Souls\nOverseer of our Souls";
    NSIndexPath *sutIndexPath = [NSIndexPath indexPathForRow:5 inSection:18];

    XCTAssertEqualObjects([[YHWHNames sharedNames] indexPathForElementWithModelIdentifier:sutIdentifier], sutIndexPath, @"wrong index path returned for %@", sutIdentifier);

    // Check return trip
    XCTAssertEqualObjects([[YHWHNames sharedNames] modelIdentifierForElementAtIndexPath:sutIndexPath], sutIdentifier, @"wrong identifier returned for index path");
}

#pragma mark - -modelIdentifierForElementAtIndexPath: Tests

// Since this is not mock data, changes to the names plist may affect the test
// results.

- (void)testThatModelIdentifierForElementAtIndexPathHandlesNilValue
{
    XCTAssertNil([[YHWHNames sharedNames] modelIdentifierForElementAtIndexPath:nil], @"model identifier returned for nil value");
}

- (void)testThatModelIdentifierForElementAtIndexPathHandlesInvalidSection
{
    XCTAssertNil([[YHWHNames sharedNames] modelIdentifierForElementAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:777]], @"model identifier returned for invalid section 777");
    XCTAssertNil([[YHWHNames sharedNames] modelIdentifierForElementAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:-1]], @"model identifier returned for invalid section -1");
}

- (void)testThatModelIdentifierForElementAtIndexPathHandlesInvalidRow
{
    XCTAssertNil([[YHWHNames sharedNames] modelIdentifierForElementAtIndexPath:[NSIndexPath indexPathForRow:777 inSection:0]], @"model identifier returned for invalid row 777");
    XCTAssertNil([[YHWHNames sharedNames] modelIdentifierForElementAtIndexPath:[NSIndexPath indexPathForRow:-1 inSection:0]], @"model identifier returned for invalid row -1");
}

- (void)testThatModelIdentifierForElementAtIndexPathHandlesNoResults
{
    [[YHWHNames sharedNames] setFilterText:@"Nathan"];
    XCTAssertNil([[YHWHNames sharedNames] modelIdentifierForElementAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]], @"model identifier returned for No Results");
}

- (void)testThatModelIdentifierForElementAtIndexPathHandlesValidIndexPath
{
    NSIndexPath *sutIndexPath = [NSIndexPath indexPathForRow:2 inSection:17];
    NSString *sutIdentifier = @"Refiner's Fire";

    XCTAssertEqualObjects([[YHWHNames sharedNames] modelIdentifierForElementAtIndexPath:sutIndexPath], sutIdentifier, @"wrong identifier returned for index path");

    // Check return trip
    XCTAssertEqualObjects([[YHWHNames sharedNames] indexPathForElementWithModelIdentifier:sutIdentifier], sutIndexPath, @"wrong index path returned for %@", sutIdentifier);
}

- (void)testThatModelIdentifierForElementAtIndexPathHandlesAnotherValidIndexPath
{
    NSIndexPath *sutIndexPath = [NSIndexPath indexPathForRow:0 inSection:16];
    NSString *sutIdentifier = @"Quickening Spirit\nLife-giving Spirit";

    XCTAssertEqualObjects([[YHWHNames sharedNames] modelIdentifierForElementAtIndexPath:sutIndexPath], sutIdentifier, @"wrong identifier returned for index path");

    // Check return trip
    XCTAssertEqualObjects([[YHWHNames sharedNames] indexPathForElementWithModelIdentifier:sutIdentifier], sutIndexPath, @"wrong index path returned for %@", sutIdentifier);
}

#pragma mark - -indexPathAfterIndexPath: Tests

- (void)testThatIndexPathAfterIndexPathHandlesNilValue
{
    XCTAssertNil([[YHWHNames sharedNames] indexPathAfterIndexPath:nil], @"index path returned for nil value");
}

- (void)testThatIndexPathAfterIndexPathHandlesNoResults
{
    [[YHWHNames sharedNames] setFilterText:@"Nathan"];
    XCTAssertNil([[YHWHNames sharedNames] indexPathAfterIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]], @"index path returned for No Results");
}

- (void)testThatIndexPathAfterIndexPathWrapsAroundToFirstName
{
    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:6 inSection:21];

    NSIndexPath *nextIndexPath = [[YHWHNames sharedNames] indexPathAfterIndexPath:lastIndexPath];

    XCTAssertFalse([nextIndexPath isEqual:lastIndexPath], @"next index path does not differ");

    XCTAssertEqualObjects([[[YHWHNames sharedNames] nameAtIndexPath:nextIndexPath] name], @"Abba", @"unexpected name");

    // Check return trip
    XCTAssertEqualObjects([[YHWHNames sharedNames] indexPathBeforeIndexPath:nextIndexPath], lastIndexPath, @"next index path is not last index path");
}

- (void)testThatIndexPathAfterIndexPathHandlesValidFilteredIndexPath
{
    [[YHWHNames sharedNames] setFilterText:@"el"];

    NSIndexPath *StrongOneIndexPath = [NSIndexPath indexPathForRow:3 inSection:18];
    NSIndexPath *AllPowerfulOneIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];

    XCTAssertEqualObjects([[YHWHNames sharedNames] indexPathAfterIndexPath:StrongOneIndexPath], AllPowerfulOneIndexPath, @"unexpected index path");

    // Check return trip
    XCTAssertEqualObjects([[YHWHNames sharedNames] indexPathBeforeIndexPath:AllPowerfulOneIndexPath], StrongOneIndexPath, @"index path does not match initial index path");
}

#pragma mark - -indexPathBeforeIndexPath: Tests

- (void)testThatIndexPathBeforeIndexPathHandlesNilValue
{
    XCTAssertNil([[YHWHNames sharedNames] indexPathBeforeIndexPath:nil], @"index path returned for nil value");
}

- (void)testThatIndexPathBeforeIndexPathHandlesNoResults
{
    [[YHWHNames sharedNames] setFilterText:@"Nathan"];
    XCTAssertNil([[YHWHNames sharedNames] indexPathBeforeIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]], @"index path returned for No Results");
}

- (void)testThatIndexPathBeforeIndexPathWrapsAroundToLastName
{
    NSIndexPath *firstIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];

    NSIndexPath *prevIndexPath = [[YHWHNames sharedNames] indexPathBeforeIndexPath:firstIndexPath];

    XCTAssertFalse([prevIndexPath isEqual:firstIndexPath], @"previous index path does not differ");

    XCTAssertEqualObjects([[[YHWHNames sharedNames] nameAtIndexPath:prevIndexPath] name], @"Word of God", @"unexpected name");

    // Check return trip
    XCTAssertEqualObjects([[YHWHNames sharedNames] indexPathAfterIndexPath:prevIndexPath], firstIndexPath, @"previous index path is not first index path");
}

- (void)testThatIndexPathBeforeIndexPathHandlesValidFilteredIndexPath
{
    [[YHWHNames sharedNames] setFilterText:@"yhwh"];

    NSIndexPath *LordIsThereIndexPath = [NSIndexPath indexPathForRow:0 inSection:11];
    NSIndexPath *iAmIndexPath = [NSIndexPath indexPathForRow:0 inSection:8];

    XCTAssertEqualObjects([[YHWHNames sharedNames] indexPathBeforeIndexPath:LordIsThereIndexPath], iAmIndexPath, @"unexpected index path");

    // Check return trip
    XCTAssertEqualObjects([[YHWHNames sharedNames] indexPathAfterIndexPath:iAmIndexPath], LordIsThereIndexPath, @"index path does not match initial index path");
}

@end
