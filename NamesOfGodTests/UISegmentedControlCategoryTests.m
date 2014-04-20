//
//  UISegmentedControlCategoryTests.m
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

#import "UISegmentedControl+YHWHSegmentIndex.h"

@interface UISegmentedControl ()

// Expose private methods for testing
- (NSString *)yhwh_titleForSegmentAtIndex:(NSInteger)segment;
- (NSInteger)yhwh_segmentIndexWithTitle:(NSString *)title;

@end

@interface UISegmentedControlCategoryTests : XCTestCase

@end

@implementation UISegmentedControlCategoryTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test
    // method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each
    // test method in the class.
    [super tearDown];
}

#pragma mark - -yhwh_segmentIndexWithTitle: Tests

- (void)testThatYhwhSegmentIndexWithTitleHandlesNoSegments
{
    UISegmentedControl *sut = [[UISegmentedControl alloc] init];

    XCTAssertEqual([sut yhwh_segmentIndexWithTitle:@"No segment has this title"], UISegmentedControlNoSegment, @"title matched with no segments");
}

- (void)testThatYhwhSegmentIndexWithTitleHandlesEmptyTitle
{
    UISegmentedControl *sut = [[UISegmentedControl alloc] initWithItems:@[@"A", @"", @"C", @"D"]];

    XCTAssertEqual([sut yhwh_segmentIndexWithTitle:@""], 1, @"title matched wrong segment");
    XCTAssertEqual([sut yhwh_segmentIndexWithTitle:@"C"], 2, @"title matched wrong segment");
}

- (void)testThatYhwhSegmentIndexWithTitleHandlesNilValue
{
    UISegmentedControl *sut = [[UISegmentedControl alloc] initWithItems:@[@"A", @"", @"C", @"D"]];

    XCTAssertEqual([sut yhwh_segmentIndexWithTitle:nil], UISegmentedControlNoSegment, @"title matched wrong segment");
}

- (void)testThatYhwhSegmentIndexWithTitleHandlesNoMatchingTitle
{
    UISegmentedControl *sut = [[UISegmentedControl alloc] initWithItems:@[@"A", @"B", @"C", @"D"]];

    XCTAssertEqual([sut yhwh_segmentIndexWithTitle:@"E"], UISegmentedControlNoSegment, @"title matched with no matching segment");
}

- (void)testThatYhwhSegmentIndexWithTitleHandlesANilTitle
{
    UISegmentedControl *sut = [[UISegmentedControl alloc] initWithItems:@[@"A", @"B", @"C", @"D"]];

    [sut setTitle:nil forSegmentAtIndex:1];
    XCTAssertEqual([sut yhwh_segmentIndexWithTitle:@"C"], 2, @"segment index does not match title");
}

- (void)testThatYhwhSegmentIndexWithTitleHandlesMultipleMatches
{
    UISegmentedControl *sut = [[UISegmentedControl alloc] initWithItems:@[@"A", @"B", @"B", @"A"]];

    XCTAssertEqual([sut yhwh_segmentIndexWithTitle:@"B"], 1, @"title matched wrong segment");
}

- (void)testThatYhwhSegmentIndexWithTitleHandlesMatchForNumberOfSegments
{
    UISegmentedControl *sut = [[UISegmentedControl alloc] initWithItems:@[@"ABC", @"DEF", @"GHI", @"JKL", @"MNO"]];

    XCTAssertEqual([sut yhwh_segmentIndexWithTitle:@"ABC"], 0, @"title did not match segment 0");
    XCTAssertEqual([sut yhwh_segmentIndexWithTitle:@"DEF"], 1, @"title did not match segment 1");
    XCTAssertEqual([sut yhwh_segmentIndexWithTitle:@"GHI"], 2, @"title did not match segment 2");
    XCTAssertEqual([sut yhwh_segmentIndexWithTitle:@"JKL"], 3, @"title did not match segment 3");
    XCTAssertEqual([sut yhwh_segmentIndexWithTitle:@"MNO"], 4, @"title did not match segment 4");
}

#pragma mark - -yhwh_titleForSegmentAtIndex: Tests

- (void)testThatYhwhTitleForSegmentAtIndexHandlesNoSegments
{
    UISegmentedControl *sut = [[UISegmentedControl alloc] init];

    XCTAssertNil([sut yhwh_titleForSegmentAtIndex:0], @"title returned with no segments");
}

- (void)testThatYhwhTitleForSegmentAtIndexHandlesLowOutOfRange
{
    UISegmentedControl *sut = [[UISegmentedControl alloc] initWithItems:@[@"A"]];

    XCTAssertNil([sut yhwh_titleForSegmentAtIndex:-1], @"title returned for segment index < 0");
}

- (void)testThatYhwhTitleForSegmentAtIndexHandlesHighOutOfRange
{
    UISegmentedControl *sut = [[UISegmentedControl alloc] initWithItems:@[@"A"]];

    XCTAssertNil([sut yhwh_titleForSegmentAtIndex:1], @"title returned for segment index > number of segments");
}

- (void)testThatYhwhTitleForSegmentAtIndexHandlesNilTitle
{
    UISegmentedControl *sut = [[UISegmentedControl alloc] init];

    [sut insertSegmentWithTitle:nil atIndex:0 animated:NO];
    XCTAssertNil([sut yhwh_titleForSegmentAtIndex:0], @"title returned for segment with nil title");
}

- (void)testThatYhwhTitleForSegmentAtIndexHandlesTitleForNumberOfSegments
{
    UISegmentedControl *sut = [[UISegmentedControl alloc] initWithItems:@[@"000", @"111", @"222", @"333", @"444"]];

    XCTAssertEqualObjects([sut yhwh_titleForSegmentAtIndex:3], @"333", @"wrong title for segment at index 3");
    XCTAssertEqualObjects([sut yhwh_titleForSegmentAtIndex:0], @"000", @"wrong title for segment at index 0");
    XCTAssertEqualObjects([sut yhwh_titleForSegmentAtIndex:1], @"111", @"wrong title for segment at index 1");
    XCTAssertEqualObjects([sut yhwh_titleForSegmentAtIndex:4], @"444", @"wrong title for segment at index 4");
    XCTAssertEqualObjects([sut yhwh_titleForSegmentAtIndex:2], @"222", @"wrong title for segment at index 2");
}

#pragma mark - -yhwh_selectSegmentWithTitle: Tests

- (void)testThatYhwhSelectSegmentWithTitleHandlesNoSegments
{
    UISegmentedControl *sut = [[UISegmentedControl alloc] init];

    [sut yhwh_selectSegmentWithTitle:@"No segment has this title"];
    XCTAssertEqual([sut selectedSegmentIndex], UISegmentedControlNoSegment, @"selected segment when no segments exist");
}

- (void)testThatYhwhSelectSegmentWithTitleHandlesEmptyTitle
{
    UISegmentedControl *sut = [[UISegmentedControl alloc] initWithItems:@[@"A", @"", @"C", @"D"]];

    [sut yhwh_selectSegmentWithTitle:@""];
    XCTAssertEqual([sut selectedSegmentIndex], 1, @"selected segment is not segment 1");

    [sut yhwh_selectSegmentWithTitle:@"C"];
    XCTAssertEqual([sut selectedSegmentIndex], 2, @"selected segment is not segment 2");
}

- (void)testThatYhwhSelectSegmentWithTitleHandlesDefaultSelectionDespiteNilValue
{
    UISegmentedControl *sut = [[UISegmentedControl alloc] initWithItems:@[@"A", @"", @"C", @"D"]];

    [sut yhwh_selectSegmentWithTitle:nil];
    // No segments match.  The first segment will be selected by default.
    XCTAssertEqual([sut selectedSegmentIndex], 0, @"did not select segment 0 when no title was provided");
}

- (void)testThatYhwhSelectSegmentWithTitleHandlesDefaultSelectionDespiteNoMatchingTitle
{
    UISegmentedControl *sut = [[UISegmentedControl alloc] initWithItems:@[@"A", @"B", @"C", @"D"]];

    [sut yhwh_selectSegmentWithTitle:@"E"];
    // No segments match.  The first segment will be selected by default.
    XCTAssertEqual([sut selectedSegmentIndex], 0, @"did not select segment 0 when no title matched");
}

- (void)testThatYhwhSelectSegmentWithTitleHandlesMultipleMatches
{
    UISegmentedControl *sut = [[UISegmentedControl alloc] initWithItems:@[@"A", @"B", @"B", @"A"]];

    [sut yhwh_selectSegmentWithTitle:@"B"];
    XCTAssertEqual([sut selectedSegmentIndex], 1, @"selected segment is not segment 1");
}

- (void)testThatYhwhSelectSegmentWithTitleHandlesMatchForNumberOfSegments
{
    UISegmentedControl *sut = [[UISegmentedControl alloc] initWithItems:@[@"ABC", @"DEF", @"GHI", @"JKL", @"MNO"]];

    [sut yhwh_selectSegmentWithTitle:@"DEF"];
    XCTAssertEqual([sut selectedSegmentIndex], 1, @"selected segment is not segment 1");

    [sut yhwh_selectSegmentWithTitle:@"JKL"];
    XCTAssertEqual([sut selectedSegmentIndex], 3, @"selected segment is not segment 3");

    [sut yhwh_selectSegmentWithTitle:@"ABC"];
    XCTAssertEqual([sut selectedSegmentIndex], 0, @"selected segment is not segment 0");

    [sut yhwh_selectSegmentWithTitle:@"MNO"];
    XCTAssertEqual([sut selectedSegmentIndex], 4, @"selected segment is not segment 4");

    [sut yhwh_selectSegmentWithTitle:@"GHI"];
    XCTAssertEqual([sut selectedSegmentIndex], 2, @"selected segment is not segment 2");

    [sut yhwh_selectSegmentWithTitle:@"XYZ"];
    XCTAssertEqual([sut selectedSegmentIndex], 0, @"selected segment is not segment 0");
}

#pragma mark - -yhwh_titleForSelectedSegment Tests

- (void)testThatYhwhTitleForSelectedSegmentHandlesNoSegments
{
    UISegmentedControl *sut = [[UISegmentedControl alloc] init];

    XCTAssertNil([sut yhwh_titleForSelectedSegment], @"title returned with no segments");
}

- (void)testThatYhwhTitleForSelectedSegmentHandlesNilTitle
{
    UISegmentedControl *sut = [[UISegmentedControl alloc] init];

    [sut insertSegmentWithTitle:nil atIndex:0 animated:NO];
    [sut setSelectedSegmentIndex:0];

    XCTAssertNil([sut yhwh_titleForSelectedSegment], @"title returned for segment with nil title");
}

- (void)testThatYhwhTitleForSelectedSegmentHandlesNoSelectedSegment
{
    UISegmentedControl *sut = [[UISegmentedControl alloc] initWithItems:@[@"A", @"B", @"C", @"D"]];

    XCTAssertNil([sut yhwh_titleForSelectedSegment], @"title returned for no selected segment");
}

- (void)testThatYhwhTitleForSelectedSegmentHandlesNumberOfSegments
{
    UISegmentedControl *sut = [[UISegmentedControl alloc] initWithItems:@[@"ABC", @"DEF", @"GHI", @"JKL", @"MNO"]];

    [sut setSelectedSegmentIndex:1];
    XCTAssertEqualObjects([sut yhwh_titleForSelectedSegment], @"DEF", @"wrong title for selected segment 1");

    [sut setSelectedSegmentIndex:3];
    XCTAssertEqualObjects([sut yhwh_titleForSelectedSegment], @"JKL", @"wrong title for selected segment 3");

    [sut setSelectedSegmentIndex:0];
    XCTAssertEqualObjects([sut yhwh_titleForSelectedSegment], @"ABC", @"wrong title for selected segment 0");

    [sut setSelectedSegmentIndex:4];
    XCTAssertEqualObjects([sut yhwh_titleForSelectedSegment], @"MNO", @"wrong title for selected segment 4");

    [sut setSelectedSegmentIndex:2];
    XCTAssertEqualObjects([sut yhwh_titleForSelectedSegment], @"GHI", @"wrong title for selected segment 2");

    [sut setSelectedSegmentIndex:-1];
    XCTAssertNil([sut yhwh_titleForSelectedSegment], @"wrong title for no selected segment");
}

// No code depends on these behaviors

#pragma mark - -setSelectedSegment: Behavior Tests

- (void)testThatSelectionDoesNotChangeWhenSetSelectedSegmentValueIsOutOfBounds
{
    UISegmentedControl *sut = [[UISegmentedControl alloc] initWithItems:@[@"Apple", @"Orange", @"Pear"]];

    [sut setSelectedSegmentIndex:1];
    [sut setSelectedSegmentIndex:999];
    XCTAssertEqual([sut selectedSegmentIndex], 1, @"selected segment changed");
}

- (void)testThatSelectionIsClearedWhenSelectedSegmentIsRemoved
{
    UISegmentedControl *sut = [[UISegmentedControl alloc] initWithItems:@[@"Apple", @"Orange", @"Pear"]];

    [sut setSelectedSegmentIndex:2];
    [sut removeSegmentAtIndex:2 animated:NO];
    XCTAssertEqual([sut selectedSegmentIndex], UISegmentedControlNoSegment, @"selected segment not cleared");
}

@end
