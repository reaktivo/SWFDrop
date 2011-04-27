//
//  DisplayObject.h
//  SWFDrop
//
//  Created by Marcel Miranda on 4/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DisplayObject : NSObject {
@private
    
}


@property (nonatomic, retain) NSString *name;
@property (nonatomic) NSUInteger id;
@property (nonatomic) NSUInteger depth;

@property (nonatomic) CGPoint scale;
@property (nonatomic) CGPoint skew;
@property (nonatomic) CGPoint position;


@end
