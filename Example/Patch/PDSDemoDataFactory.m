//
//  PDSDemoDataFactory.m
//  Patch
//
//  Created by Adam Iredale on 23/03/2015.
//  Copyright (c) 2015 Adam Iredale. All rights reserved.
//

#import "PDSDemoDataFactory.h"

#pragma mark - Menu Item

#import "PDSDemoMenuItem.h"

@interface PDSDemoDataFactory ()

@end

@implementation PDSDemoDataFactory

#pragma mark - Menu Items

+ (id<PDSDataSource>)mainMenuItemsDataSource
{
    return [PDSArrayDataSource arrayDataSourceWithArray:
            @[
              [PDSDemoMenuItem menuItemWithTitle:@"Array DataSource"
                                        subtitle:@"TableView"
                                        userInfo:nil],
              [PDSDemoMenuItem menuItemWithTitle:@"Array DataSource"
                                        subtitle:@"CollectionView, Sampled"
                                        userInfo:@{
                                                   PDSDemoStoryboardNameKey : @"SampleCollectionView"
                                                   }],
              [PDSDemoMenuItem menuItemWithTitle:@"Core Data DataSource"
                                        subtitle:@"PageViewController"
                                        userInfo:@{
                                                   PDSDemoStoryboardNameKey : @"PDSDemoPageViewController"
                                                   }],
              [PDSDemoMenuItem menuItemWithTitle:@"Array DataSource"
                                        subtitle:@"iCaraousel"
                                        userInfo:nil]
              ]];
}

#pragma mark - Other

+ (id<PDSDataSource>)arrayDataSource
{
    return [PDSArrayDataSource arrayDataSourceWithArray:@[@1, @3, @5]];
}

+ (id<PDSDataSource>)filteredCompositeDataSource
{
    id <PDSDataSource> arrayDataSource1 = [PDSArrayDataSource arrayDataSourceWithArray:@[@1, @3, @5]];
    id <PDSDataSource> arrayDataSource2 = [PDSArrayDataSource arrayDataSourceWithArray:@[@2, @4, @6]];
    
    id <PDSDataSource> compositeDataSource = [PDSCompositeDataSource compositeDataSourceWithDataSources:@[arrayDataSource1, arrayDataSource2]];
    
    return [PDSFilteredDataSource filteredDataSourceWithDataSource:compositeDataSource
                                                            filter:[NSPredicate predicateWithFormat:@"self < 4"]];
}

+ (id<PDSDataSource>)mappedRandomNumberDataSource
{
    // I'll fashion this into a nicer abstract datasource later on
    return nil;
}

@end
