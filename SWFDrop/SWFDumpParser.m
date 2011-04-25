//
//  SWFDumpParser.m
//  SWFDrop
//
//  Created by Marcel Miranda on 4/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SWFDumpParser.h"


@implementation SWFDumpParser

static const CGFloat kTranslationMultiplier = 20.00;
static const NSString* kTransposePrefix = @"t";

@synthesize stageDisplayObjects;

-(id) parseDisplayObjectAttributes:(NSDictionary *) displayObject {
	
	NSMutableDictionary *parsedDisplayObject = [NSMutableDictionary new];
	
	// Set name
	[parsedDisplayObject setObject:[displayObject objectForKey:@"name"] forKey:@"name"];
	
	// Find position
	NSArray *matrixArray = [[displayObject objectForKey:@"matrix"] componentsSeparatedByString:@" "];
	CGPoint position;
	for (NSString *matrixComponent in matrixArray) {
		if ([matrixComponent hasPrefix:(NSString *)kTransposePrefix]) {
			NSArray *translationArray = [[matrixComponent substringFromIndex: [kTransposePrefix length]] componentsSeparatedByString:@","];
			position = CGPointMake(
								   [[translationArray objectAtIndex:0] floatValue],  //x 
								   [[translationArray objectAtIndex:1] floatValue]); //y
			position.x = position.x / kTranslationMultiplier;
			position.y = position.y / kTranslationMultiplier;
			
			break;
		}
	}
	
	// Set position
	[parsedDisplayObject setObject: [NSValue valueWithPoint:position]  forKey:@"position"];
	
	return [parsedDisplayObject autorelease];
}

+(id) parseSWFDumpString:(NSString *) swfDumpString {

	SWFDumpParser *parser = [[SWFDumpParser alloc] initWithData: [swfDumpString dataUsingEncoding:NSUTF8StringEncoding]];
	
	[parser parse];
	
	NSArray *result = parser.stageDisplayObjects;
	
	[parser autorelease];
	
	return result;
	
}

-(BOOL) parse {
	self.delegate = self;
	xmlPath = [[NSMutableArray alloc] init];
	self.stageDisplayObjects = [[NSMutableArray alloc] init];
	return [super parse];
}


- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName 
	attributes:(NSDictionary *)attributeDict {
	
	if([elementName isEqualToString:@"PlaceObject2"] && [[xmlPath lastObject] isEqualToString:@"swf"]) {		
				
		[self.stageDisplayObjects addObject:[self parseDisplayObjectAttributes:attributeDict]];
	}
	
	[xmlPath addObject:elementName];
	
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	
	[xmlPath removeLastObject];
	
}	

- (void)dealloc {
	
	
	[xmlPath release];
	[self.stageDisplayObjects release];
	self.stageDisplayObjects = nil;
    [super dealloc];
}

@end
