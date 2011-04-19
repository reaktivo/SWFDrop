//
//  SWFDumpParser.m
//  SWFDrop
//
//  Created by Marcel Miranda on 4/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SWFDumpParser.h"


@implementation SWFDumpParser

- (id)init {
    self = [super init];
    if (self) {
        self.delegate = self;
    }
    
    return self;
}

- (void)dealloc {
    [super dealloc];
}

@end
