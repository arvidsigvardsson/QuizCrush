//
//  QCPlayingFieldModel.m
//  QuizCrush
//
//  Created by Arvid on 2014-03-17.
//  Copyright (c) 2014 Planeto. All rights reserved.
//

#import "QCPlayingFieldModel.h"

@interface QCPlayingFieldModel ()

@property NSMutableDictionary *tileDict;
@property NSNumber *noRowsAndCols;
@property int currentID;
@end

@implementation QCPlayingFieldModel

-(id) initWithNumberOfRowsAndColumns:(NSNumber *)rowsAndCols {
    if(!(self = [super init])){
        return self;
    }

    //initialization
    _currentID = 0;
//    NSString *plistCatPath = [[NSBundle mainBundle] pathForResource:@"UISettings" ofType:@"plist"];
//    NSDictionary *uiSettingsDictionary = [[NSDictionary alloc] initWithContentsOfFile:plistCatPath];
//    int noCategories = [uiSettingsDictionary[@"Number of categories"] intValue];
    _noRowsAndCols = [NSNumber numberWithInt:[rowsAndCols intValue]];

    _tileDict = [[NSMutableDictionary alloc] init];
    


    for (int i = 0; i < [rowsAndCols intValue] * [rowsAndCols intValue]; i++) {
//        NSNumber *randomCategory = [NSNumber numberWithInt:arc4random_uniform(noCategories)];
        NSNumber *x = [NSNumber numberWithInt:i % [rowsAndCols intValue]];
        NSNumber *y = [NSNumber numberWithInt:i / [rowsAndCols intValue]];
        
        QCTile *tile = [[QCTile alloc] initWithCategory:[self nextCategory]
                                                     iD:[self nextID]
                                                      x:x
                                                      y:y];
        [_tileDict setObject:tile forKey:tile.iD];
        
        
            }
    return self;
}

-(NSNumber *) nextID {
    _currentID += 1;
    return [NSNumber numberWithInt:_currentID - 1];
}

-(NSNumber *) nextCategory {
//    return @4;
    NSString *plistCatPath = [[NSBundle mainBundle] pathForResource:@"UISettings" ofType:@"plist"];
    NSDictionary *uiSettingsDictionary = [[NSDictionary alloc] initWithContentsOfFile:plistCatPath];

    int noCategories = [uiSettingsDictionary[@"Number of categories"] intValue];

    return [NSNumber numberWithInt:arc4random_uniform(noCategories)];
}


-(NSSet *) matchingAdjacentTilesToTileWithID:(NSNumber *) iD {
    NSNumber *category = [self categoryOfTileWithID:iD];
    
    NSMutableSet *parameterSet = [[NSMutableSet alloc] init];
    [parameterSet addObject:iD];
    [self recursionSelectionForID:iD category:category withSet:parameterSet];
    
    // test
//    QCTile *tile = [[QCTile alloc] initWithCategory:@1 iD:@10010 x:@0 y:@-1];
//    [_tileDict setObject:tile forKey:tile.iD];
//    NSSet *set = [self findTilesAboveID:iD];
//
//    NSLog(@"Hela dicten: %@", _tileDict);
//    NSLog(@"Set above: %@", set);
    
    return parameterSet;
}

-(NSNumber *) categoryOfTileWithID:(NSNumber *)ID {
    return [[_tileDict objectForKey:ID] category];
}

-(NSNumber *) iDOfTileAtX:(NSNumber *) x Y:(NSNumber *) y {
    for (NSNumber *key in _tileDict) {
        QCTile *tile = _tileDict[key];
        if (!tile || !x || !y) {
            return nil;
        }
        if ([tile.x isEqualToNumber:x] && [tile.y isEqualToNumber:y]) {
            return tile.iD;
        }
    }
    
    return nil;
}

-(QCTile *) tileAtX:(NSNumber *) x Y:(NSNumber *) y {
    return _tileDict[[self iDOfTileAtX:x Y:y]];
}

-(QCTile *) tileWithID:(NSNumber *) iD {
    return _tileDict[iD];
}


-(NSNumber *) iDOfTileRightOfTile:(NSNumber *) iD {
    QCTile *tile = [self tileWithID:iD];
    int x = [[tile x] intValue] + 1;
    return [self iDOfTileAtX:[NSNumber numberWithInt:x] Y:[tile y]];
}

-(NSNumber *) iDOfTileLeftOfTile:(NSNumber *) iD {
    QCTile *tile = [self tileWithID:iD];
    int x = [[tile x] intValue] - 1;
    return [self iDOfTileAtX:[NSNumber numberWithInt:x] Y:[tile y]];
}

-(NSNumber *) iDOfTileAboveTile:(NSNumber *) iD {
    QCTile *tile = [self tileWithID:iD];
    int y = [[tile y] intValue] - 1;
    return [self iDOfTileAtX:[tile x] Y:[NSNumber numberWithInt:y]];
}

-(NSNumber *) iDOfTileBelowOfTile:(NSNumber *) iD {
    QCTile *tile = [self tileWithID:iD];
    int y = [[tile y] intValue] + 1;
    return [self iDOfTileAtX:[tile x] Y:[NSNumber numberWithInt:y]];
}

-(BOOL) tilesAreAdjacentID1:(NSNumber *) tile1ID ID2:(NSNumber *) tile2ID {
    if ([[self iDOfTileRightOfTile:tile1ID] isEqualToNumber:tile2ID] || [[self iDOfTileLeftOfTile:tile1ID] isEqualToNumber:tile2ID] || [[self iDOfTileAboveTile:tile1ID] isEqualToNumber:tile2ID] || [[self iDOfTileBelowOfTile:tile1ID] isEqualToNumber:tile2ID]) {
        return YES;
    } else {
        return NO;
    }
}

-(void) recursionSelectionForID:(NSNumber *) iD category:(NSNumber *) category withSet:(NSMutableSet *) set {
    // look right
    NSNumber *iDRight = [self iDOfTileRightOfTile:iD];
    if (![set member:iDRight] && iDRight) {
        NSNumber *catRight = [self categoryOfTileWithID:iDRight];
        if ([category isEqual:catRight]) {
            [set addObject:iDRight];
            [self recursionSelectionForID:iDRight category:category withSet:set];
        }
    }
    
    // look left
    NSNumber *iDLeft = [self iDOfTileLeftOfTile:iD];
    if (![set member:iDLeft] && iDLeft) {
        NSNumber *catLeft = [self categoryOfTileWithID:iDLeft];
        if ([category isEqual:catLeft]) {
            [set addObject:iDLeft];
            [self recursionSelectionForID:iDLeft category:category withSet:set];
        }
    }
    // look above
    NSNumber *iDAbove = [self iDOfTileAboveTile:iD];
    if (![set member:iDAbove] && iDAbove) {
        NSNumber *catAbove = [self categoryOfTileWithID:iDAbove];
        if ([category isEqual:catAbove]) {
            [set addObject:iDAbove];
            [self recursionSelectionForID:iDAbove category:category withSet:set];
        }
    }
    
    // look below
    NSNumber *iDBelow = [self iDOfTileBelowOfTile:iD];
    if (![set member:iDBelow] && iDBelow) {
        NSNumber *catBelow = [self categoryOfTileWithID:iDBelow];
        if ([category isEqual:catBelow]) {
            [set addObject:iDBelow];
            [self recursionSelectionForID:iDBelow category:category withSet:set];
        }
    }
    
}

-(NSSet *) findTilesAboveID:(NSNumber *) ID {
    // also returns id of start tile
    QCTile *tile = _tileDict[ID];
    if (!tile) {
        return nil;
    }
    
    NSNumber *x = tile.x;
    int y = [tile.y intValue];
    NSMutableSet *set = [[NSMutableSet alloc] init];
//    [set addObject:tile.iD];
    
//    while (y >= -1) {
//        y -= 1;
//        QCTile *newTile = [self tileAtX:tile.x Y:[NSNumber numberWithInt:y]];
//        if (newTile) {
//            [set addObject:newTile.iD];
//        }
//    }
    
    while ([self tileAtX:x Y:[NSNumber numberWithInt:y]]) {
        [set addObject:[self iDOfTileAtX:x Y:[NSNumber numberWithInt:y]]];
        y -= 1;
    }
    
//    NSLog(@"Above set: %@", set);
    return set;
}

-(void) shiftTilesDown:(NSSet *) set {
    if (!set) {
        return;
    }
    
    for (NSNumber *key in set){
        QCTile *tile = _tileDict[key];
        int newY = [tile.y intValue] + 1;
        tile.y = [NSNumber numberWithInt:newY];
    }
}

-(NSSet *) getNewTilesReplacing:(NSSet *) set{
    if (!set) {
        return nil;
    }
    
    NSMutableSet *returnSet = [[NSMutableSet alloc] init];
    
    for (NSNumber *key in set) {
        NSNumber *x = [[self tileWithID:key] x];
        int y = [[[self tileWithID:key] y] intValue];
        // move upwards until there is no tile left
        while ([self tileAtX:x Y:[NSNumber numberWithInt:y]]) {
            y -= 1;
        }
        // add new tile at top of stack
        QCTile *newTile = [[QCTile alloc] initWithCategory:[self nextCategory]
                                                        iD:[self nextID]
                                                         x:x
                                                         y:[NSNumber numberWithInt:y]];
        [_tileDict setObject:newTile forKey:newTile.iD];
        [returnSet addObject:newTile.iD];
    }
    return returnSet;
}

-(NSDictionary *) removeAndReturnVerticalTranslations:(NSSet *) removeSet {
    if (!removeSet) {
        return nil;
    }
    
    // key in transdict is ID for tile, value is number of steps down the tile makes
    NSMutableDictionary *transDict = [[NSMutableDictionary alloc] init];
    
    
    for (NSNumber *key in removeSet) {
//        // add new tile to tileDict, make sure it ends up in shiftSet
//        NSNumber *currentX = [self tileWithID:key].x;
//        QCTile *newTile = [[QCTile alloc] initWithCategory:[self nextCategory]
//                                                        iD:[self nextID]
//                                                         x:currentX
//                                                         y:@-1];
//        [_tileDict setObject:newTile forKey:newTile.iD];
        
        NSSet *shiftSet = [self findTilesAboveID:key];
        
        
//        [self shiftTilesDown:shiftSet];
        
        for (NSNumber *IDFromSet in shiftSet) {
            if (transDict[IDFromSet]) {
                // increment the value of steps to take, or adds the ID to the dict
                int steps = [transDict[IDFromSet] intValue] + 1;
                [transDict setObject:[NSNumber numberWithInt:steps] forKey:IDFromSet];
            } else {
                [transDict setObject:@1 forKey:IDFromSet];
            }
        }
    }
    
    // move tiles in model
    for (NSNumber *transKey in transDict) {
        QCTile *transTile = _tileDict[transKey];
        int newY = [transTile.y intValue] + [transDict[transKey] intValue];
        transTile.y = [NSNumber numberWithInt:newY];
    }
    
    // removeTiles
    for (NSNumber *thirdKey in removeSet) {
        [_tileDict removeObjectForKey:thirdKey];
    }
    
    
    
    // remove id of removed tiles from return dict
    [transDict removeObjectsForKeys:[removeSet allObjects]];
    
    // test
//    for (NSNumber *makeSureKey in _tileDict) {
//        QCTile *makeSureTile = [self tileWithID:makeSureKey];
//        NSLog(@"Tile with ID: %@, x: %@, y: %@, category: %@", makeSureTile.iD, makeSureTile.x, makeSureTile.y, makeSureTile.category);
//    }
//    
    
    return  transDict;
}

-(NSDictionary *) positionOneStepFromID:(NSNumber *) ID inDirection:(NSString *) direction {
    QCTile *tile = [self tileWithID:ID];
    int x = [tile.x intValue];
    int y = [tile.y intValue];
    
    if ([direction isEqualToString:@"up"]) {
        y -= 1;
    } else if ([direction isEqualToString:@"right"]) {
        x += 1;
    } else if ([direction isEqualToString:@"down"]) {
        y += 1;
    } else if ([direction isEqualToString:@"left"]) {
        x -= 1;
    } else {
        return nil;
    }
    
    NSDictionary *dict = [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithInt:x], [NSNumber numberWithInt:y]] forKeys:@[@"x", @"y"]];
    return dict;
}

-(QCMoveDescription *) takeOneStepAndReturnMoveForID:(NSNumber *) tileID InDirection:(NSString *) direction {
    if (!tileID || !direction) {
        return nil;
    }
    
    // xMove and yMove are reverse of direction
    int xMove, yMove;
    if ([direction isEqualToString:@"up"]) {
        xMove = 0;
        yMove = 1;
    } else if ([direction isEqualToString:@"right"]) {
        xMove = -1;
        yMove = 0;
    } else if ([direction isEqualToString:@"down"]) {
        xMove = 0;
        yMove = -1;
    } else if ([direction isEqualToString:@"left"]) {
        xMove = 1;
        yMove = 0;
    } else {
        return nil;
    }
    
    QCMoveDescription *move = [[QCMoveDescription alloc] init];
    move.tileToDelete = tileID;
    move.direction = direction;
    
    QCTile *startTile = _tileDict[tileID];
    int x = [startTile.x intValue];
    int y = [startTile.y intValue];
    NSNumber *iterID;
    int rows = [_noRowsAndCols intValue];
    int columns = [_noRowsAndCols intValue];
    
    
    // TODO HÄR LIGGER PROBLEMET JUST NU
//    while (x >= 0 && x < columns && y >= 0 && y < rows) {
    while ([self iDOfTileAtX:[NSNumber numberWithInt:x] Y:[NSNumber numberWithInt:y]]) {
        iterID = [self iDOfTileAtX:[NSNumber numberWithInt:x] Y:[NSNumber numberWithInt:y]];
        [move.moveDict setObject:direction forKey:iterID];
        x += xMove;
        y += yMove;
    }
    
    // create new tile at (xCreate,yCreate) and add to move and model and createdTile
    int xCreate = [startTile.x intValue];
    int yCreate = [startTile.y intValue];

    while (xCreate >= 0 && xCreate < columns && yCreate >= 0 && yCreate < rows) {
        x += xMove;
        y += yMove;
    }
    
    QCTile *newTile = [[QCTile alloc] initWithCategory:[self nextCategory] iD:[self nextID] x:[NSNumber numberWithInt:xCreate] y:[NSNumber numberWithInt:yCreate]];
    [_tileDict setObject:newTile forKey:newTile.iD];
    
    [move.moveDict setObject:direction forKey:newTile.iD];
    move.createdTileID = newTile.iD;
    return move;
    
}

-(NSString *) directionFromID:(NSNumber *) IDStart toID:(NSNumber *) IDEnd {
    QCTile *startTile = [self tileWithID:IDStart];
    QCTile *endTile = [self tileWithID:IDEnd];
    if(!startTile || !endTile || [IDStart isEqualToNumber:IDEnd]) {
        return nil;
    }
    
    int startX = [startTile.x intValue];
    int startY = [startTile.y intValue];
    int endX = [endTile.x intValue];
    int endY = [endTile.y intValue];
    
    if (startX == endX) {
        if (startY > endY) {
            return @"up";
        } else if (startY < endY) {
            return @"down";
        } else {
            return nil;
        }
    } else if (startY == endY) {
        if (startX < endX) {
            return @"right";
        } else if (startX > endX) {
            return @"left";
        } else {
            return nil;
        }
    } else {
        return nil;
    }
}


    
@end
