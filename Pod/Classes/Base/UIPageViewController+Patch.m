//
//  UIPageViewController+Mytograph.m
//  Mytograph
//
//  Created by Adam Iredale on 6/02/2015.
//  Copyright (c) 2015 Bionic Monocle Pty Ltd. All rights reserved.
//

#import "UIPageViewController+Patch.h"

@implementation UIPageViewController (Patch)

#pragma mark - Accessors

- (void)setSingleViewController:(UIViewController *)singleViewController
{
    // Simulate delegate callbacks (we're not animating)
    NSArray *priorViewControllers   = self.viewControllers;
    NSArray *viewControllers        = @[singleViewController];
    [self.delegate pageViewController:self willTransitionToViewControllers:viewControllers];
    [self setViewControllers:viewControllers
                   direction:UIPageViewControllerNavigationDirectionForward
                    animated:NO
                  completion:nil];
    [self.delegate pageViewController:self didFinishAnimating:YES
              previousViewControllers:priorViewControllers transitionCompleted:YES];
}

- (UIViewController *)singleViewController
{
    return self.viewControllers.firstObject;
}

@end
