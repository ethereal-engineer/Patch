//
//  PDSDemoPerson.h
//  
//
//  Created by Adam Iredale on 27/05/2015.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface PDSDemoPerson : NSManagedObject

@property (nonatomic, retain) NSNumber * age;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * profession;
@property (nonatomic, retain) NSNumber * drinkPreference;   // 0 - Coffee, 1 - Tea, 2 - Other
@property (nonatomic, retain) NSNumber * courseProgress;    // 0.0 - 1.0
@property (nonatomic, retain) NSNumber * isHidden;          // BOOL

@end
