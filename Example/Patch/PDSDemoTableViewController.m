//
//  PDSDemoTableViewController.m
//  Patch
//
//  Created by Adam Iredale on 03/23/2015.
//  Copyright (c) 2014 Adam Iredale. All rights reserved.
//

#import "PDSDemoTableViewController.h"

#pragma mark - Data Factory

#import "PDSDemoDataFactory.h"

#pragma mark - Shared Protocols

#import "PDSDemoProtocols.h"

@interface PDSDemoTableViewController ()

@property (nonatomic, strong) PDSTableViewDataSource *tableViewDataSource;

@end

@implementation PDSDemoTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
//    id <PDSDataSource> compositeTest = [PDSDemoDataFactory filteredCompositeDataSource];
//    
//    NSLog(@"Number of items in the composite filter is: %lu", compositeTest.numberOfItems);
//    for (int i = 0; i < compositeTest.numberOfItems; i++)
//    {
//        id item = [compositeTest itemAtIndex:i];
//        NSLog(@"Item %lu is: %@", (long)i, item);
//    }
    self.tableViewDataSource = [PDSTableViewDataSource dataSourceWithDataSource:[PDSDemoDataFactory mainMenuItemsDataSource]];
    // Set how the cells will react
    _tableViewDataSource.cellAtIndexPathBlock = ^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath, id itemAtIndex)
    {
        // Cell identifier taken from storyboard in this example
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PatchCell" forIndexPath:indexPath];
        // Each item is created in our data factory to support the demo menu item protocol
        // SIDE NOTE OF FUN - NSAssert strongly captures 'self' in blocks. Good to know...
        assert([itemAtIndex conformsToProtocol:@protocol(PDSDemoMenuItem)]);
        
        id <PDSDemoMenuItem> item = itemAtIndex;
        
        cell.textLabel.text          = item.title;
        cell.detailTextLabel.text    = item.subtitle;
        
        return cell;
    };
    self.tableView.dataSource = _tableViewDataSource;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
