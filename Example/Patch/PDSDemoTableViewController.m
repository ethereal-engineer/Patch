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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id <PDSDemoMenuItem> menuItem = [self.tableViewDataSource.dataSource itemAtIndexPath:indexPath];
    NSString *storyboardName = menuItem.userInfo[PDSDemoStoryboardNameKey];
    if (storyboardName)
    {
        UIViewController *viewController = [[UIStoryboard storyboardWithName:storyboardName bundle:nil] instantiateInitialViewController];
        [self showViewController:viewController sender:self];
    }
    else
    {
        NSLog(@"Demo portion for menu item %@ is not yet implemented. Sorry!", menuItem.title);
    }
}

@end
