//
//  World.m
//  PathFinder
//
//  Created by Rémy Bardou on 09/10/13.
//  Copyright (c) 2013 GREE International Inc. All rights reserved.
//

#import "World.h"

@implementation World

- (id) init {
	self = [super init];
	
	if (self) {
		self.worldMap = [[NSMutableArray alloc] init];
		
		[self resetContent];
	}
	
	return self;
}

- (void) resetContent {
	[self.worldMap removeAllObjects];
	
	// init content
	for (int i = 0; i < 10; i++) {
		NSMutableArray *columns = [[NSMutableArray alloc] init];
		
		for (int j = 0; j < 10; j++) {
			[columns addObject:[NSNumber numberWithBool:NO]];
		}
		
		[self.worldMap addObject:columns];
	}
}

- (void) addWall:(CGPoint)wallPosition {
	if (self.worldMap.count > wallPosition.y) {
		if ([[self.worldMap objectAtIndex:wallPosition.y] count] > wallPosition.y) {
			[[self.worldMap objectAtIndex:wallPosition.y] setObject:[NSNumber numberWithBool:YES] atIndex:wallPosition.x];
		}
	}
}

#pragma mark - Bullshit de protocol 

- (NSArray *) worldGridArray {
	return self.worldMap;
}

- (void) print {
	for (int i = 0; i < self.worldMap.count; i++) {
		NSMutableArray *columns = self.worldMap[i];
		
		NSMutableString *buffer = [[NSMutableString alloc] init];
		[buffer appendString:@"["];
		
		for (int j = 0; j < columns.count; j++) {
			NSNumber *col = columns[j];
			
			if (j > 0)
				[buffer appendString:@","];
			
			if (i == self.heroPosition.y && j == self.heroPosition.x)
				[buffer appendString:@"X"];
			else if (i == self.destinationPosition.y && j == self.destinationPosition.x)
				[buffer appendString:@"D"];
			else
				[buffer appendString:([col boolValue] ? @"1" : @"0")];
		}
		
		[buffer appendString:@"]"];
		
		NSLog(@"%@", buffer);
	}
}

#pragma mark - Path finding

//- (NSUInteger) heuristicCostEstimateBetweenPointA:(CGPoint)pointA andPointB:(CGPoint)pointB {
//	return abs(pointA.x - pointB.x) + abs(pointA.y - pointB.y);
//}
//
//- (NSMutableArray *)reconstructPath:(NSMutableArray *)path to:(CGPoint)destination {
//	return path;
//}
//
//- (void) removeNode:(CGPoint)point fromSet:(NSMutableSet **)set {
//	for (NSValue *val in *set) {
//		if (CGPointEqualToPoint(val.pointValue, point)) {
//			[*set removeObject:val];
//			break;
//		}
//	}
//}
//
//- (NSSet *) neighborsForPoint:(CGPoint)point {
//	NSMutableSet *set = [[NSMutableSet alloc] init];
//	
//	if (point.x > 0) {
//		if (point.y > 0)
//			[set addObject:[NSValue valueWithPoint:CGPointMake(point.x - 1, point.y - 1)]];
//		[set addObject:[NSValue valueWithPoint:CGPointMake(point.x - 1, point.y)]];
//	}
//	
//	//TODO: finish writing this
//	
//	return set;
//}
//
//- (CGPoint) nodeWithLowestScoreInSet:(NSSet *)set {
//	return CGPointMake(0, 0);
//}
//
- (NSMutableArray *)pathToDestination {
	NSMutableArray *path = [[NSMutableArray alloc] init];
//
//	NSMutableSet *closedSet = [[NSMutableSet alloc] init];
//	NSMutableSet *openedSet = [[NSMutableSet alloc] init];
//	[openedSet addObject:[NSValue valueWithPoint:self.heroPosition]];
//	
////	gScore[start] = 0;
////	fScore[start] = gScore[start] + [self heuristicCostEstimateBetweenPointA:self.heroPosition andPointB:self.destinationPosition];
//	
////	NSLog(@"%d", [self heuristicCostEstimateBetweenPointA:self.heroPosition andPointB:self.destinationPosition]);
//	
//	CGPoint currentNode = CGPointZero;
//	while (openedSet.count > 0) {
////		currentNode = [self nodeWithLowestScoreInSet:openedSet];
//		
//		if (CGPointEqualToPoint(currentNode, self.destinationPosition))
//			return [self reconstructPath:path to:self.destinationPosition];
//		
//		[self removeNode:currentNode fromSet:&openedSet];
//		[closedSet addObject:[NSValue valueWithPoint:currentNode]];
//		
//		for (NSValue *neighbor in [self neighborsForPoint:currentNode]) {
//			
//		}
//	}
//	
	return path;
}

@end
