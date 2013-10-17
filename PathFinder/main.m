//
//  main.m
//  PathFinder
//
//  Created by Rémy Bardou on 09/10/13.
//  Copyright (c) 2013 GREE International Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "World.h"
#import "PathFinder.h"

// [X,1,0,0,0,0,0,1,D,0]
// [0,0,1,0,0,0,0,1,1,0]
// [0,0,0,1,0,0,0,0,0,0]
// [0,0,0,1,0,0,0,0,0,0]
// [0,0,0,1,0,0,0,0,0,0]
// [0,0,0,0,0,0,0,0,0,0]
// [0,0,0,0,0,0,0,0,0,0]
// [0,0,0,0,0,0,0,0,0,0]
// [0,0,0,0,0,0,0,0,0,0]
// [0,0,0,0,0,0,0,0,0,0]

int main(int argc, const char * argv[])
{

	@autoreleasepool {
	    
	    // insert code here...
	    NSLog(@"Hello, World!");
	    
		World *world = [[World alloc] init];
		world.heroPosition = CGPointMake(0, 0);
		world.destinationPosition = CGPointMake(8, 0);
		
		[world addWall:CGPointMake(1, 0)];
		[world addWall:CGPointMake(7, 0)];
		[world addWall:CGPointMake(2, 1)];
		[world addWall:CGPointMake(7, 1)];
		[world addWall:CGPointMake(8, 1)];
		[world addWall:CGPointMake(3, 2)];
		[world addWall:CGPointMake(3, 3)];
		[world addWall:CGPointMake(3, 4)];
		[world print];
		
		NSMutableArray *path = [[PathFinder sharedInstance] pathInExplorableWorld:world fromA:world.heroPosition toB:world.destinationPosition];
		NSLog(@"Found a solution in %lu moves!", (unsigned long)path.count);
	}
    return 0;
}