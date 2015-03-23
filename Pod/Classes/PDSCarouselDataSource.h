//
//  PDSCarouselDataSource.h
//  Patch
//
//  Created by Adam Iredale on 3/12/2014.
//  Copyright (c) 2014 Bionic Monocle Pty Ltd. All rights reserved.
//

/**
 *  Datasource adapter from generic datasource to iCaraousel
 */

#import "PatchProtocols.h"

@interface PDSCarouselDataSource : NSObject <iCarouselDataSource, PDSDataSourceChangeListener>

@property (nonatomic, copy) UIView *(^instantiateViewBlock)(NSInteger index);

@property (nonatomic, copy) void (^configureViewBlock)(UIView *view, NSInteger index, id itemAtIndex);

- (instancetype)initWithDataSource:(id <PDSDataSource>)dataSource NS_DESIGNATED_INITIALIZER;

+ (instancetype)carouselDataSourceWithDataSource:(id <PDSDataSource>)dataSource;

@end

@interface PDSCarouselDataSource (ReadOnly)

@property (nonatomic, readonly) id <PDSDataSource> dataSource;

@end