//
//  DisplayObjectMatrix.m
//  SWFDrop
//
//  Created by Marcel Miranda on 4/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DisplayObjectMatrix.h"



@implementation DisplayObjectMatrix

@synthesize scale, skew, position;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

@end
