//
//  UIPageViewController+Mytograph.h
//  Patch
//
//  Created by Adam Iredale on 6/02/2015.
//  Copyright (c) 2015 Bionic Monocle Pty Ltd. All rights reserved.
//

/**
 *  Extensions for sane use of the control in non-page-flip situations
 */

@interface UIPageViewController (Patch)

@property (nonatomic, strong) UIViewController *singleViewController;

@end
