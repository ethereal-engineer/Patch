//
//  PDSDemoDataFactory.m
//  Patch
//
//  Created by Adam Iredale on 23/03/2015.
//  Copyright (c) 2015 Adam Iredale. All rights reserved.
//

#import "PDSDemoDataFactory.h"

@implementation PDSDemoDataFactory

+ (id<PDSDataSource>)arrayDataSource
{
    return nil;
}

+ (id<PDSDataSource>)filteredCompositeDataSource
{
    id <PDSDataSource> arrayDataSource1 = [PDSArrayDataSource arrayDataSourceWithArray:@[@1, @3, @5]];
    id <PDSDataSource> arrayDataSource2 = [PDSArrayDataSource arrayDataSourceWithArray:@[@2, @4, @6]];
    
    id <PDSDataSource> compositeDataSource = [PDSCompositeDataSource compositeDataSourceWithDataSources:@[arrayDataSource1, arrayDataSource2]];
    
    return [PDSFilteredDataSource filteredDataSourceWithDataSource:compositeDataSource
                                                            filter:[NSPredicate predicateWithFormat:@"self < 4"]];
}

@end
