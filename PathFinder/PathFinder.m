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

- (NSMutableArray *)pathInExplorableWorld:(id<WorldExplorationProtocol>)world fromA:(CGPoint)pointA toB:(CGPoint)pointB usingDiagonal:(BOOL)useDiagonal {
	
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
		NSLog(@"******************************");
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
		for (PathNode *neighbor in [self neighborsForNode:currentNode inExplorableWorld:world]) {
			if (![self isNode:neighbor inSet:closedSet]) {
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
                [closedSet addObject:neighbor];
				
				/*
				 * 7. Calculate F score by adding heuristics to the G value.
				 */
				neighbor.hScore = [self manhattanDistanceBetweenA:neighbor.position andB:pointB];
                
                
                NSLog(@"Evaluating new neighbor: %f,%f with scores: G %i, H %i, F %i", neighbor.position.x, neighbor.position.y, (int)neighbor.gScore, (int)neighbor.hScore, (int)neighbor.fScore);
			}
		}
        
        // next open node
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

- (NSSet *) neighborsForNode:(PathNode *)rootNode inExplorableWorld:(id<WorldExplorationProtocol>)world usingDiagonal:(BOOL)usingDiagonal {
	NSMutableSet *neighbors = [[NSMutableSet alloc] init];
	
    if ([world respondsToSelector:@selector(isWalkable:)]) {
        NSLog(@"Looking for neighbors of (%f,%f)", rootNode.position.x, rootNode.position.y);
        
        CGPoint position = CGPointZero;
        
        if (usingDiagonal) {
            position = CGPointMake(rootNode.position.x - 1, rootNode.position.y - 1);
            if ([world isWalkable:position])
                [neighbors addObject:[[PathNode alloc] initWithPosition:position]];
        }
        
        position = CGPointMake(rootNode.position.x, rootNode.position.y - 1);
        if ([world isWalkable:position])
            [neighbors addObject:[[PathNode alloc] initWithPosition:position]];
        
        if (usingDiagonal) {
            position = CGPointMake(rootNode.position.x + 1, rootNode.position.y - 1);
            if ([world isWalkable:position])
                [neighbors addObject:[[PathNode alloc] initWithPosition:position]];
        }
        
        position = CGPointMake(rootNode.position.x - 1, rootNode.position.y);
        if ([world isWalkable:position])
            [neighbors addObject:[[PathNode alloc] initWithPosition:position]];
        
        position = CGPointMake(rootNode.position.x + 1, rootNode.position.y);
        if ([world isWalkable:position])
            [neighbors addObject:[[PathNode alloc] initWithPosition:position]];
        
        position = CGPointMake(rootNode.position.x + 1, rootNode.position.y + 1);
        if ([world isWalkable:position])
            [neighbors addObject:[[PathNode alloc] initWithPosition:position]];
        
        position = CGPointMake(rootNode.position.x, rootNode.position.y + 1);
        if ([world isWalkable:position])
            [neighbors addObject:[[PathNode alloc] initWithPosition:position]];
        
        position = CGPointMake(rootNode.position.x - 1, rootNode.position.y + 1);
        if ([world isWalkable:position])
            [neighbors addObject:[[PathNode alloc] initWithPosition:position]];
    }
	
	return neighbors;
}

@end
