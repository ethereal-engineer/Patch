//
//  PDSDemoPageViewController.m
//  Patch
//
//  Created by Adam Iredale on 26/05/2015.
//  Copyright (c) 2015 Adam Iredale. All rights reserved.
//

#import "PDSDemoPageViewController.h"

#pragma mark - Models

#import "PDSDemoPerson.h"

#pragma mark - Magical Record

#import <MagicalRecord/CoreData+MagicalRecord.h>

#pragma mark - View Controllers

#import "PDSDemoContentViewController.h"

@interface PDSDemoPageViewController ()

// Embedded view controllers

@property (nonatomic, strong) UITableViewController *tableViewController;
@property (nonatomic, strong) UIPageViewController *pageViewController;

// DataSource

@property (nonatomic, strong) PDSPageViewControllerDataSource *pageViewControllerDataSource;

@end

@implementation PDSDemoPageViewController

- (id <PDSDataSource>)pageItemDataSource
{
    return [PDSCoreDataSource dataSourceWithEntityName:[[PDSDemoPerson MR_entityDescription] name]
                                       sortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]
                                             predicate:[NSPredicate predicateWithFormat:@"NOT(isHidden == YES)"]
                                            andContext:[NSManagedObjectContext MR_defaultContext]];
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Embed segues are done, references kept
    
    UIStoryboard *storyboard = self.storyboard;
    
    // Set up datasource for the page view controller
    UIViewController *placeholderViewController = [storyboard instantiateViewControllerWithIdentifier:@"placeholderViewController"];
    
    self.pageViewControllerDataSource = [PDSPageViewControllerDataSource pageViewControllerDataSourceWithDataSource:[self pageItemDataSource]
                                                                                          placeholderViewController:placeholderViewController];
    self.pageViewControllerDataSource.instantiateViewControllerBlock = ^UIViewController *(NSInteger index, id itemAtIndex)
    {
        return [storyboard instantiateViewControllerWithIdentifier:@"contentViewController"];
    };
    
    self.pageViewControllerDataSource.configureViewControllerBlock = ^(UIViewController *viewController, NSInteger index, id itemAtIndex)
    {
        [(PDSDemoContentViewController *)viewController setPerson:itemAtIndex];
    };
    self.pageViewController.dataSource = self.pageViewControllerDataSource;
}

#pragma mark - Actions

- (IBAction)forceReloadTapped:(id)sender
{
    // Ensuring that the current item holds its place
    [self.pageViewControllerDataSource.dataSource reload];
}


#pragma mark - Snatch References

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    
    // Keep references to the embedded view controllers, respectively
    if ([segue.identifier isEqualToString:@"tableViewControllerEmbedSegue"])
    {
        self.tableViewController = segue.destinationViewController;
    }
    else if ([segue.identifier isEqualToString:@"pageViewControllerEmbedSegue"])
    {
        self.pageViewController = segue.destinationViewController;
    }
}

@end
