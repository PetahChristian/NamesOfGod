//
//  YHWHNameTests.m
//  NamesOfGod
//
//  Created by Peter Jensen on 4/7/14.
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

@interface YHWHNameTests : XCTestCase

@end

@implementation YHWHNameTests

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

#pragma mark - -name Tests

- (void)testThatNameIsReadOnly
{
    YHWHName *sut = [[YHWHName alloc] initWithName:nil alternateName:nil verseIndex:0];

    if ([sut respondsToSelector:@selector(setName:)])
    {
        XCTFail("setter exists for name property");
    }
}

- (void)testThatNameIsCopy
{
    NSMutableString *mutableName = [[NSMutableString alloc] initWithString:@"God"];
    YHWHName *sut = [[YHWHName alloc] initWithName:mutableName alternateName:nil verseIndex:0];

    [mutableName setString:@"Satan"];
    XCTAssertEqualObjects([sut name], @"God", @"name is not equal to God");
}

#pragma mark - -alternateName Tests

- (void)testThatAlternateNameIsReadOnly
{
    YHWHName *sut = [[YHWHName alloc] initWithName:nil alternateName:nil verseIndex:0];

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    if ([sut respondsToSelector:@selector(setAlternateName:)])
    {
        XCTFail("setter exists for alternateName property");
    }
#pragma clang diagnostic pop
}

- (void)testThatAlternateNameIsCopy
{
    NSMutableString *mutableName = [[NSMutableString alloc] initWithString:@"God"];
    YHWHName *sut = [[YHWHName alloc] initWithName:nil alternateName:mutableName verseIndex:0];

    [mutableName setString:@"Satan"];
    XCTAssertEqualObjects([sut alternateName], @"God", @"name is not equal to God");
}

#pragma mark - -verseIndex Tests

- (void)testThatVerseIndexIsReadOnly
{
    YHWHName *sut = [[YHWHName alloc] initWithName:nil alternateName:nil verseIndex:0];

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    if ([sut respondsToSelector:@selector(setVerseIndex:)])
    {
        XCTFail("setter exists for verseIndex property");
    }
#pragma clang diagnostic pop
}

@end
