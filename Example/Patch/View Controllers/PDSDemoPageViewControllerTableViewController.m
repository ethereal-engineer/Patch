//
//  PDSDemoPageViewControllerTableViewController.m
//  Patch
//
//  Created by Adam Iredale on 26/05/2015.
//  Copyright (c) 2015 Adam Iredale. All rights reserved.
//

#import "PDSDemoPageViewControllerTableViewController.h"

#pragma mark - Magical Record

#import <MagicalRecord/CoreData+MagicalRecord.h>

#pragma mark - Entity

#import "PDSDemoPerson.h"

// Dictionary Keys for adhoc datasource items
static NSString *const kTitleKey = @"kTitleKey";
static NSString *const kBlockKey = @"kBlockKey";

@interface PDSDemoPageViewControllerTableViewController ()

@property (nonatomic, strong) PDSTableViewDataSource *tableViewDataSource;

@end

@implementation PDSDemoPageViewControllerTableViewController

#pragma mark - DataSources (Move To A Factory For Cleanliness)

- (NSString *)randomFirstName
{
    NSArray *names = @[@"Harry", @"Bob", @"Larry", @"Joe", @"Kumar", @"Amir", @"Felicia", @"Joanne", @"Lisa", @"Trudy", @"Alice"];
    return names[arc4random() % names.count];
}

- (NSString *)randomLastName
{
    NSArray *names = @[@"Zek", @"Lazlow", @"Larryson", @"Forge", @"Senmat", @"Chekk", @"Carrison", @"Bobar", @"Loton", @"Mason", @"Drol"];
    return names[arc4random() % names.count];
}

- (NSString *)randomProfession
{
    NSArray *names = @[@"Data Scientist", @"Laboratory Assistant", @"Lambda Scientist", @"Programmer", @"Sales Technician", @"Mobile Lead", @"Junior Developer", @"Bobcat Handler", @"Staff Talent Manager", @"Engineer", @"Worker"];
    return names[arc4random() % names.count];
}

- (id <PDSDataSource>)tableItemDataSource
{
    // All of the actions we want to be able to perform on the page view datasource
    // to fully put it through its paces
    
    __weak typeof(self) weakSelf = self;
    
    return [PDSArrayDataSource arrayDataSourceWithArray:
            @[
              @{
                  kTitleKey : @"Add a person",
                  kBlockKey : ^()
    {
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext)
         {
             PDSDemoPerson *person = [PDSDemoPerson MR_createInContext:localContext];
             
             person.name            = [[weakSelf randomFirstName] stringByAppendingFormat:@" %@", [weakSelf randomLastName]];
             person.age             = @(arc4random() % 120);
             person.profession      = [weakSelf randomProfession];
             person.drinkPreference = @(arc4random() % 2);
             
         }];
    }
                  },
              @{
                  kTitleKey : @"Unhide all",
                  kBlockKey : ^()
                  {
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext)
         {
             NSArray *all = [PDSDemoPerson MR_findAllInContext:localContext];
             if (!all.count)
             {
                 NSLog(@"NO PEOPLE FOUND WTF!");
                 return;
             }
             for (PDSDemoPerson *person in all)
             {
                 NSLog(@"Unhiding: %@", person.name);
                 person.isHidden = @NO;
             }
         }];
    }
                  }
              ]];
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set up the datasources for the table and page view controller
    self.tableViewDataSource = [PDSTableViewDataSource dataSourceWithDataSource:[self tableItemDataSource]];
    _tableViewDataSource.cellAtIndexPathBlock = ^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath, id itemAtIndexPath)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        cell.textLabel.text = itemAtIndexPath[kTitleKey];
        return cell;
    };
    
    self.tableView.dataSource = self.tableViewDataSource;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Execute the block
    NSDictionary *itemAtIndexPath = [self.tableViewDataSource.dataSource itemAtIndexPath:indexPath];
    dispatch_block_t block = itemAtIndexPath[kBlockKey];
    if (block)
    {
        block();
    }
    else
    {
        NSLog(@"WARNING: No block defined for item!");
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
