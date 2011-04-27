//
//  SWFDropAppDelegate.m
//  SWFDrop
//
//  Created by Marcel Miranda on 4/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SWFDropAppDelegate.h"
#import "SWFTools.h"
#import "LandCVS.h"
#import "DLog.h"

@implementation SWFDropAppDelegate

@synthesize window;
@synthesize fileTextField;
@synthesize swfFile, fileDropView;

-(IBAction) generate:(id)sender {
	
	NSArray* swfDump = [SWFTools swfDump:swfFile];
	
	if (swfDump && [swfDump count] > 0) {
					
		NSString *dirPath = [swfFile stringByDeletingPathExtension];
		NSString *landName = [dirPath lastPathComponent];
		
		NSFileManager *fileManager= [NSFileManager defaultManager];
		if(![fileManager fileExistsAtPath:dirPath isDirectory:NULL])
			if(![fileManager createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:NULL])
				NSLog(@"Error: Create directory failed %@", dirPath);
		
		[SWFTools exportDisplayObjects:swfDump fromSWF:swfFile toDirectory:dirPath];
		[LandCVS exportLand:landName withDisplayObjects:swfDump toDirectory:dirPath];
		
		NSAlert *alert = [[[NSAlert alloc] init] autorelease];
		[alert addButtonWithTitle:@"OK"];
		[alert setMessageText:@"Finished"];
		[alert setInformativeText:@"Land has been generated successfully."];
		[alert setAlertStyle:NSWarningAlertStyle];
		
		[alert beginSheetModalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
		
	}
	
	
	
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
		[self generate:nil];
			
    }
    return YES;
}


-(void) applicationDidFinishLaunching:(NSNotification *)notification {
	
	[self.window registerForDraggedTypes:[NSArray arrayWithObjects: NSFilenamesPboardType, nil]];
	[self.fileDropView unregisterDraggedTypes];
	[self.fileTextField unregisterDraggedTypes];
	
	self.fileTextField.delegate = self;
	
}


@end
