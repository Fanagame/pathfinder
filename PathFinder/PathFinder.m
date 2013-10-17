//
//  PathFinder.m
//  PathFinder
//
//  Created by Rémy Bardou on 16/10/13.
//  Copyright (c) 2013 GREE International Inc. All rights reserved.
//

#import "PathFinder.h"

@implementation PathNode

- (id)initWithPosition:(CGPoint)position {
	self = [super init];
	
	if (self) {
		self.position = position;
	}
	
	return self;
}

- (NSInteger)fScore {
	return self.gScore + self.hScore;
}

@end

@implementation PathFinder

+ (instancetype) sharedInstance {
	static PathFinder *instance = nil;
	
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		instance = [[PathFinder alloc] init];
	});
	
	return instance;
}

#pragma mark - Public API

- (NSMutableArray *)pathInExplorableWorld:(id<WorldExplorationProtocol>)world fromA:(CGPoint)pointA toB:(CGPoint)pointB {
	
	NSMutableArray *path = [[NSMutableArray alloc] init];
	
	NSMutableSet *openedSet = [[NSMutableSet alloc] init];
	NSMutableSet *closedSet = [[NSMutableSet alloc] init];
	
	/*
	 * 1. Find node closest to your position and declare it start node and put it on
	 *	  the open list.
	 */
	PathNode *startNode = [[PathNode alloc] initWithPosition:pointA];
	startNode.hScore = [self manhattanDistanceBetweenA:startNode.position andB:pointB];
	[openedSet addObject:startNode];
	
	
	/*
	 * 2. While there are nodes in the open list:
	 */
	PathNode *currentNode = nil;
	while (openedSet.count > 0) {
		
		/*
		 * 3. Pick the node from the open list having the smallest F score. Put it on
		 *    the closed list (you don't want to consider it again).
		 */
		currentNode = [self nodeWithSmallestFScoreInSet:openedSet];
		
		if (CGPointEqualToPoint(currentNode.position, pointB)) {
			break; // return the path
		}
		
		[openedSet removeObject:currentNode];
		[closedSet addObject:currentNode];
		
		/*
		 * 4. For each neighbor (adjacent cell) which isn't in the closed list:
		 */
		for (PathNode *neighbor in [self neighborsForNode:currentNode inWorldGrid:[world worldGridArray]]) {
			if (![self isNode:neighbor inSet:closedSet]) {
				NSLog(@"Evaluating new neighbor: %f,%f", neighbor.position.x, neighbor.position.y);
				
				/*
				 * 5. Set its parent to current node.
				 */
				neighbor.parent = currentNode;
				
				/*
				 * 6. Calculate G score (distance from starting node to this neighbor) and
				 * add it to the open list
				 */
				neighbor.gScore = neighbor.parent.gScore + 1;
				[openedSet addObject:neighbor];
				
				/*
				 * 7. Calculate F score by adding heuristics to the G value.
				 */
				neighbor.hScore = [self manhattanDistanceBetweenA:neighbor.position andB:pointB];
			}
		}
	}
	
	// We got ourselves a path!
	return path;
}

#pragma mark - Private API

- (BOOL) isNode:(PathNode *)node inSet:(NSSet *)set {
	BOOL found = NO;
	
	for (PathNode *n in set) {
		if (CGPointEqualToPoint(n.position, node.position)) {
			found = YES;
			break;
		}
	}
	
	return found;
}

- (NSInteger) manhattanDistanceBetweenA:(CGPoint)pointA andB:(CGPoint)pointB {
	return abs(pointB.x - pointA.x) + abs(pointB.y - pointB.y);
}

- (PathNode *) nodeWithSmallestFScoreInSet:(NSSet *)set {
	PathNode *candidate = nil;
	
	for (PathNode *node in set) {
		if (!candidate || node.fScore < candidate.fScore) {
			candidate = node;
		}
	}
	
	return candidate;
}

- (NSSet *) neighborsForNode:(PathNode *)rootNode inWorldGrid:(NSArray *)world {
	NSMutableSet *neighbors = [[NSMutableSet alloc] init];
	
	NSLog(@"Looking for neighbors of (%f,%f)", rootNode.position.x, rootNode.position.y);
	
	if (rootNode.position.x > 0 && rootNode.position.y > 0)
		[neighbors addObject:[[PathNode alloc] initWithPosition:CGPointMake(rootNode.position.x - 1, rootNode.position.y - 1)]];
	if (rootNode.position.y > 0)
		[neighbors addObject:[[PathNode alloc] initWithPosition:CGPointMake(rootNode.position.x, rootNode.position.y - 1)]];
	if (rootNode.position.x + 1 < [world[(int)rootNode.position.y] count] && rootNode.position.y > 0)
		[neighbors addObject:[[PathNode alloc] initWithPosition:CGPointMake(rootNode.position.x + 1, rootNode.position.y - 1)]];
	
	if (rootNode.position.x > 0)
		[neighbors addObject:[[PathNode alloc] initWithPosition:CGPointMake(rootNode.position.x - 1	, rootNode.position.y)]];
	if (rootNode.position.x + 1 < [world[(int)rootNode.position.y] count])
		[neighbors addObject:[[PathNode alloc] initWithPosition:CGPointMake(rootNode.position.x + 1	, rootNode.position.y)]];
	
	if (rootNode.position.x + 1 < [world[(int)rootNode.position.y] count] && rootNode.position.y + 1 < world.count)
		[neighbors addObject:[[PathNode alloc] initWithPosition:CGPointMake(rootNode.position.x + 1	, rootNode.position.y + 1)]];
	if (rootNode.position.y + 1 < world.count)
		[neighbors addObject:[[PathNode alloc] initWithPosition:CGPointMake(rootNode.position.x		, rootNode.position.y + 1)]];
	if (rootNode.position.x > 0 && rootNode.position.y + 1 < world.count)
		[neighbors addObject:[[PathNode alloc] initWithPosition:CGPointMake(rootNode.position.x - 1	, rootNode.position.y + 1)]];
	
	return neighbors;
}

@end
