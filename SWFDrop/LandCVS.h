//
//  LandCVS.h
//  SWFDrop
//
//  Created by Marcel Miranda on 4/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LandCVS : NSObject {
@private
    
}

+(BOOL) exportLand:(NSString*)landName withDisplayObjects: (NSArray *) displayObjects toDirectory:(NSString*) directory;

@end