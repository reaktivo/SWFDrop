//
//  SWFDropAppDelegate.m
//  SWFDrop
//
//  Created by Marcel Miranda on 4/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SWFDropAppDelegate.h"
#import "SWFDisplayExtractor.h"
#import "SWFTools.h"
#import "DLog.h"

@implementation SWFDropAppDelegate

@synthesize window;
@synthesize fileTextField, landNameTextField;
@synthesize swfFile, fileDropView;

@synthesize generateButton;

-(IBAction) generate:(id)sender {
	
	NSString* swfDump = [SWFTools swfDump:swfFile];
	
	DLog(@"swfDump: \n%@", swfDump);
	
	
	/*
	if (swfDump) {
				
		NSArray *displayObjects = [SWFDumpParser parseSWFDumpString:swfDump];
		
		SWFDisplayExtractor *displayExtractor = [[SWFDisplayExtractor alloc] initWithDisplayObjects:displayObjects];
		[displayExtractor generate];
		[displayExtractor release];
		
	}
	 */
	
	
}


/* Handle drag operations */

-(void) controlTextDidChange:(NSNotification *)obj {
	
}

-(void) swfFileUpdate {
	
	if(swfFile) {
		NSImage *image = [[NSWorkspace sharedWorkspace] iconForFileType:[swfFile pathExtension]];
		[image setSize:NSMakeSize(128, 128)];
				
		[fileDropView setImage:image];
		
		[fileTextField setStringValue:swfFile];
		
		[self.generateButton setEnabled: YES];
		
	}
	
}

- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender {
    NSPasteboard *pboard;
    
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
	
	self.fileTextField.delegate = self;
	
	[self.landNameTextField unregisterDraggedTypes];
	
}


@end
