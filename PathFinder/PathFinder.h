//
//  PathFinder.h
//  PathFinder
//
//  Created by Rémy Bardou on 16/10/13.
//  Copyright (c) 2013 GREE International Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WorldExplorationProtocol <NSObject>

- (NSArray *) worldGridArray;
- (void) print;

@end

@interface PathNode : NSObject

@property (nonatomic, assign) CGPoint position;
@property (nonatomic, strong) PathNode *parent;

@property (nonatomic, assign) NSInteger gScore; // sum of all the costs it took to get there
@property (nonatomic, assign) NSInteger hScore; // heuristic, estimate of what it will take to get there
@property (nonatomic, assign, readonly) NSInteger fScore; // sum of g + h

- (id)initWithPosition:(CGPoint)position;

@end

@interface PathFinder : NSObject

+ (instancetype) sharedInstance;

- (NSMutableArray *)pathInExplorableWorld:(id<WorldExplorationProtocol>)world fromA:(CGPoint)pointA toB:(CGPoint)pointB;

@end
