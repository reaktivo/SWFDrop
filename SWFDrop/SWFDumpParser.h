//
//  SWFDumpParser.h
//  SWFDrop
//
//  Created by Marcel Miranda on 4/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SWFDumpParser : NSXMLParser <NSXMLParserDelegate> {
@private
	
	NSMutableArray *xmlPath;
	
	
}

@property (nonatomic, retain) NSMutableArray *stageDisplayObjects;


+(id) parseSWFDumpString:(NSString *) swfDumpString;


@end
