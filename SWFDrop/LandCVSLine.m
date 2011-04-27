//
//  LandCVSLine.m
//  SWFDrop
//
//  Created by Marcel Miranda on 4/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LandCVSLine.h"

const NSString *kFieldDefaultValue = @"0";
const NSString *kFieldValue1 = @"1";

const NSString *kEmptyValue = @"";

const NSString *kBackgroundType = @"background";
const NSString *kStructureType = @"structures";




@implementation LandCVSLine

@synthesize land, file, type, scaleX, scaleY, x, y, order, willCollide, link, isPortal, destination, reference, remove, defaultLand;

-(id) init {
	self = [super init];
	if(self) {
		self.land = (NSString *) kEmptyValue;
		self.file = (NSString *) kEmptyValue;
		self.type = (NSString *) kStructureType;
		
		self.scaleX = (NSString *) kFieldValue1;
		self.scaleY = (NSString *) kFieldValue1;
		
		self.x = (NSString *) kFieldDefaultValue;
		self.y = (NSString *) kFieldDefaultValue;
		
		self.order = (NSString *) kFieldDefaultValue;
		self.willCollide = (NSString *) kFieldDefaultValue;
		
		self.link = (NSString *) kEmptyValue;
		self.isPortal = (NSString *) kEmptyValue;
		self.destination = (NSString *) kEmptyValue;
		self.reference = (NSString *) kEmptyValue;
		self.remove = (NSString *) kEmptyValue;
		self.defaultLand = (NSString *) kEmptyValue;
		
	}
	
	return self;
}

-(NSString *)getCVS {
	return [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@", 
			self.land, self.file, self.type, 
			self.scaleX, self.scaleY,
			self.x, self.y,
			self.order, self.willCollide,
			self.link, self.isPortal, self.destination, self.reference,
			self.remove, self.defaultLand];
}


- (void)dealloc {
	
	self.land = nil;
	self.file = nil;
	self.type = nil;
	
	self.scaleX = nil;
	self.scaleY = nil;
	
	self.x = nil;
	self.y = nil;
	
	self.order = nil;
	self.willCollide = nil;
	
	self.link = nil;
	self.isPortal = nil;
	self.destination = nil;
	self.reference = nil;
	self.remove = nil;
	self.defaultLand = nil;
	
	
    [super dealloc];
}

@end
