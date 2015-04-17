//
//  PDSDemoViewController.m
//  Patch
//
//  Created by Adam Iredale on 03/23/2015.
//  Copyright (c) 2014 Adam Iredale. All rights reserved.
//

#import "PDSDemoViewController.h"

#pragma mark - Data Factory

#import "PDSDemoDataFactory.h"

@interface PDSDemoViewController ()

@end

@implementation PDSDemoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    id <PDSDataSource> compositeTest = [PDSDemoDataFactory filteredCompositeDataSource];
    
    NSLog(@"Number of items in the composite filter is: %lu", compositeTest.numberOfItems);
    for (int i = 0; i < compositeTest.numberOfItems; i++)
    {
        id item = [compositeTest itemAtIndex:i];
        NSLog(@"Item %lu is: %@", (long)i, item);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
