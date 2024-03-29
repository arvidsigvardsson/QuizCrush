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
@property NSNumber *numberOfRows;
@property NSNumber *numberOfColumns;
@property int currentID;
@property NSNumber *avatar;
@property (nonatomic) NSArray *categoriesArray;

@end

@implementation QCPlayingFieldModel

-(NSString *) description {
    return [self playingfieldAsString];
    
    
    NSMutableString *string = [[NSMutableString alloc] init];
    [string appendFormat:@"QCPlayingFieldModel, size: %lu\n", (unsigned long)[_tileDict count]];
    for (NSNumber *key in _tileDict) {
        QCTile *tile = _tileDict[key];
//        NSString *str = [[NSString stringWithFormat:@"ID: %@ at x: %@, y: %@\n", key, tile.x, tile.y] stringByPaddingToLength:15 withString:@" " startingAtIndex:0];
//        [string appendString:str];
        [string appendFormat:@"ID: %@, x = %@, y = %@,\n", key, tile.x, tile.y];
        
    }
    return string;
}

-(NSString *) playingfieldAsString {
    NSMutableString *string = [[NSMutableString alloc] init];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    int rows = [_numberOfRows intValue];
    int cols = [_numberOfColumns intValue];
    for (int i = 0; i < rows * cols; i++) {
        [array addObject:@-1];
    }
    
    for (NSNumber *key in _tileDict) {
        QCTile *tile = _tileDict[key];
        int index = [tile.y intValue] * cols + [tile.x intValue];
        array[index] = tile.category;
    }
    
    for (int n = 0; n < [array count]; n++) {
        [string appendFormat:@"%@ ", array[n]];
        if ((n + 1) % cols == 0) {
            [string appendString:@"\n"];
        }
    }
    
    return string;
}



-(id) initWithNumberOfRowsAndColumns:(NSNumber *)rowsAndCols {
    if(!(self = [super init])){
        return self;
    }

    //initialization
    _currentID = 0;
    _noRowsAndCols = [NSNumber numberWithInt:[rowsAndCols intValue]];

    _tileDict = [[NSMutableDictionary alloc] init];
    


    for (int i = 0; i < [rowsAndCols intValue] * [rowsAndCols intValue]; i++) {
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

-(id) initWithRows:(NSNumber *) numberOfRows Columns:(NSNumber *) numberOfColumns {
    if(!(self = [super init])){
        return self;
    }
    _currentID = 0;
    _numberOfRows = numberOfRows;
    _numberOfColumns = numberOfColumns;
    _tileDict = [[NSMutableDictionary alloc] init];

    for (int i = 0; i < [numberOfRows intValue] * [numberOfColumns intValue]; i++) {
        NSNumber *x = [NSNumber numberWithInt:i % [numberOfColumns intValue]];
        NSNumber *y = [NSNumber numberWithInt:i / [numberOfColumns intValue]];
        
        QCTile *tile = [[QCTile alloc] initWithCategory:[self nextCategory]
                                                     iD:[self nextID]
                                                      x:x
                                                      y:y];
        [_tileDict setObject:tile forKey:tile.iD];

    }
    
    return self;
}

-(id) initWithRows:(NSNumber *) numberOfRows Columns:(NSNumber *) numberOfColumns levelDocument:(NSString *) document {
    if(!(self = [super init])){
        return self;
    }

    NSString *path = [[NSBundle mainBundle] pathForResource:document
                                                     ofType:@"plist"];
    NSDictionary *levelDict = [NSDictionary dictionaryWithContentsOfFile:path];
    _categoriesArray = levelDict[@"Categories"];
    
    _currentID = 0;
    _numberOfRows = numberOfRows;
    _numberOfColumns = numberOfColumns;
    _tileDict = [[NSMutableDictionary alloc] init];
    
    for (int i = 0; i < [numberOfRows intValue] * [numberOfColumns intValue]; i++) {
        NSNumber *x = [NSNumber numberWithInt:i % [numberOfColumns intValue]];
        NSNumber *y = [NSNumber numberWithInt:i / [numberOfColumns intValue]];
        
        QCTile *tile = [[QCTile alloc] initWithCategory:[self nextCategory]
                                                     iD:[self nextID]
                                                      x:x
                                                      y:y];
        [_tileDict setObject:tile forKey:tile.iD];
        
    }
    
    
    
    return self;

}

-(id) initWithAvatarRows:(NSNumber *) numberOfRows Columns:(NSNumber *) numberOfColumns{
    if(!(self = [super init])){
        return self;
    }
    _currentID = 0;
    _numberOfRows = numberOfRows;
    _numberOfColumns = numberOfColumns;
    _tileDict = [[NSMutableDictionary alloc] init];
    
    for (int i = 0; i < [numberOfRows intValue] * [numberOfColumns intValue]; i++) {
        NSNumber *x = [NSNumber numberWithInt:i % [numberOfColumns intValue]];
        NSNumber *y = [NSNumber numberWithInt:i / [numberOfColumns intValue]];
        
        QCTile *tile = [[QCTile alloc] initWithCategory:[self nextCategory]
                                                     iD:[self nextID]
                                                      x:x
                                                      y:y];
        [_tileDict setObject:tile forKey:tile.iD];
        
    }
    
    // find spot for avatar in "center"
    int aX = [numberOfColumns intValue] / 2;
    int aY = [numberOfRows intValue] / 2;
    
    QCTile *avatar = [self tileAtX:@(aX) Y:@(aY)];
    avatar.category = @9;
    _avatar = avatar.iD;
    
    return self;

}




-(NSDictionary *) returnPlayingField {
    return _tileDict;
}

-(NSNumber *) nextID {
    _currentID += 1;
    return [NSNumber numberWithInt:_currentID - 1];
}

-(NSNumber *) nextCategory {
//    return @3;
//    NSString *plistCatPath = [[NSBundle mainBundle] pathForResource:@"UISettings" ofType:@"plist"];
//    NSDictionary *uiSettingsDictionary = [[NSDictionary alloc] initWithContentsOfFile:plistCatPath];

//    int noCategories = [uiSettingsDictionary[@"Number of categories"] intValue];
//
//    return [NSNumber numberWithInt:arc4random_uniform(noCategories)];

    return _categoriesArray[arc4random_uniform((int)[_categoriesArray count])];

}

-(NSNumber *) nextCategoryExcluding:(NSNumber *) category {
    if (!category) {
        return [self nextCategory];
    }
    
    // somewhat dirty hack :=)
    NSNumber *returnCategory = [self nextCategory];
    while ([returnCategory isEqualToNumber:category]) {
        returnCategory = [self nextCategory];
    }
    return returnCategory;
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
    QCTile *tile = _tileDict[ID];
    if (!tile.category) {
        NSLog(@"Tile %@ has no category!", ID);
        return nil;
    } else {
        return tile.category;
    }
    
    
//    return [[_tileDict objectForKey:ID] category];
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

-(NSNumber *) IDOfTileDuringMotionAtX:(NSNumber *) x Y:(NSNumber *) y {
    for (NSNumber *key in _tileDict) {
        QCTile *tile = _tileDict[key];
        if ([tile.xDuringMotion isEqualToNumber:x] && [tile.yDuringMotion isEqualToNumber:y]) {
            return tile.iD;
        }
    }
    return nil;
}

-(NSSet *) IDsDuringMoveAtX:(NSNumber *) x AtY:(NSNumber *) y {
    if (!x || !y) {
        return nil;
    }
    NSMutableSet *returnSet = [[NSMutableSet alloc] init];
    for (NSNumber *key in _tileDict) {
        QCTile *tile = _tileDict[key];
        if ([tile.xDuringMotion isEqualToNumber:x] && [tile.yDuringMotion isEqualToNumber:y]) {
            [returnSet addObject:key];
        }
    }
    return returnSet;
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

-(NSSet *) getNewTilesReplacing:(NSSet *) set excludingCategory:(NSNumber *) excludeCategory withBooster:(NSNumber *) booster {
    if (!set) {
        return nil;
    }
    
    BOOL boosterAdded = NO;
    
    NSMutableSet *returnSet = [[NSMutableSet alloc] init];
    
    for (NSNumber *key in set) {
        NSNumber *x = [[self tileWithID:key] x];
        int y = [[[self tileWithID:key] y] intValue];
        // move upwards until there is no tile left
        while ([self tileAtX:x Y:[NSNumber numberWithInt:y]]) {
            y -= 1;
        }
        // add new tile at top of stack
        NSNumber *category;
        if (booster && !boosterAdded) {
            category = booster; //@8;
            boosterAdded = YES;
        } else {
            category = [self nextCategoryExcluding:excludeCategory];
        }
        
        
        QCTile *newTile = [[QCTile alloc] initWithCategory:category
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
        
        // lets see if this helps
        transTile.xDuringMotion = transTile.x;
        transTile.yDuringMotion = transTile.y;
    }
    
    // test
//    NSLog(@"tiledict innifrån removeandreturn: %@", self);
    
    
    
    
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
//    NSNumber *iterID;
    NSSet *iterSet;
    int rows = [_numberOfRows intValue];
    int columns = [_numberOfColumns intValue];
    
    
    while ([self iDOfTileAtX:[NSNumber numberWithInt:x] Y:[NSNumber numberWithInt:y]]) {
//        iterID = [self iDOfTileAtX:[NSNumber numberWithInt:x] Y:[NSNumber numberWithInt:y]];
//        [move.moveDict setObject:direction forKey:iterID];
        iterSet = [self IDsDuringMoveAtX:[NSNumber numberWithInt:x] AtY:[NSNumber numberWithInt:y]];
        for (NSNumber *iterKey in iterSet) {
            QCTile *moveTile = _tileDict[iterKey];
            moveTile.hasBeenMoved = YES;
            moveTile.xDuringMotion = [NSNumber numberWithInt:[moveTile.xDuringMotion intValue] - xMove];
            moveTile.yDuringMotion = [NSNumber numberWithInt:[moveTile.yDuringMotion intValue] - yMove];
            [move.moveDict setObject:direction forKey:iterKey];
            
        }
        x += xMove;
        y += yMove;
    }
    
    // create new tile at (xCreate,yCreate) and add to move and model and createdTile
    int xCreate = [startTile.x intValue];
    int yCreate = [startTile.y intValue];

    while (xCreate >= 0 && xCreate < columns && yCreate >= 0 && yCreate < rows) {
        xCreate += xMove;
        yCreate += yMove;
    }
    
    QCTile *newTile = [[QCTile alloc] initWithCategory:[self nextCategory]
                                                    iD:[self nextID]
                                                     x:[NSNumber numberWithInt:xCreate]
                                                     y:[NSNumber numberWithInt:yCreate]];
    newTile.xDuringMotion = [NSNumber numberWithInt:[newTile.xDuringMotion intValue] - xMove];
    newTile.yDuringMotion = [NSNumber numberWithInt:[newTile.yDuringMotion intValue] - yMove];

    newTile.hasBeenMoved = YES;
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

-(Direction) enumDirectionFromID:(NSNumber *) IDStart toID:(NSNumber *) IDEnd {
    QCTile *startTile = [self tileWithID:IDStart];
    QCTile *endTile = [self tileWithID:IDEnd];
    if(!startTile || !endTile || [IDStart isEqualToNumber:IDEnd]) {
        return NO_DIRECTION;
    }
    
    int startX = [startTile.x intValue];
    int startY = [startTile.y intValue];
    int endX = [endTile.x intValue];
    int endY = [endTile.y intValue];
    
    if (startX == endX) {
        if (startY > endY) {
            return UP;
        } else if (startY < endY) {
            return DOWN;
        } else {
            return NO_DIRECTION;
        }
    } else if (startY == endY) {
        if (startX < endX) {
            return RIGHT;
        } else if (startX > endX) {
            return LEFT;
        } else {
            return NO_DIRECTION;
        }
    } else {
        return NO_DIRECTION;
    }

}


-(void) deleteTiles:(NSSet *) IDsToDelete {
    if (!IDsToDelete) {
        return;
    }
    
    for (NSNumber *key in IDsToDelete) {
        [_tileDict removeObjectForKey:key];
    }
}

-(void) updateModelWithMoves:(NSArray *) moveArray {
    if (!moveArray) {
        return;
    }
    
    // update moved tiles
    for (NSNumber *key in _tileDict) {
        QCTile *tile = _tileDict[key];
        if ([tile hasBeenMoved]) {
            tile.x = tile.xDuringMotion;
            tile.y = tile.yDuringMotion;
            tile.hasBeenMoved = NO;
        }
    }
    // remove deleted tiles
    for (QCMoveDescription *move in moveArray) {
        if (move.tileToDelete) {
            [_tileDict removeObjectForKey:move.tileToDelete];
        }
    }
    
}

-(void) updateModelWithSuctionMoves:(NSArray *) moves{
    // update moved tiles
    for (NSNumber *key in _tileDict) {
        QCTile *tile = _tileDict[key];
        if ([tile hasBeenMoved]) {
            tile.x = tile.xDuringMotion;
            tile.y = tile.yDuringMotion;
            tile.hasBeenMoved = NO;
        }
    }
    // remove deleted tile
    for (QCSuctionMove *move in moves) {
        [_tileDict removeObjectForKey:move.deletedTile];
    }

}

-(void) swipeWasAbortedWithMoves:(NSArray *) moveArray {
    if (!moveArray) {
        return;
    }
    
    // delete created tiles
    NSMutableSet *deleteSet = [[NSMutableSet alloc] init];
    for (QCMoveDescription *move in moveArray) {
        [deleteSet addObject:move.createdTileID];
    }
    [self deleteTiles:deleteSet];
    
    // reset moved tiles
    for (NSNumber *key in _tileDict) {
        QCTile *tile = _tileDict[key];
        if (tile.hasBeenMoved) {
            tile.xDuringMotion = tile.x;
            tile.yDuringMotion = tile.y;
            tile.hasBeenMoved = NO;
        }
    }
}

-(void) suctionSwipeWasAbortedWithMoves:(NSArray *) moveArray {
    // delete created tiles from dictionary
    NSMutableSet *deleteSet = [[NSMutableSet alloc] init];
    for (QCSuctionMove *move in moveArray) {
        [deleteSet addObject:move.createdTile];
    }
    [self deleteTiles:deleteSet];
    
    // reset moved tiles and set toBeDeleted to NO
    for (NSNumber *key in _tileDict) {
        QCTile *tile = _tileDict[key];
        tile.toBeDeleted = NO;
        if (tile.hasBeenMoved) {
            tile.xDuringMotion = tile.x;
            tile.yDuringMotion = tile.y;
            tile.hasBeenMoved = NO;
        }
    }

}

-(QCSuctionMove *) takeFirstSuctionStepFrom:(NSNumber *) startID inDirection:(NSString *) direction {
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

    QCSuctionMove *move = [[QCSuctionMove alloc] init];
    move.deletedTile = startID;
    
    QCTile *startTile = _tileDict[startID];
    startTile.hasBeenMoved = YES;
    startTile.toBeDeleted = YES;
    int x = [startTile.x intValue];
    int y = [startTile.y intValue];
    
    while ([self iDOfTileAtX:[NSNumber numberWithInt:x] Y:[NSNumber numberWithInt:y]]) {
        QCTile *moveTile = [self tileAtX:[NSNumber numberWithInt:x] Y:[NSNumber numberWithInt:y]];
        moveTile.hasBeenMoved = YES;
        moveTile.xDuringMotion = [NSNumber numberWithInt:[moveTile.xDuringMotion intValue] - xMove];
        moveTile.yDuringMotion = [NSNumber numberWithInt:[moveTile.yDuringMotion intValue] - yMove];
        [move.tailArray addObject:moveTile.iD];
        [move.movementDict setObject:direction forKey:moveTile.iD];
        x += xMove;
        y += yMove;
    }
    
    // create new tile
    QCTile *newTile = [[QCTile alloc] initWithCategory:[self nextCategory]
                                                    iD:[self nextID]
                                                     x:[NSNumber numberWithInt:x]
                                                     y:[NSNumber numberWithInt:y]];
    newTile.xDuringMotion = [NSNumber numberWithInt:[newTile.xDuringMotion intValue] - xMove];
    newTile.yDuringMotion = [NSNumber numberWithInt:[newTile.yDuringMotion intValue] - yMove];
    newTile.hasBeenMoved = YES;
    [_tileDict setObject:newTile forKey:newTile.iD];
    [move.tailArray addObject:newTile.iD];
    [move.movementDict setObject:direction forKey:newTile.iD];
    move.createdTile = newTile.iD;
    move.creationSiteX = [NSNumber numberWithInt:x];
    move.creationSiteY = [NSNumber numberWithInt:y];
    return move;
}

-(QCSuctionMove *) takeNewSuctionStepFromID:(NSNumber *) startID WithMove:(QCSuctionMove *) suctionMove inDirection:(NSString *) direction {
    // create new tile
    QCTile *newTile = [[QCTile alloc] initWithCategory:[self nextCategory]
                                                    iD:[self nextID]
                                                     x:suctionMove.creationSiteX
                                                     y:suctionMove.creationSiteY];
    [_tileDict setObject:newTile forKey:newTile.iD];
    
    QCSuctionMove *nextMove = [[QCSuctionMove alloc] init];
    nextMove.creationSiteX = suctionMove.creationSiteX;
    nextMove.creationSiteY = suctionMove.creationSiteY;
    
    nextMove.createdTile = newTile.iD;
    nextMove.deletedTile = startID;
    QCTile *deleteTile = _tileDict[startID];
    deleteTile.toBeDeleted = YES;
    nextMove.tailArray = [NSMutableArray arrayWithArray:suctionMove.tailArray];
    [nextMove.tailArray addObject:newTile.iD];
    
    // go backwards through the tail to update positions and directions, ending on second tile
    for (long i = [nextMove.tailArray count] - 1; i > 0; i--) {
        QCTile *moveTile = _tileDict[nextMove.tailArray[i]];
        QCTile *destTile = _tileDict[nextMove.tailArray[i - 1]];
        moveTile.xDuringMotion = destTile.xDuringMotion;
        moveTile.yDuringMotion = destTile.yDuringMotion;
        moveTile.hasBeenMoved = YES;
        [nextMove.movementDict setObject:suctionMove.movementDict[destTile.iD] forKey:moveTile.iD];
    }
    
    
    // find position for the first tile in array to move to
    NSDictionary *destination = [self positionOneStepFromID:startID inDirection:direction];
    QCTile *firstTile = _tileDict[nextMove.tailArray[0]];
    firstTile.xDuringMotion = destination[@"x"];
    firstTile.yDuringMotion = destination[@"y"];
    firstTile.hasBeenMoved = YES;
//    [nextMove.tailArray[0] setXDuringMotion:destination[@"x"]];
//    [nextMove.tailArray[0] setYDuringMotion:destination[@"y"]];
    [nextMove.movementDict setObject:direction forKey:firstTile.iD];
    

    return nextMove;
}

-(NSNumber *) changeHeadOfSnakeToBoosterAndReturnItForMove:(QCSuctionMove *) move {
    for (NSNumber *key in move.tailArray) {
        QCTile *tile = _tileDict[key];
        if (!tile.toBeDeleted) {
            tile.category = @7;
            return key;
        }
    }
    return nil;
}

-(void) changeToBoosterForID:(NSNumber *) ID {
    QCTile *tile = _tileDict[ID];
    tile.category = @7;
}

-(void) changeTiles:(NSSet *)set toCategory:(NSNumber *) category{
    for (NSNumber *key in set) {
        QCTile *tile = _tileDict[key];
        tile.category = category;
    }
}

-(void) swapPositionsOfTile:(NSNumber *) firstID
                    andTile:(NSNumber *) secondID {
    QCTile *firstTile = _tileDict[firstID];
    QCTile *secondTile = _tileDict[secondID];
    
    int tempX = [firstTile.x intValue];
    int tempY = [firstTile.y intValue];
    
    firstTile.x = secondTile.x;
    firstTile.y = secondTile.y;
    
    secondTile.x = @(tempX);
    secondTile.y = @(tempY);
}

-(NSNumber *) IDOfAvatar {
    return _avatar;
}

-(void) switchTileToAvatar:(NSNumber *) ID {
    QCTile *tile = _tileDict[ID];
    tile.category = @9;
    _avatar = ID;
}

-(BOOL) tilesAreLinkedID1:(NSNumber *) tile1ID ID2:(NSNumber *) tile2ID {
    QCTile *tile1 = _tileDict[tile1ID];
    QCTile *tile2 = _tileDict[tile2ID];
    
    int x1 = [tile1.x intValue];
    int y1 = [tile1.y intValue];
    int x2 = [tile2.x intValue];
    int y2 = [tile2.y intValue];
    
    if (x1 <= x2 + 1 && x1 >= x2 - 1 && y1 <= y2 + 1 && y1 >= y2 - 1) {
        return true;
    } else {
        return false;
    }
}

@end
