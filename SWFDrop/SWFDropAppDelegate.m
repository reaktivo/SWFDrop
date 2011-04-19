//
//  SWFDropAppDelegate.m
//  SWFDrop
//
//  Created by Marcel Miranda on 4/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SWFDropAppDelegate.h"
#import "SWFDumpParser.h"

@implementation SWFDropAppDelegate

static NSString *kFlexSDKBinDirectory = @"FlexSDK/bin";

@synthesize 
	window,
	landNameTextField,
	fileTextField,
	swfFile,
	fileDropView;

-(id) executeFlexBin:(NSString*)executable withArguments:(NSArray*) arguments {
	
	NSTask *task;
	task = [[NSTask alloc] init];
	task.launchPath = [[NSBundle mainBundle] pathForResource:executable ofType:nil inDirectory:kFlexSDKBinDirectory];
	task.arguments = arguments;
	
	NSPipe *pipe = [NSPipe pipe];
	[task setStandardOutput: pipe];
	[task setStandardInput:[NSPipe pipe]];
	
	NSFileHandle *file = [pipe fileHandleForReading];
	
	[task launch];
	
	NSData *data = [file readDataToEndOfFile];
	
	NSString *dataString = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
	
	[task release];
	
	return [dataString autorelease];
}

-(IBAction) generate:(id)sender {
	
	NSString* swfDump = [self executeFlexBin:@"swfdump" withArguments:[NSArray arrayWithObject: swfFile]];
	
	SWFDumpParser *swfDumpParser = [[SWFDumpParser alloc] initWithData:[swfDump dataUsingEncoding:NSUTF8StringEncoding]];
	
	



/* Handle drag operations */

-(void) swfFileUpdate {
	
	if(swfFile) {
		NSImage *image = [[[NSWorkspace sharedWorkspace] iconForFileType:[swfFile pathExtension]] retain];
		[image setSize:NSMakeSize(128, 128)];
				
		[fileDropView setImage:image];
		
		[fileTextField setStringValue:swfFile];
	}
	
}

- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender {
    NSPasteboard *pboard;
    NSDragOperation sourceDragMask;
	
    sourceDragMask = [sender draggingSourceOperationMask];
    pboard = [sender draggingPasteboard];
	
    if ( [[pboard types] containsObject:NSFilenamesPboardType] ) {
		
		NSArray *files = [pboard propertyListForType:NSFilenamesPboardType];
		
		NSString *filename = [files objectAtIndex:0];
		if ([[filename pathExtension] isEqualToString:@"swf"]) {
			return NSDragOperationCopy;
		}
		
    }
	
    return NSDragOperationNone;
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender {
    NSPasteboard *pboard;
    NSDragOperation sourceDragMask;
	
    sourceDragMask = [sender draggingSourceOperationMask];
    pboard = [sender draggingPasteboard];
	
    if ( [[pboard types] containsObject:NSFilenamesPboardType] ) {
        NSArray *files = [pboard propertyListForType:NSFilenamesPboardType];
		
		NSString *filename = [files objectAtIndex:0];
		
		self.swfFile = filename;
		
		[self swfFileUpdate];
			
    }
    return YES;
}


-(void) applicationDidFinishLaunching:(NSNotification *)notification {
	
	[self.window registerForDraggedTypes:[NSArray arrayWithObjects: NSFilenamesPboardType, nil]];
	[self.fileDropView unregisterDraggedTypes];
	[self.fileTextField unregisterDraggedTypes];
	[self.landNameTextField unregisterDraggedTypes];
	
}


@end
