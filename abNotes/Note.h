//
//  Note.h
//  
//
//  Created by mhtran on 5/29/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Note : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) id image;
@property (nonatomic, retain) NSNumber * displayIndex;
@property (nonatomic, retain) NSDate * dateCreated;
@property (nonatomic, retain) NSString * body;

@end
