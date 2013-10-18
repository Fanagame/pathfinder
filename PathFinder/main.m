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
		
		// Add walls
		[world addWall:CGPointMake(1, 0)];
		[world addWall:CGPointMake(7, 0)];
		[world addWall:CGPointMake(2, 1)];
		[world addWall:CGPointMake(7, 1)];
		[world addWall:CGPointMake(8, 1)];
		[world addWall:CGPointMake(3, 2)];
		[world addWall:CGPointMake(3, 3)];
		[world addWall:CGPointMake(3, 4)];
		[world addWall:CGPointMake(2, 0)];
		[world addWall:CGPointMake(3, 1)];
		
		// Add water
		[world setTerrainType:WorldTerrainType_Water atPosition:CGPointMake(7, 2)];
		[world setTerrainType:WorldTerrainType_Water atPosition:CGPointMake(7, 3)];
		[world setTerrainType:WorldTerrainType_Water atPosition:CGPointMake(7, 4)];
		
		// Print
		[world print];
		
		// Find our way through
		NSArray *path = [[PathFinder sharedInstance] pathInExplorableWorld:world fromA:world.heroPosition toB:world.destinationPosition usingDiagonal:YES];
		NSInteger totalCost = 0;
		for (PathNode *n in path)
			totalCost += n.overallScore;

		NSLog(@"Found a solution in %lu moves! (costs %i)", (unsigned long)path.count, (int)totalCost);
		[world printWithPath:path];
	}
    return 0;
}