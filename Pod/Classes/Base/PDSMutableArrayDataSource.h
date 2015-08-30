//
//  PDSMutableArrayDataSource.h
//  Pods
//
//  Created by Adam Iredale on 28/05/2015.
//
//

/**
 *  Generic datasource based on NSArray
 */

#import "PatchProtocols.h"

@interface PDSMutableArrayDataSource : NSObject <PDSChangingDataSource>
/**
 *  Initialise with an array of items for the initial content of the datasource. Note that this is
 *  copied, so any modifications to the source once copied will not affect the datasource. To 
 *  alter the datasource, use the datasource's `array` property.
 *
 *  @param array Initial datasource content array
 *
 *  @return An instance of PDSMutableArrayDataSource
 */
- (instancetype)initWithArray:(NSArray *)array NS_DESIGNATED_INITIALIZER;

+ (instancetype)arrayDataSourceWithArray:(NSArray *)array;

@end

@interface PDSMutableArrayDataSource (ReadOnly)

@property (nonatomic, readonly) NSMutableArray *array;

@end