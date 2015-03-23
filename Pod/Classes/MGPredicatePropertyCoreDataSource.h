//
//  MGPredicatePropertyCoreDataSource.h
//  Mytograph
//
//  Created by Adam Iredale on 12/02/2015.
//  Copyright (c) 2015 Bionic Monocle Pty Ltd. All rights reserved.
//

/**
 *  Given an object and a property evaluating to an NSPredicate on that object
 *  (and obviously an entity type), this datasource will update contents as they
 *  change based on changes to the predicate property or the results of the query
 */

#import "MGPassThroughDataSource.h"

@interface MGPredicatePropertyCoreDataSource : MGPassThroughDataSource

@property (nonatomic, readonly) NSPredicate *currentPredicate;

- (instancetype)initWithHostObject:(id)object predicateKeyPath:(NSString *)keyPath entityName:(NSString *)entityName sortDescriptors:(NSArray *)sortDescriptors context:(NSManagedObjectContext *)context NS_DESIGNATED_INITIALIZER;

@end
