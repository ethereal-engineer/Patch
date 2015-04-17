//
//  NSArray+PDSSampledArray.m
//  Patch
//
//  Created by Adam Iredale on 13/02/2015.
//  Copyright (c) 2015 Bionic Monocle Pty Ltd. All rights reserved.
//

#import "NSArray+PDSSampledArray.h"

#pragma mark - Sample DataSource (for ugly macro)

#import "PDSSampleDataSource.h"

@implementation NSArray (PDSSampledArray)

- (NSArray *)sampledArrayWithMaximumCount:(NSInteger)maximumCount
{
    if (maximumCount >= self.count)
    {
        return self;
    }
    
    NSInteger maximumIndex          = maximumCount - 1;
    NSInteger maximumActualIndex    = self.count - 1;
    
    double delta = PDSIndexMappingDelta(maximumActualIndex, maximumIndex);
    
    NSMutableIndexSet *sampledSet = [NSMutableIndexSet indexSet];
    
    // Build a set of sampled indicies
    for (NSInteger index = 0; index <= maximumIndex; index++)
    {
        [sampledSet addIndex:round((double)index * delta)];
    }
    
    return [self objectsAtIndexes:sampledSet];
}

@end
