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


-(id) parseDisplayObjectAttributes:(NSDictionary *) displayObject {
	
	NSMutableDictionary *parsedDisplayObject = [NSMutableDictionary new];
	
	// Set name
	[parsedDisplayObject setObject:[displayObject objectForKey:@"name"] forKey:@"name"];
	
	// Find position
	NSArray *matrixArray = [[displayObject objectForKey:@"matrix"] componentsSeparatedByString:@" "];
	CGPoint position;
	for (NSString *matrixComponent in matrixArray) {
		if ([matrixComponent hasPrefix:@"t"]) {
			NSArray *translationArray = [matrixComponent componentsSeparatedByString:@","];
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
	
	return parsedDisplayObject;
}


-(BOOL) parse {
	self.delegate = self;
	xmlPath = [[NSMutableArray alloc] init];
	stageDisplayObjects = [[NSMutableArray alloc] init];
	return [super parse];
}


- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName 
	attributes:(NSDictionary *)attributeDict {
	
	if([elementName isEqualToString:@"PlaceObject2"] && [[xmlPath lastObject] isEqualToString:@"swf"]) {		
				
		[stageDisplayObjects addObject:[self parseDisplayObjectAttributes:attributeDict]];
	}
	
	[xmlPath addObject:elementName];
	
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	
	[xmlPath removeLastObject];
	
}

-(void)parserDidEndDocument:(NSXMLParser *)parser {
	NSLog(@"stageDisplayObjects: %@", stageDisplayObjects);
	
	
}
		 
	

- (void)dealloc
{
    [super dealloc];
}

@end
