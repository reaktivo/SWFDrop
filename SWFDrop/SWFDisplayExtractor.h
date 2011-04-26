//
//  SWFDisplayExtractor.h
//  SWFDrop
//
//  Created by Marcel Miranda on 4/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SWFDisplayExtractor : NSObject {
@private
    
}



@property (nonatomic, retain) NSArray *displayObjects;

@property (nonatomic, retain) NSString *targetFolder;




-(id)initWithDisplayObjects:(NSArray*) objects;
-(void)generate;


@end
