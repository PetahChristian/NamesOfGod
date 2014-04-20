//
//  YHWHName.h
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

@interface YHWHName : NSObject
/**
 One or more related names (delimited by newlines).
 */
@property (nonatomic, copy, readonly) NSString *name;
/**
 An (optional) alternate name, generally a formal title.
 */
@property (nonatomic, copy, readonly) NSString *alternateName;
/**
 A lookup index into the verse array.
 */
@property (nonatomic, assign, readonly) NSUInteger verseIndex;

/**
 Initializes a name object, populating the name's variables with the passed
 parameters.

 @param name One or more related names (delimited by newlines).
 @param alternateName An (optional) alternate name, generally a formal title.
 @param verseIndex A lookup index into the verse array.

 @return An initialized name object.
 */
- (instancetype)initWithName:(NSString *)name alternateName:(NSString *)alternateName verseIndex:(NSUInteger)verseIndex;

// Unavailable creation methods (since properties are readonly)
- (instancetype)init __attribute__((unavailable("init unavailable, call -initWithName:alternateName:verseIndex:")));
+ (instancetype)new __attribute__((unavailable("new unavailable, call -initWithName:alternateName:verseIndex:")));

@end
