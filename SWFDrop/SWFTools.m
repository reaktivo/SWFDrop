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

static NSString *kSWFToolsInstallCommand = @"curl -L http://goo.gl/5cToM | sh";
static NSString *kSWFToolsPath = @"/usr/local/bin";
static NSString *kSWFToolsExistancePath = @"/usr/local/share/swftools";

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

+(BOOL) isSWFToolsInstall {
	
	//If SWFTools is not installed, ask to install or exit
	
	if ([[NSFileManager defaultManager] fileExistsAtPath:kSWFToolsExistancePath isDirectory:nil] == NO) {
		
		NSAlert *alert = [NSAlert alertWithMessageText:@"SWFTools is not installed" defaultButton:nil alternateButton:nil otherButton:nil informativeTextWithFormat:@"SWFTools is not installed, to install copy, paste and run the following script as sudo:\n\n%@", kSWFToolsInstallCommand];
		
		[alert beginSheetModalForWindow:[[NSApp orderedWindows] objectAtIndex:0] modalDelegate:nil didEndSelector:nil contextInfo:nil];
		
		return NO;
		
	}else{
		return YES;
	}
	
	
}


+(id) execute:(NSString*)executable withArguments:(NSArray*) arguments {
	
	DLog(@"%@, %@", executable, arguments);
	
	if (![self isSWFToolsInstall]) {
		return nil;
	}
	
	NSTask *task = [[NSTask alloc] init];
	
	task.launchPath = [kSWFToolsPath stringByAppendingPathComponent:executable];

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
	
	DLog(@"start");
	
	static NSString *lineStartRegExp = @"\\[[a-zA-Z0-9]+\\]\\s+";
	static NSString *swfDumpLineRegExp = @"[0-9]+ PLACEOBJECT2 places id ([0-9]+) at depth ([0-9]+) name \\\"(.+)\\\"";
	static NSString *matrixLineRegExp = @"-?[0-9]+\\.[0-9]+";
	
	NSMutableArray *displayObjects = [[NSMutableArray new] autorelease];
	
	NSArray *swfDumpLines = [swfDump componentsSeparatedByRegex:lineStartRegExp];
	
	NSUInteger swfDumpLinesCount = [swfDumpLines count];
	
	DLog(@"swfDumpLinesCount: %i", (int) swfDumpLinesCount);
	
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
			
			DLog(@"displayObject created: %@", displayObject);
			
			[displayObject release];
			
		}
		
	}
	
	
	return displayObjects;
	
	
}


+(id) swfDump:(NSString *) swfFile{
	
	DLog(@"start");
	
	NSString* swfDump = [SWFTools execute:@"swfdump" withArguments:[NSArray arrayWithObjects: @"-p", swfFile, nil]];
	
	if (swfDump) {
		
		DLog(@"success");
		
		return [SWFTools parseSwfDump: swfDump];
				
	}
	
	DLog(@"fail");
	
	return nil;
	
}


+(BOOL) exportDisplayObjects: (NSArray *) displayObjects fromSWF: (NSString*) swfFile toDirectory:(NSString*) directory {
	
	DLog(@"start");
	
	NSString *structuresDir = [directory stringByAppendingPathComponent:kStructuresPath];
	
	NSFileManager *fileManager= [NSFileManager defaultManager];
	if(![fileManager fileExistsAtPath:structuresDir isDirectory:NULL] && 
	   ![fileManager createDirectoryAtPath:structuresDir withIntermediateDirectories:YES attributes:nil error:NULL]) {
		DLog(@"Error: Create directory failed %@", structuresDir);
	}
			
	
	for (DisplayObject *displayObject in displayObjects) {
				
		NSString *displayObjectTargetFile = [[structuresDir stringByAppendingPathComponent:displayObject.name] stringByAppendingPathExtension:@"swf"];
		NSArray *arguments = [NSArray arrayWithObjects:@"-n", displayObject.name, @"-o", displayObjectTargetFile, swfFile, nil];
		[SWFTools execute:@"swfextract" withArguments:arguments];
		
	}
	
	return YES;
	
}




@end
