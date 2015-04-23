//
//  PatchTests.m
//  PatchTests
//
//  Created by Adam Iredale on 03/23/2015.
//  Copyright (c) 2014 Adam Iredale. All rights reserved.
//

// !!! Split this up

@import UIKit;
@import CoreData;

#pragma mark - Framework Under Test

#import "Patch.h"

#pragma mark - Classes To Prove A Point

#import "PDSDemoMenuItem.h"
#import "PDSDemoPerson.h"

#pragma mark - Third Party Frameworks

#import <iCarousel/iCarousel.h>
#import <MagicalRecord/CoreData+MagicalRecord.h>

SpecBegin(PDSFilteredDataSource)

describe(@"assure filtering support for simple numeric array datasources and composites", ^{
    
    __block id <PDSDataSource> arrayDataSource1     = nil;
    __block id <PDSDataSource> arrayDataSource2     = nil;
    __block id <PDSDataSource> compositeDataSource  = nil;
    
    beforeAll(^{
        arrayDataSource1    = [PDSArrayDataSource arrayDataSourceWithArray:@[ @1, @3, @5 ]];
        arrayDataSource2    = [PDSArrayDataSource arrayDataSourceWithArray:@[ @2, @4, @6 ]];
        compositeDataSource = [PDSCompositeDataSource compositeDataSourceWithDataSources:@[arrayDataSource1, arrayDataSource2]];
    });
    
    it(@"filters numeric array datasources with format predicates", ^{
        id <PDSDataSource> expected = [PDSArrayDataSource arrayDataSourceWithArray:@[ @1, @3 ]];
        id <PDSDataSource> output = [PDSFilteredDataSource filteredDataSourceWithDataSource:arrayDataSource1 filter:[NSPredicate predicateWithFormat:@"self < 4"]];
        expect(output.numberOfItems).to.equal(expected.numberOfItems);
        expect([output itemAtIndex:0]).to.equal([expected itemAtIndex:0]);
        expect([output itemAtIndex:1]).to.equal([expected itemAtIndex:1]);
    });
    
    it(@"filters composite numeric array datasources with format predicates", ^{
        id <PDSDataSource> expected = [PDSArrayDataSource arrayDataSourceWithArray:@[ @1, @3, @2 ]];
        id <PDSDataSource> output = [PDSFilteredDataSource filteredDataSourceWithDataSource:compositeDataSource filter:[NSPredicate predicateWithFormat:@"self < 4"]];
        expect(output.numberOfItems).to.equal(expected.numberOfItems);
        expect([output itemAtIndex:0]).to.equal([expected itemAtIndex:0]);
        expect([output itemAtIndex:1]).to.equal([expected itemAtIndex:1]);
        expect([output itemAtIndex:2]).to.equal([expected itemAtIndex:2]);
    });
});

describe(@"assure filtering support for object array datasources and composites", ^{
    
    __block id <PDSDataSource> arrayDataSource1     = nil;
    __block id <PDSDataSource> arrayDataSource2     = nil;
    __block id <PDSDataSource> compositeDataSource  = nil;
    
    beforeAll(^{
        arrayDataSource1    = [PDSArrayDataSource arrayDataSourceWithArray:@[
                                                                             [PDSDemoMenuItem menuItemWithTitle:@"one" subtitle:@"alpha"],
                                                                             [PDSDemoMenuItem menuItemWithTitle:@"two" subtitle:@"beta"],
                                                                             [PDSDemoMenuItem menuItemWithTitle:@"three" subtitle:@"gamma"],
                                                                             ]];
        arrayDataSource2    = [PDSArrayDataSource arrayDataSourceWithArray:@[
                                                                             [PDSDemoMenuItem menuItemWithTitle:@"four" subtitle:@"delta"],
                                                                             [PDSDemoMenuItem menuItemWithTitle:@"five" subtitle:@"epsilon"],
                                                                             [PDSDemoMenuItem menuItemWithTitle:@"six" subtitle:@"zeta"],
                                                                             ]];
        compositeDataSource = [PDSCompositeDataSource compositeDataSourceWithDataSources:@[arrayDataSource1, arrayDataSource2]];
    });
    
    it(@"filters object array datasources with format predicates", ^{
        NSArray *expectedTitles = @[@"one", @"two"];
        id <PDSDataSource> output = [PDSFilteredDataSource filteredDataSourceWithDataSource:arrayDataSource1 filter:[NSPredicate predicateWithFormat:@"title CONTAINS[cd] 'o'"]];
        expect(output.numberOfItems).to.equal(expectedTitles.count);
        expect([[output itemAtIndex:0] title]).to.equal([expectedTitles objectAtIndex:0]);
        expect([[output itemAtIndex:1] title]).to.equal([expectedTitles objectAtIndex:1]);
    });
    
    it(@"filters composite object array datasources with format predicates", ^{
        NSArray *expectedTitles = @[@"one", @"two", @"four"];
        id <PDSDataSource> output = [PDSFilteredDataSource filteredDataSourceWithDataSource:compositeDataSource filter:[NSPredicate predicateWithFormat:@"title CONTAINS[cd] 'o'"]];
        expect(output.numberOfItems).to.equal(expectedTitles.count);
        expect([[output itemAtIndex:0] title]).to.equal([expectedTitles objectAtIndex:0]);
        expect([[output itemAtIndex:1] title]).to.equal([expectedTitles objectAtIndex:1]);
        expect([[output itemAtIndex:2] title]).to.equal([expectedTitles objectAtIndex:2]);
    });
    
    it(@"filters composite object array datasources with block predicates", ^{
        NSArray *expectedTitles = @[@"one", @"two", @"four"];
        id <PDSDataSource> output = [PDSFilteredDataSource filteredDataSourceWithDataSource:compositeDataSource filter:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            return [[evaluatedObject title] containsString:@"o"];
        }]];
        expect(output.numberOfItems).to.equal(expectedTitles.count);
        expect([[output itemAtIndex:0] title]).to.equal([expectedTitles objectAtIndex:0]);
        expect([[output itemAtIndex:1] title]).to.equal([expectedTitles objectAtIndex:1]);
        expect([[output itemAtIndex:2] title]).to.equal([expectedTitles objectAtIndex:2]);
    });
});

describe(@"assure core data filtering support", ^{
    
    __block id <PDSDataSource> coreDataSource   = nil;
    __block NSArray *names                      = @[@"alice", @"bob", @"trudy"];
    __block NSArray *ages                       = @[@39, @24, @29];
    
    void (^createTestPerson)(NSString *, NSNumber *) = ^(NSString *name, NSNumber *age){
        PDSDemoPerson *person   = [PDSDemoPerson MR_createEntity];
        person.name             = name;
        person.age              = age;
    };
    
    beforeAll(^{
        [MagicalRecord setupCoreDataStackWithInMemoryStore];
        NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
        for (int i = 0; i < names.count; i++)
        {
            createTestPerson(names[i], ages[i]);
        }
        expect([context save:nil]).to.beTruthy;
        coreDataSource = [PDSCoreDataSource dataSourceWithEntityName:@"PDSDemoPerson"
                                                     sortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"age" ascending:YES]]
                                                           predicate:nil
                                                          andContext:[NSManagedObjectContext MR_defaultContext]];
    });
    
    afterAll(^{
        [MagicalRecord cleanUp];
    });
    
    it(@"should support basic format filtering", ^{
        id <PDSDataSource> dataSource = [PDSFilteredDataSource filteredDataSourceWithDataSource:coreDataSource filter:[NSPredicate predicateWithFormat:@"age < 30"]];
        expect(dataSource.numberOfItems).to.equal(2);
        expect([[dataSource itemAtIndex:0] name]).to.equal(@"bob");
        expect([[dataSource itemAtIndex:1] name]).to.equal(@"trudy");
    });
});

SpecEnd

SpecBegin(PDSCompositeDataSource)

describe(@"contains all data from sources", ^{
    
    __block id <PDSDataSource> arrayDataSource1     = nil;
    __block id <PDSDataSource> arrayDataSource2     = nil;
    __block id <PDSDataSource> compositeDataSource  = nil;
    
    beforeAll(^{
        arrayDataSource1    = [PDSArrayDataSource arrayDataSourceWithArray:@[ @1, @3, @5 ]];
        arrayDataSource2    = [PDSArrayDataSource arrayDataSourceWithArray:@[ @2, @4, @6 ]];
        compositeDataSource = [PDSCompositeDataSource compositeDataSourceWithDataSources:@[arrayDataSource1, arrayDataSource2]];
    });
    
    it(@"has total length equal to sum of source length", ^{
        expect(compositeDataSource.numberOfItems).to.equal(arrayDataSource1.numberOfItems + arrayDataSource2.numberOfItems);
    });
    
    it(@"supports filtering", ^{
        expect([compositeDataSource conformsToProtocol:@protocol(PDSFilterableDataSource)]).to.beTruthy;
    });
});

SpecEnd

SpecBegin(PDSArrayDataSource)

describe(@"contains all items from source array", ^{
    
    __block NSArray *staticObjectArray          = nil;
    __block id <PDSDataSource> arrayDataSource  = nil;
    
    beforeAll(^{
        staticObjectArray = @[ @1, @2, @3 ];
        arrayDataSource = [PDSArrayDataSource arrayDataSourceWithArray:staticObjectArray];
    });
    
    it(@"has the same count as the source array", ^{
        expect(arrayDataSource.numberOfItems).to.equal(staticObjectArray.count);
    });
    
    it(@"supports filtering", ^{
        expect([arrayDataSource conformsToProtocol:@protocol(PDSFilterableDataSource)]).to.beTruthy;
    });
    
});

SpecEnd

SpecBegin(PDSCoreDataSource)

describe(@"contains all items from source query", ^{
    
    __block id <PDSDataSource> coreDataSource   = nil;
    __block NSArray *names                      = @[@"alice", @"bob", @"trudy"];
    __block NSArray *ages                       = @[@39, @24, @29];
    
    void (^createTestPerson)(NSString *, NSNumber *) = ^(NSString *name, NSNumber *age){
        PDSDemoPerson *person   = [PDSDemoPerson MR_createEntity];
        person.name             = name;
        person.age              = age;
    };
    
    beforeAll(^{
        [MagicalRecord setupCoreDataStackWithInMemoryStore];
        NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
        for (int i = 0; i < names.count; i++)
        {
            createTestPerson(names[i], ages[i]);
        }
        expect([context save:nil]).to.beTruthy;
        coreDataSource = [PDSCoreDataSource dataSourceWithEntityName:@"PDSDemoPerson"
                                                     sortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"age" ascending:YES]]
                                                           predicate:nil
                                                          andContext:[NSManagedObjectContext MR_defaultContext]];
    });
    
    afterAll(^{
        [MagicalRecord cleanUp];
    });
    
    it(@"has the same count as the source data", ^{
        expect(coreDataSource.numberOfItems).to.equal(names.count);
    });
    
    it(@"supports filtering", ^{
        expect([coreDataSource conformsToProtocol:@protocol(PDSFilterableDataSource)]).to.beTruthy;
    });
    
});

SpecEnd
