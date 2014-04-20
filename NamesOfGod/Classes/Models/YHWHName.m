//
//  YHWHName.m
//  NamesOfGod
//
//  Created by Peter Jensen on 2/27/14.
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

#import "YHWHName.h"

@implementation YHWHName

@synthesize name = _name;
@synthesize alternateName = _alternateName;
@synthesize verseIndex = _verseIndex;

- (instancetype)initWithName:(NSString *)name
               alternateName:(NSString *)alternateName
                  verseIndex:(NSUInteger)verseIndex
{
    self = [super init];
    if (self)
    {
        _name = [name copy];
        _alternateName = [alternateName copy];
        _verseIndex = verseIndex;
    }
    return self;
}

#ifdef DEBUG
- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: "
            "%p; "
            "name = '%@'; "
            "alternateName = '%@'; "
            "verseIndex = %ld>",
            NSStringFromClass([self class]),
            self,
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu" // Suppress warning: use of GNU ?:
                                         // expression extension, eliding middle term
                                         // [-Wgnu]
            [self name] ?            :@"",
            [self alternateName] ?   :@"",
#pragma clang diagnostic pop
            (long)[self verseIndex]];
}

#endif

@end
