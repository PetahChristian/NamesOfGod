//
//  YHWHTitleView.m
//  NamesOfGod
//
//  Created by Peter Jensen on 2/21/14.
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

#import "YHWHTitleView.h"

@implementation YHWHTitleView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        // Initialization code
        [self setAutoresizingMask:
         (UIViewAutoresizing)(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth)];
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [self setFrame:[newSuperview bounds]];
}

// Autoresizing mask constraints placed on the titleView (by the NavigationBar)
// limit its width to navigationBar.width - 16

// Changing our view's edge insets give the illusion that our titleView extends
// to the edge of the navigationBar. (In actuality, it eliminates any padding
// between our searchBar subView and its superview, making the searchBar wider.)

// |-8-|-8-[searchBar]-8-|-8-| becomes |-8-|[searchBar]|-8-|

- (UIEdgeInsets)alignmentRectInsets
{
    return UIEdgeInsetsMake(0.0f, -8.0f, 0.0f, -8.0f);
}

@end
