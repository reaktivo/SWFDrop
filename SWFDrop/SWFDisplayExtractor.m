//
//  SWFDisplayExtractor.m
//  SWFDrop
//
//  Created by Marcel Miranda on 4/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SWFDisplayExtractor.h"
#import "SWFTools.h"
#import "DLog.h"


@implementation SWFDisplayExtractor

@synthesize displayObjects, targetFolder;

- (id)initWithDisplayObjects:(NSArray*) objects {
    
    if ( (self = [super init]) ) {
		
		self.displayObjects = objects;
		
		self.targetFolder = [@"~/Desktop/testExport" stringByExpandingTildeInPath];
		
		
    }
    
    return self;
}

-(void) generate {
	
	DLog(@"objects: %@", self.displayObjects);
	
	if (self.targetFolder != nil || YES) {
		
		DLog(@"generate Display Extractor");
		
		for (id displayObjectDict in self.displayObjects) {
			
			DLog(@"displayObject: %@", displayObjectDict);
			
			NSString *displayObjectName = [displayObjectDict objectForKey:@"name"];
			NSString *displayObjectTargetFile = [displayObjectName stringByAppendingPathExtension:@"swf"];
			
			NSArray *arguments = [NSArray arrayWithObjects:@"-n", displayObjectName, displayObjectTargetFile, nil];
			
			NSString *result = [SWFTools execute:@"swfextract" withArguments: arguments];
			
			DLog(@"%@", result);
			
		}
	}
	
}

-(void)dealloc {
	
	self.displayObjects = nil;
	self.targetFolder = nil;
	
    [super dealloc];
}

@end
