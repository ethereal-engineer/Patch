//
//  MGCarouselDataSource.h
//  Mytograph
//
//  Created by Adam Iredale on 3/12/2014.
//  Copyright (c) 2014 Bionic Monocle Pty Ltd. All rights reserved.
//

/**
 *  Datasource adapter from generic datasource to iCaraousel
 */

@interface MGCarouselDataSource : NSObject <iCarouselDataSource, MGDataSourceChangeListener>

@property (nonatomic, copy) UIView *(^instantiateViewBlock)(NSInteger index);

@property (nonatomic, copy) void (^configureViewBlock)(UIView *view, NSInteger index, id itemAtIndex);

- (instancetype)initWithDataSource:(id <MGDataSource>)dataSource NS_DESIGNATED_INITIALIZER;

+ (instancetype)carouselDataSourceWithDataSource:(id <MGDataSource>)dataSource;

@end

@interface MGCarouselDataSource (ReadOnly)

@property (nonatomic, readonly) id <MGDataSource> dataSource;

@end