//
//  PDSPredicatePropertyCoreDataSource.m
//  Patch
//
//  Created by Adam Iredale on 12/02/2015.
//  Copyright (c) 2015 Bionic Monocle Pty Ltd. All rights reserved.
//

#import "PDSPredicatePropertyCoreDataSource.h"

@interface PDSPredicatePropertyCoreDataSource ()
/**
 *  Object we watch for changes to the predicate keypath
 */
@property (nonatomic, strong) id monitoredObject;


@end

@implementation PDSPredicatePropertyCoreDataSource

- (instancetype)initWithDataSource:(id<PDSDataSource>)dataSource
{
    self = [self initWithHostObject:nil predicateKeyPath:nil entityName:nil sortDescriptors:nil context:nil];
    if (self)
    {
        // Will always fail - please use designated init
    }
    return self;
}

- (instancetype)initWithHostObject:(id)object predicateKeyPath:(NSString *)keyPath entityName:(NSString *)entityName sortDescriptors:(NSArray *)sortDescriptors context:(NSManagedObjectContext *)context
{
    NSParameterAssert(object);
    NSParameterAssert(keyPath.length);
    NSParameterAssert(entityName);
    NSParameterAssert(sortDescriptors.count);
    NSParameterAssert(context);
    
    self = [super initWithDataSource:nil];
    if (self)
    {
        
    }
    return self;
}

@end
