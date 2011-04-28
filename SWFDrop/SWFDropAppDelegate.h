//
//  SWFDropAppDelegate.h
//  SWFDrop
//
//  Created by Marcel Miranda on 4/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SWFDropAppDelegate : NSObject <NSApplicationDelegate, NSTextFieldDelegate> {
@private
	NSWindow *window;
	NSString *swfFile;
	NSTextField *fileTextField;
	NSImageView *fileDropView;
}

-(IBAction) generate:(id)sender;

@property (assign) IBOutlet NSWindow *window;
@property (nonatomic, retain) NSString *swfFile;
@property (nonatomic, retain) IBOutlet NSTextField *fileTextField;
@property (nonatomic, retain) IBOutlet NSImageView *fileDropView;

@end
