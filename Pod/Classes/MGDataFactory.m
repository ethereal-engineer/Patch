//
//  MGDataFactory.m
//  Mytograph
//
//  Created by Adam Iredale on 3/12/2014.
//  Copyright (c) 2014 Bionic Monocle Pty Ltd. All rights reserved.
//

// TODO: Break this up into categories!

#import "MGDataFactory.h"

#pragma mark - Frameworks

#import <MagicalRecord/CoreData+MagicalRecord.h>

#pragma mark - DataSource Classes

#import "MGDataSource.h"

#pragma mark - Class Cluster

#import "MGDataFactory+ContentPacks.h"
#import "MGDataFactory+PlaceMenuItems.h"
#import "MGDataFactory+DateMenuItems.h"

#pragma mark - Core Data Entities (avoid stringly typing)

#import "MGModels.h"

#pragma mark - Non-Core-Data Models

#import "MGContentPack.h"

#pragma mark - Menu Items

#import "MGMenuItems.h"

#pragma mark - Constants

static const NSInteger  kDefaultMinimumPhotoCountToShowGroup    = 15;

@implementation MGDataFactory

#pragma mark - User Data

+ (id<MGDataSource>)personDataSource
{
    return [MGCoreDataSource dataSourceWithEntityName:[MGPerson entityName]
                                      sortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"lastModifiedDate" ascending:YES]]
                                           andContext:[self defaultContext]];
}

+ (id<MGDataSource>)projectDataSource
{
    return [MGCoreDataSource dataSourceWithEntityName:[MGProject entityName]
                                      sortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"lastModifiedDate" ascending:YES]]
                                           andContext:[self defaultContext]];
}

#pragma mark - Menu Items (duped)?

+ (id<MGDataSource>)menuItemDataSourceForContentPacksOfType:(NSString *)packType
{
    // We will map the directory contents of the pack directory with an object that can make sense of
    // each item in the directory, without unneccesarily involving Core Data
    return [MGMappedDataSource mappedDataSourceWithDataSource:[self contentPackDataSourceForContentPacksOfType:packType]
                                                      functor:^id(MGContentPack *contentPack)
            {
                // Return a menu item with an attached content pack
                NSError *error = nil;
                UIImage *thumbnailImage = [contentPack thumbnailImage:&error] ?: [UIImage imageNamed:@"MenuItemNotAFace"];
                // TODO: error handling?
                return [MGContentPackMenuItem menuItemWithIdentifier:contentPack.identifier
                                                               title:contentPack.localizedDisplayName
                                                               image:thumbnailImage
                                                         contentPack:contentPack];
            }];
}

#pragma mark - Dates And Places

// Composite datasource of date and place datasources

+ (id<MGDataSource>)datesAndPlacesDataSourceForHomeAddress:(LMAddress *)address referenceDate:(NSDate *)date
{
    return [MGCompositeDataSource compositeDataSourceWithDataSources:@[
                                                                       [self filteredDateMenuItemDataSourceWithReferenceDate:date minimumCount:[self minimumPhotoCountToShowGroup]],
                                                                       [self filteredPlaceMenuItemDataSourceForHomeAddress:address minimumCount:[self minimumPhotoCountToShowGroup]]
                                                                       ]];
}

#pragma mark - Filtered Versions

+ (id<MGDataSource>)filteredDateMenuItemDataSourceWithReferenceDate:(NSDate *)date minimumCount:(NSInteger)minimumCount
{
    return [self dateMenuItemDataSourceWithReferenceDate:date];
}

+ (id<MGDataSource>)filteredPlaceMenuItemDataSourceForHomeAddress:(LMAddress *)address minimumCount:(NSInteger)minimumCount
{
    return [self placeMenuItemDataSourceForHomeAddress:address];
}

+ (NSPredicate *)minimumCountBlockPredicateWithMinimumCount:(NSInteger)minimumCount
{
    __weak typeof(self) weakSelf = self;
    BOOL (^hideItemsWithLessThanMinimumPhotoCountBlockPredicate)(id, NSDictionary *) = ^BOOL(MGPhotoPredicateMenuItem *menuItem, NSDictionary *bindings)
    {
        // Count how many photos this menu item predicate would return and return YES if greater than or equal to minimumCount
        return [MGPhoto MR_countOfEntitiesWithPredicate:menuItem.photoPredicate inContext:[weakSelf defaultContext]] >= minimumCount;
    };
    return [NSPredicate predicateWithBlock:hideItemsWithLessThanMinimumPhotoCountBlockPredicate];
}

#pragma mark - Project Data

+ (id<MGDataSource>)slideDataSourceForProject:(MGProject *)project
{
    NSParameterAssert(project);
    return
    [MGCoreDataSource dataSourceWithEntityName:[MGSlide entityName]
                               sortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"order" ascending:YES]]
                                     predicate:[NSPredicate predicateWithFormat:@"project == %@ && isUserDeleted != YES", project]
                                    andContext:[self defaultContext]];
}

#pragma mark - App Data

+ (id<MGDataSource>)personMenuItemDataSource
{
    return [MGArrayDataSource arrayDataSourceWithArray:@[
                                                         [MGMenuItem menuItemWithIdentifier:@"notaface"
                                                                                      title:@"Not A Face"
                                                                                      image:[UIImage imageNamed:@"MenuItemNotAFace"]
                                                                                   userInfo:nil],
                                                         [MGMenuItem menuItemWithIdentifier:@"detected"
                                                                                      title:@"Detected"
                                                                                      image:[UIImage imageNamed:@"MenuItemDetectedFaces"]
                                                                                   userInfo:nil]
                                                         
                                                         ]];
}

+ (id<MGDataSource>)projectMenuItemDataSource
{
    return [MGArrayDataSource arrayDataSourceWithArray:@[
                                                         [MGMenuItem menuItemWithIdentifier:@"newProject"
                                                                                      title:@"New Project"
                                                                                      image:[UIImage imageNamed:@"MenuItemAdd"]
                                                                                   userInfo:nil]
                                                         ]];
}

#pragma mark - Mixed Data

+ (id<MGDataSource>)personMenuDataSource
{
    return [MGCompositeDataSource compositeDataSourceWithDataSources:@[[self personMenuItemDataSource],[self personDataSource]]];
}

+ (id<MGDataSource>)projectMenuDataSource
{
    return [MGCompositeDataSource compositeDataSourceWithDataSources:@[[self projectMenuItemDataSource],[self projectDataSource]]];
}

#pragma mark - Default Context

+ (NSManagedObjectContext *)defaultContext
{
    return [NSManagedObjectContext MR_defaultContext];
}

#pragma mark - Static Minimum Count

+ (NSInteger)minimumPhotoCountToShowGroup
{
    return kDefaultMinimumPhotoCountToShowGroup;
}

@end
