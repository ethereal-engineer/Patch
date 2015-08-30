//
//  PDSDemoContentViewController.m
//  Patch
//
//  Created by Adam Iredale on 27/05/2015.
//  Copyright (c) 2015 Adam Iredale. All rights reserved.
//

#import "PDSDemoContentViewController.h"

#pragma mark - Entity

/**
 *  There are many ways to do this kind of MVVM - having the view controller class set itself up from
 *  the entity is one of them. This can be complicated in the case of Core Data, but in this case
 *  is used because each view can also modify the Core Data entity. Thread boundaries must be observed
 *  with great caution. All manipulations are done on the context of the object itself, which is assumed
 *  to be on the same thread that the object is passed in on/with.
 */

#import "PDSDemoPerson.h"

#pragma mark - Magical Record

#import <MagicalRecord/CoreData+MagicalRecord.h>

@interface PDSDemoContentViewController ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *agelabel;
@property (weak, nonatomic) IBOutlet UILabel *professionLabel;

@property (weak, nonatomic) IBOutlet UISegmentedControl *drinkPreferenceControl;
@property (weak, nonatomic) IBOutlet UISlider *courseProgressSlider;

@property (strong, nonatomic) IBOutlet UIView *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *hideButton;


@end

@implementation PDSDemoContentViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadFromPerson];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Core Data Object Interaction

- (void)setPerson:(PDSDemoPerson *)person
{
    _person = person;
    if (self.isViewLoaded)
    {
        [self loadFromPerson];
    }
}

- (void)loadFromPerson
{
    self.nameLabel.text                                 = self.person.name;
    self.agelabel.text                                  = self.person.age.stringValue;
    self.professionLabel.text                           = self.person.profession;
    self.drinkPreferenceControl.selectedSegmentIndex    = self.person.drinkPreference.unsignedIntegerValue;
    self.courseProgressSlider.value                     = self.person.courseProgress.floatValue;
}

- (void)saveToPerson
{
    NSManagedObjectContext *context = self.person.managedObjectContext;
    NSError *error = nil;
    if (context.hasChanges && ![context save:&error])
    {
        NSLog(@"Error saving changes to person! %@", error);
    }
}

#pragma mark - Actions

- (IBAction)drinkPreferenceChanged:(id)sender
{
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext)
     {
         PDSDemoPerson *person = [self.person MR_inContext:localContext];
         person.drinkPreference = @(self.drinkPreferenceControl.selectedSegmentIndex);
     }];
}

- (IBAction)courseProgressChanged:(id)sender
{
    // Yes, this is intentionally built to HAMMER the saves
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext)
     {
         PDSDemoPerson *person = [self.person MR_inContext:localContext];
         person.courseProgress = @(self.courseProgressSlider.value);
     }];
}

- (IBAction)deleteButtonTapped:(id)sender
{
    [self.person.managedObjectContext deleteObject:self.person];
}

- (IBAction)hideButtonTapped:(id)sender
{
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext)
    {
        PDSDemoPerson *person = [self.person MR_inContext:localContext];
        person.isHidden = @YES;
    }];
}


@end
