//
//  MGCoreDataSource.h
//  Mytograph
//
//  Created by Adam Iredale on 3/12/2014.
//  Copyright (c) 2014 Bionic Monocle Pty Ltd. All rights reserved.
//

/**
 *  Core Data datasource
 */

@interface MGCoreDataSource : NSObject <MGChangingDataSource>

@property (nonatomic, strong) NSPredicate *fetchPredicate;

- (instancetype)initWithEntityName:(NSString *)name sortDescriptors:(NSArray *)sortDescriptors andContext:(NSManagedObjectContext *)context NS_DESIGNATED_INITIALIZER;

+ (instancetype)dataSourceWithEntityName:(NSString *)name sortDescriptors:(NSArray *)sortDescriptors andContext:(NSManagedObjectContext *)context;

+ (instancetype)dataSourceWithEntityName:(NSString *)name sortDescriptors:(NSArray *)sortDescriptors predicate:(NSPredicate *)predicate andContext:(NSManagedObjectContext *)context;

@end
