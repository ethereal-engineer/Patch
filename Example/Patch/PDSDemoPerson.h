//
//  PDSDemoPerson.h
//  Patch
//
//  Created by Adam Iredale on 23/04/2015.
//  Copyright (c) 2015 Adam Iredale. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface PDSDemoPerson : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * age;

@end
