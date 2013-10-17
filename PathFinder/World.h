//
//  World.h
//  PathFinder
//
//  Created by Rémy Bardou on 09/10/13.
//  Copyright (c) 2013 GREE International Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PathFinder.h"

@interface World : NSObject<WorldExplorationProtocol>

@property (nonatomic, strong) NSMutableArray *worldMap;

@property (nonatomic, assign) CGPoint heroPosition;
@property (nonatomic, assign) CGPoint destinationPosition;

- (void) addWall:(CGPoint)wallPosition;
- (NSMutableArray *)pathToDestination;

@end
