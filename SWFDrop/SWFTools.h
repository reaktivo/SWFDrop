//
//  SWFTools.h
//  SWFDrop
//
//  Created by Marcel Miranda on 4/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SWFTools : NSObject {
@private
    
}

+(id) execute:(NSString*)executable withArguments:(NSArray*) arguments;
+(id) swfDump:(NSString *) swfFile;

@end
