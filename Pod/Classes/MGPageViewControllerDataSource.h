//
//  MGPageViewControllerDataSource.h
//  Mytograph
//
//  Created by Adam Iredale on 18/12/2014.
//  Copyright (c) 2014 Bionic Monocle Pty Ltd. All rights reserved.
//

@interface MGPageViewControllerDataSource : NSObject <UIPageViewControllerDataSource>

@property (nonatomic, readonly) NSUInteger numberOfViewControllers;

@property (nonatomic, copy) UIViewController *(^instantiateViewControllerBlock)(NSInteger index, id itemAtIndex);

@property (nonatomic, copy) void (^configureViewControllerBlock)(UIViewController *viewController, NSInteger index, id itemAtIndex);

- (instancetype)initWithDataSource:(id <MGDataSource>)dataSource placeholderViewController:(UIViewController *)placeholder NS_DESIGNATED_INITIALIZER;

- (UIViewController *)viewControllerAtIndex:(NSInteger)index;

+ (instancetype)pageViewControllerDataSourceWithDataSource:(id <MGDataSource>)dataSource placeholderViewController:(UIViewController *)placeholder;

@end

@interface MGPageViewControllerDataSource (ReadOnly)

@property (nonatomic, readonly) UIViewController *placeholderViewController;

@end