//
//  World.h
//  PathFinder
//
//  Created by Rémy Bardou on 09/10/13.
//  Copyright (c) 2013 GREE International Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PathFinder.h"

typedef enum WorldTerrainType : NSUInteger {
	WorldTerrainType_Default = 0,
	WorldTerrainType_Mud = 5,
	WorldTerrainType_Water = 20,
	WorldTerrainType_Wall = 999
} WorldTerrainType;

@interface World : NSObject<ExplorableWorldDelegate>

@property (nonatomic, strong) NSMutableArray *worldMap;

@property (nonatomic, assign) CGPoint heroPosition;
@property (nonatomic, assign) CGPoint destinationPosition;

- (void) addWall:(CGPoint)wallPosition;
- (void) setTerrainType:(WorldTerrainType)type atPosition:(CGPoint)position;

- (void) print;
- (void) printWithPath:(NSArray *)path;

@end
