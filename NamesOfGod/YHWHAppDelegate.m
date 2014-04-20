//
//  YHWHAppDelegate.m
//  NamesOfGod
//
//  Created by Peter Jensen on 2/18/14.
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

#import "YHWHAppDelegate.h"

#import "YHWHConstants.h" // For user defaults preference keys

@implementation YHWHAppDelegate

@synthesize window = _window;

- (BOOL)               application:(UIApplication *)__unused application
    willFinishLaunchingWithOptions:(NSDictionary *)__unused launchOptions
{
    // Override point for customization after application launch.

    UINavigationController *navigationController = nil;

    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
        navigationController = [splitViewController.viewControllers lastObject];
        // Set the detailViewController to be the splitViewController's delegate
        splitViewController.delegate = (id)navigationController.topViewController;
    }
    else
    {
        navigationController = (UINavigationController *)self.window.rootViewController;
    }

    // The toolbar's segmented control won't inherit the global tint color.
    //  Explicitly set it (to match our storyboard tint color).

    [[UISegmentedControl appearance] setTintColor:navigationController.navigationBar.tintColor];

    // Register default values for any user defaults that don't exist

    [[NSUserDefaults standardUserDefaults] registerDefaults:@{ kYHWHUserVersionKey: @"ESV" }];

// #ifdef DEBUG
//    // Pinch gesture to force exit, for testing state restoration
//    UIPinchGestureRecognizer *recognizer = [[UIPinchGestureRecognizer alloc]
// initWithTarget:self action:@selector(_exit)];
//    [self.window addGestureRecognizer:recognizer];
// #endif

    return YES;
}

/*
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    return YES;
}
*/

/*
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This
    // can occur for certain types of temporary interruptions (such as an incoming
    // phone call or SMS message) or when the user quits the application and it
    // begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down
    // OpenGL ES frame rates. Games should use this method to pause the game.
}
*/

- (void)applicationDidEnterBackground:(UIApplication *)__unused application
{
    // Use this method to release shared resources, save user data, invalidate
    // timers, and store enough application state information to restore your
    // application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called
    // instead of applicationWillTerminate: when the user quits.

    // Save any modified user defaults to disk

    [[NSUserDefaults standardUserDefaults] synchronize];
}

/*
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state;
    // here you can undo many of the changes made on entering the background.
}
*/

/*
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application
    // was inactive. If the application was previously in the background, optionally
    // refresh the user interface.
}
*/

/*
- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate.
    // See also applicationDidEnterBackground:.
}
*/

- (BOOL)application:(UIApplication *)__unused application shouldSaveApplicationState:(NSCoder *)__unused coder
{
    return YES;
}

- (BOOL)application:(UIApplication *)__unused application shouldRestoreApplicationState:(NSCoder *)__unused coder
{
    return YES;
}

// #ifdef DEBUG
// - (void) _exit __attribute__ ((noreturn)) {
//    NSLog(@"Exiting due to debugging gesture to force exit.");
//    exit(0);
// }
// #endif

@end
