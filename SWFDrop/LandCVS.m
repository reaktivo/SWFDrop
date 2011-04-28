//
//  LandCVS.m
//  SWFDrop
//
//  Created by Marcel Miranda on 4/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LandCVS.h"
#import "LandCVSLine.h"

#import "DisplayObject.h"



@implementation LandCVS


- (id)init {
    self = [super init];
    if (self) {
    }
    
    return self;
}

- (void)dealloc {
    [super dealloc];
}

+(BOOL) exportLand:(NSString*)landName withDisplayObjects: (NSArray *) displayObjects toDirectory:(NSString*) directory {
	
	static NSArray *fields;
	if(fields == nil) {
		fields = [NSArray arrayWithObjects: @"Land", @"File", @"Type", @"Scale X", @"Scale Y", @"X", @"Y", @"Order", @"Will Collide", @"Link", @"Is Portal", @"Destination", @"Reference", @"Remove", @"Default Land", nil];
	}
	
	// Set header line
	NSMutableArray *csvLines = [NSMutableArray new];
	[csvLines addObject:[fields componentsJoinedByString:@","]];
	
	LandCVSLine *backgroundCVS = [LandCVSLine new];
	backgroundCVS.land = landName;
	backgroundCVS.type = (NSString*) kBackgroundType;
	backgroundCVS.file = @"container.swf";
	
	[csvLines addObject: [backgroundCVS getCVS]];
	[backgroundCVS release];
	
	
	for (DisplayObject *displayObject in displayObjects) {
		
		LandCVSLine *displayObjectCVS = [LandCVSLine new];
		displayObjectCVS.land = landName;
		displayObjectCVS.file = [displayObject.name stringByAppendingPathExtension:@"swf"];
		displayObjectCVS.x = [NSString stringWithFormat: @"%.2f", displayObject.position.x];
		displayObjectCVS.y = [NSString stringWithFormat: @"%.2f", displayObject.position.y];
		displayObjectCVS.order = [NSString stringWithFormat: @"%i", (NSUInteger)displayObject.depth];
		
		[csvLines addObject: [displayObjectCVS getCVS]];
		[displayObjectCVS release];
							 
		
	}
	
	NSString* landFilename = [directory stringByAppendingPathComponent: [landName stringByAppendingPathExtension:@"csv"]];
	
	[[csvLines componentsJoinedByString:@"\n"] writeToFile:landFilename atomically:YES encoding:NSUTF8StringEncoding error:NULL];
	
	[csvLines release];
	
	return YES;
}




@end










