//
//  SWFTools.m
//  SWFDrop
//
//  Created by Marcel Miranda on 4/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SWFTools.h"
#import "DLog.h"
#import "RegexKitLite.h"

#import "DisplayObject.h"


@implementation SWFTools


static NSString *kSWFToolsPath = @"swftools/bin";
static NSString *kStructuresPath = @"structures";

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


+(id) execute:(NSString*)executable withArguments:(NSArray*) arguments {
	
	NSTask *task = [[NSTask alloc] init];
	
	task.launchPath = [[NSBundle mainBundle] pathForResource:executable ofType:nil inDirectory:kSWFToolsPath];

	[task setArguments: arguments];
	NSPipe *pipe = [NSPipe pipe];
	[task setStandardOutput: pipe];
	[task setStandardInput:[NSPipe pipe]];
	NSFileHandle *file = [pipe fileHandleForReading];
	
	[task launch];
	[task release];
	
	NSData *data = [file readDataToEndOfFile];
	NSString *dataString = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
	
	return [dataString autorelease];
}

+(id) parseSwfDump:(NSString*) swfDump {
	
	static NSString *lineStartRegExp = @"\\[[a-zA-Z0-9]+\\]\\s+";
	static NSString *swfDumpLineRegExp = @"[0-9]+ PLACEOBJECT2 places id ([0-9]+) at depth ([0-9]+) name \\\"(.+)\\\"";
	static NSString *matrixLineRegExp = @"-?[0-9]+\\.[0-9]+";
	
	NSMutableArray *displayObjects = [NSMutableArray new];
	
	NSArray *swfDumpLines = [swfDump componentsSeparatedByRegex:lineStartRegExp];
	
	NSUInteger swfDumpLinesCount = [swfDumpLines count];
	for (NSUInteger lineNum = 0; lineNum < swfDumpLinesCount; lineNum++) {
		
		NSString *line = [swfDumpLines objectAtIndex:lineNum];
		
		if ([line isMatchedByRegex:swfDumpLineRegExp]) {
			
			DisplayObject *displayObject = [DisplayObject new];
			
			NSArray *components = [[line arrayOfCaptureComponentsMatchedByRegex:swfDumpLineRegExp] objectAtIndex:0];
			
			displayObject.name = [components objectAtIndex:3];
			displayObject.id = [[components objectAtIndex:1] integerValue];
			displayObject.depth = [[components objectAtIndex:2] integerValue];
			
			NSArray *matrixArray = [line componentsMatchedByRegex:matrixLineRegExp];
			
			displayObject.scale = CGPointMake([[matrixArray objectAtIndex:0] floatValue], [[matrixArray objectAtIndex:4] floatValue]);
			displayObject.skew = CGPointMake([[matrixArray objectAtIndex:1] floatValue], [[matrixArray objectAtIndex:3] floatValue]);
			displayObject.position = CGPointMake([[matrixArray objectAtIndex:2] floatValue], [[matrixArray objectAtIndex:5] floatValue]);
			
			[displayObjects addObject:displayObject];
			
		}
		
	}
	
	
	return displayObjects;
	
	
}


+(id) swfDump:(NSString *) swfFile{
	
	NSString* swfDump = [SWFTools execute:@"swfdump" withArguments:[NSArray arrayWithObjects: @"-p", swfFile, nil]];
	
	if (swfDump) {
		
		return [SWFTools parseSwfDump: swfDump];
				
	}
	
	return nil;
	
}


+(BOOL) exportDisplayObjects: (NSArray *) displayObjects fromSWF: (NSString*) swfFile toDirectory:(NSString*) directory {
	
	NSString *structuresDir = [directory stringByAppendingPathComponent:kStructuresPath];
	
	NSFileManager *fileManager= [NSFileManager defaultManager];
	if(![fileManager fileExistsAtPath:structuresDir isDirectory:NULL])
		if(![fileManager createDirectoryAtPath:structuresDir withIntermediateDirectories:YES attributes:nil error:NULL])
			NSLog(@"Error: Create directory failed %@", structuresDir);
	
	for (DisplayObject *displayObject in displayObjects) {
				
		NSString *displayObjectTargetFile = [[structuresDir stringByAppendingPathComponent:displayObject.name] stringByAppendingPathExtension:@"swf"];
		NSArray *arguments = [NSArray arrayWithObjects:@"-n", displayObject.name, @"-o", displayObjectTargetFile, swfFile, nil];
		[SWFTools execute:@"swfextract" withArguments:arguments];
		
	}
	
	return YES;
	
}




@end
