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
		
		for (int j = 0; j < 10; j++)
			[columns addObject:[NSNumber numberWithUnsignedInteger:WorldTerrainType_Default]];
		
		[self.worldMap addObject:columns];
	}
}

- (void) addWall:(CGPoint)wallPosition {
	[self setTerrainType:WorldTerrainType_Wall atPosition:wallPosition];
}

- (void) setTerrainType:(WorldTerrainType)type atPosition:(CGPoint)position {
	if (position.y >= 0 && self.worldMap.count - 1 > position.y) {
		if (position.x >= 0 && [self.worldMap[(int)position.y] count] - 1 > position.y) {
			self.worldMap[(int)position.y][(int)position.x] = [NSNumber numberWithUnsignedInteger:type];
		}
	}
}

#pragma mark - PathFinder protocol 

- (BOOL) isWalkable:(CGPoint)position {
    if (position.x < 0 || position.y < 0) // out of bounds
        return NO;
    
    if (position.y > self.worldMap.count - 1) // out of bounds
        return NO;
    
    if (position.x > [self.worldMap[(int)position.y] count] - 1) // out of bounds
        return NO;
    
    if ([self.worldMap[(int)position.y][(int)position.x] unsignedIntegerValue] == WorldTerrainType_Wall) // wall
        return NO;
    
    return YES;
}

- (NSUInteger) weightForTileAtPosition:(CGPoint)position {
	if (position.y >= 0 && self.worldMap.count - 1 > position.y) {
		if (position.x >= 0 && [self.worldMap[(int)position.y] count] - 1 > position.x) {
			return [self.worldMap[(int)position.y][(int)position.x] unsignedIntegerValue];
		}
	}
	
	return WorldTerrainType_Default;
}


#pragma mark - Debug functions

- (void) print {
	[self printWithPath:nil];
}

- (void) printWithPath:(NSArray *)path {
	for (int i = 0; i < self.worldMap.count; i++) {
		NSMutableArray *columns = self.worldMap[i];
		
		NSMutableString *buffer = [[NSMutableString alloc] init];
		[buffer appendString:@"["];
		
		for (int j = 0; j < columns.count; j++) {
			NSNumber *col = columns[j];
			
			if (j > 0)
				[buffer appendString:@","];
			
			if ([self isPosition:CGPointMake(j, i) partOfThePath:path])
				[buffer appendString:@"-"];
			else if (i == self.heroPosition.y && j == self.heroPosition.x)
				[buffer appendString:@"X"];
			else if (i == self.destinationPosition.y && j == self.destinationPosition.x)
				[buffer appendString:@"D"];
			else {
				switch (col.unsignedIntegerValue) {
					case WorldTerrainType_Wall:
						[buffer appendString:@"1"];
						break;
					case WorldTerrainType_Mud:
						[buffer appendString:@"2"];
						break;
					case WorldTerrainType_Water:
						[buffer appendString:@"3"];
						break;
					default:
						[buffer appendString:@"0"];
						break;
				}
			}
		}
		
		[buffer appendString:@"]"];
		
		NSLog(@"%@", buffer);
	}
}

- (BOOL) isPosition:(CGPoint)position partOfThePath:(NSArray *)path {
	BOOL value = NO;
	
	for (PathNode *n in path) {
		if (CGPointEqualToPoint(position, n.position)) {
			value = YES;
			break;
		}
	}
	
	return value;
}

@end
