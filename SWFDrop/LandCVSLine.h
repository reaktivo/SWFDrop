//
//  LandCVSLine.h
//  SWFDrop
//
//  Created by Marcel Miranda on 4/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

extern const NSString *kFieldDefaultValue;
extern const NSString *kFieldValue1;

extern const NSString *kEmptyValue;

extern const NSString *kBackgroundType;
extern const NSString *kStructureType;

@interface LandCVSLine : NSObject {
@private
    
}



@property (nonatomic, retain) NSString *land;
@property (nonatomic, retain) NSString *file;
@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSString *scaleX;
@property (nonatomic, retain) NSString *scaleY;
@property (nonatomic, retain) NSString *x;
@property (nonatomic, retain) NSString *y;
@property (nonatomic, retain) NSString *order;
@property (nonatomic, retain) NSString *willCollide;
@property (nonatomic, retain) NSString *link;
@property (nonatomic, retain) NSString *isPortal;
@property (nonatomic, retain) NSString *destination;
@property (nonatomic, retain) NSString *reference;
@property (nonatomic, retain) NSString *remove;
@property (nonatomic, retain) NSString *defaultLand;




-(NSString *)getCVS;

@end
