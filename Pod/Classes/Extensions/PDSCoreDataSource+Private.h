//
//  PDSCoreDataSource+Private.h
//  Pods
//
//  Created by Adam Iredale on 22/04/2015.
//
//

@interface PDSCoreDataSource (Private) <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSManagedObjectContext        *context;
@property (nonatomic, strong) NSFetchRequest                *fetchRequest;
@property (nonatomic, strong) NSFetchedResultsController    *fetchedResultsController;

@end