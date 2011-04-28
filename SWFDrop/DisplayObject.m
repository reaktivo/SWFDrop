//
//  DisplayObject.m
//  SWFDrop
//
//  Created by Marcel Miranda on 4/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DisplayObject.h"



@implementation DisplayObject

@synthesize name, id, depth, scale, skew, position;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(NSString *) description {
		
	return [NSString stringWithFormat:@"%@ name: %@", 
				[super description],
				self.name]; 
	
}


- (void)dealloc {
	
	self.name = nil;
	
	
    [super dealloc];
}

@end
