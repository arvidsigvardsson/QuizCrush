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
@end

@implementation QCPlayingFieldModel

-(id) initWithNumberOfRowsAndColumns:(NSNumber *)rowsAndCols {
    if(!(self = [super init])){
        return self;
    }

    //initialization
    NSString *plistCatPath = [[NSBundle mainBundle] pathForResource:@"UISettings" ofType:@"plist"];
    NSDictionary *uiSettingsDictionary = [[NSDictionary alloc] initWithContentsOfFile:plistCatPath];
    int noCategories = [uiSettingsDictionary[@"Number of categories"] intValue];
    _noRowsAndCols = [NSNumber numberWithInt:[rowsAndCols intValue]];

    _tileDict = [[NSMutableDictionary alloc] init];
    


    for (int i = 0; i < [rowsAndCols intValue] * [rowsAndCols intValue]; i++) {
        NSNumber *randomCategory = [NSNumber numberWithInt:arc4random_uniform(noCategories)];
        NSNumber *x = [NSNumber numberWithInt:i % [rowsAndCols intValue]];
        NSNumber *y = [NSNumber numberWithInt:i / [rowsAndCols intValue]];
        
        QCTile *tile = [[QCTile alloc] initWithCategory:randomCategory
                                                     iD:[NSNumber numberWithInt:i]
                                                      x:x
                                                      y:y];
        [_tileDict setObject:tile forKey:tile.iD];

    }
    
    return self;
}




-(NSSet *) matchingAdjacentTilesToTileWithID:(NSNumber *) iD {
    NSNumber *category = [self categoryOfTileWithID:iD];
    
    NSMutableSet *parameterSet = [[NSMutableSet alloc] init];
    [parameterSet addObject:iD];
    [self recursionSelectionForID:iD category:category withSet:parameterSet];
    
    return parameterSet;
}

-(NSNumber *) categoryOfTileWithID:(NSNumber *)ID {
    return [[_tileDict objectForKey:ID] category];
}

-(NSNumber *) iDOfTileAtX:(NSNumber *) x Y:(NSNumber *) y {
    for (NSNumber *key in _tileDict) {
        QCTile *tile = _tileDict[key];
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

-(NSNumber *) iDOfTileBelowfTile:(NSNumber *) iD {
    QCTile *tile = [self tileWithID:iD];
    int y = [[tile y] intValue] + 1;
    return [self iDOfTileAtX:[tile x] Y:[NSNumber numberWithInt:y]];
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
    NSNumber *iDBelow = [self iDOfTileBelowfTile:iD];
    if (![set member:iDBelow] && iDBelow) {
        NSNumber *catBelow = [self categoryOfTileWithID:iDBelow];
        if ([category isEqual:catBelow]) {
            [set addObject:iDBelow];
            [self recursionSelectionForID:iDBelow category:category withSet:set];
        }
    }
    
}

-(NSDictionary *) removeAndReturnVerticalTranslations:(NSSet *) removeSet {
    if (!removeSet) {
        return nil;
    }
    
    // removeTiles
//    for (NSNumber *key in removeSet) {
//        [_tileDict removeObjectForKey:key];
//    }
    
    NSMutableDictionary *transDict = [[NSMutableDictionary alloc] init];
    // TODO fortsätt här!!!
    return nil;
}

-(NSSet *) findTilesAboveID:(NSNumber *) ID {
    // also returns id of start tile
    QCTile *tile = _tileDict[ID];
    if (!tile) {
        return nil;
    }
    
    int y = [tile.y intValue];
    NSMutableSet *set = [[NSMutableSet alloc] init];
    
    while (y >= -1) {
        QCTile *newTile = [self tileAtX:tile.x Y:[NSNumber numberWithInt:y]];
        if (newTile) {
            [set addObject:newTile.iD];
        }
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

@end
