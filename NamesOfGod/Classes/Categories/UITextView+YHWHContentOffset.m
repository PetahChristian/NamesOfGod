//
//  UITextView+YHWHContentOffset.m
//  NamesOfGod
//
//  Created by Peter Jensen on 4/3/14.
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

#import "UITextView+YHWHContentOffset.h"

@implementation UITextView (YHWHContentOffset)

// Explicitly scroll to top before changing text.

// This works around an edge case where the textView does not correctly get scrolled
// to top when its text is changed, depending on how the contentSize changed in
// relation to the contentOffset.

- (void)yhwh_scrollToTopAndSetAttributedText:(NSAttributedString *)attributedText
{
    // Scroll to "zero" content offset (based on content inset)
    [self setContentOffset:CGPointMake(0.0f, -self.contentInset.top) animated:NO];
    // Reset text before changing it.  This resets the contentSize.
    [self setAttributedText:nil];
    // Set the new text
    if (attributedText)
    {
        [self setAttributedText:attributedText];
    }
}

@end
