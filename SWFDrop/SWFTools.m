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


#import "DisplayObjectMatrix.h"

static NSString *kSWFToolsPath = @"swftools/bin";

@implementation SWFTools

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
	
	//NSMutableArray *displayObjects = [NSMutableArray new];
	
	NSArray *swfDumpLines = [swfDump componentsSeparatedByRegex:lineStartRegExp];
	
	DLog(@"%@", swfDumpLines);
	
	NSUInteger swfDumpLinesCount = [swfDumpLines count];
	for (NSUInteger lineNum = 0; lineNum < swfDumpLinesCount; lineNum++) {
		
		NSString *line = [swfDumpLines objectAtIndex:lineNum];
		
		if ([line isMatchedByRegex:swfDumpLineRegExp]) {
			NSArray *components = [line arrayOfCaptureComponentsMatchedByRegex:swfDumpLineRegExp];
			DLog(@"components: %@", components);
			
			NSArray *matrixArray = [line componentsMatchedByRegex:matrixLineRegExp];
			
			DisplayObjectMatrix *matrix = [DisplayObjectMatrix new];
			matrix.scale = CGPointMake([[matrixArray objectAtIndex:0] floatValue], [[matrixArray objectAtIndex:4] floatValue]);
			matrix.skew = CGPointMake([[matrixArray objectAtIndex:1] floatValue], [[matrixArray objectAtIndex:3] floatValue]);
			matrix.position = CGPointMake([[matrixArray objectAtIndex:2] floatValue], [[matrixArray objectAtIndex:5] floatValue]);
			
			
			//NSArray *matrixLine1Components = [matrixLine1 componentsMatchedByRegex:matrixLineRegExp]; 
			//DLog(@"matrix: %@", matrixLine1Components);
			
			//DisplayObjectMatrix *matrix = [DisplayObjectMatrix new];
			
			
		}
		
	}
	
	
	return swfDumpLines;
	
	
}


+(id) swfDump:(NSString *) swfFile{
	
	NSString* swfDump = [SWFTools execute:@"swfdump" withArguments:[NSArray arrayWithObjects: @"-p", swfFile, nil]];
	
	if (swfDump) {
		
		return [SWFTools parseSwfDump: swfDump];
				
	}
	
	return nil;
	
}






@end
