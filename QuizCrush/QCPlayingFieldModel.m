//
//  QCPlayingFieldModel.m
//  QuizCrush
//
//  Created by Arvid on 2014-03-17.
//  Copyright (c) 2014 Planeto. All rights reserved.
//

#import "QCPlayingFieldModel.h"

@interface QCPlayingFieldModel ()

@property NSMutableArray *tileGrid;
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

    _tileGrid = [[NSMutableArray alloc] init];


    for (int i = 0; i < [rowsAndCols intValue] * [rowsAndCols intValue]; i++) {
        NSNumber *randomCategory = [NSNumber numberWithInt:arc4random_uniform(noCategories)];
        NSNumber *x = [NSNumber numberWithInt:i % [rowsAndCols intValue]];
        NSNumber *y = [NSNumber numberWithInt:i / [rowsAndCols intValue]];
//        NSLog(@"x = %@  y = %@", x, y);
//        QCTile *tile = [[QCTile alloc] initWithCategory:randomCategory iD:[NSNumber numberWithInt:i]];
        QCTile *tile = [[QCTile alloc] initWithCategory:randomCategory iD:[NSNumber numberWithInt:i] x:x y:y];
        [_tileGrid addObject:tile];

    }
    
    return self;
}

-(NSNumber *) categoryOfTileAtPosition:(NSNumber *)position {
    if (0 <= [position intValue] < [_tileGrid count]) {
        return [_tileGrid[[position intValue]] category];
    } else {
        return nil;
    }
}



-(NSSet *) matchingAdjacentTilesToTileAtPosition:(NSNumber *) position {
//    return nil;
    // method should start recursive method calls
//    NSNumber *iD = [NSNumber numberWithInt:[self iDOfTileAtPosition:position]];
    NSNumber *iD = [self iDOfTileAtPosition:position];
    NSNumber * category = [self categoryOfTileAtPosition:position];
    
    NSMutableSet *parameterSet = [[NSMutableSet alloc] init];
    [parameterSet addObject:iD];
    [self recursionSelectionForID:iD category:category withSet:parameterSet];
    
//    [self recursionSelctionWithCategory:category withSet:parameterSet];
    
    return parameterSet;
//    return [self recursionSelctionWithCategory:category withSet:parameterSet];
}

-(NSNumber *) iDOfTileAtPosition:(NSNumber *)position {
    
    //test!
//    NSLog(@"Tile right: %@ tile left: %@ tile above: %@ tile below: %@", [self iDOfTileRightOfTile:position], [self iDOfTileLeftOfTile:position], [self iDOfTileAboveTile:position], [self iDOfTileBelowfTile:position]);
//    NSLog(@"Tile right: %@", [self iDOfTileRightOfTile:position]);
    
    if (0 <= [position intValue] < [_tileGrid count]) {
        return [_tileGrid[[position intValue]] iD];
    } else {
        return nil;
    }
}

-(NSNumber *) categoryOfTileWithID:(NSNumber *)ID {
    // needs to be modified if switching tileGrid to dictionary
    if (0 <= [ID intValue] < [_tileGrid count]) {
        return [_tileGrid[[ID intValue]] category];
    } else {
        return nil;
    }

}

-(NSNumber *) iDOfTileAtX:(NSNumber *) x Y:(NSNumber *) y {
    // TODO change this method when _tileGrid becomes dict
    int xp = [x intValue];
    int yp = [y intValue];
    int rows = [_noRowsAndCols intValue];
    
//    if (0 <= xp < rows && 0 <= yp < rows)
    if (xp >= 0 && xp < rows && yp >= 0 && yp < rows) {
        int index = xp + yp * rows;
        return [_tileGrid[index] iD];
    } else {
        return nil;
    }
}

-(QCTile *) tileWithID:(NSNumber *) iD {
    // TODO change this method when _tileGrid becomes dict
    int index = [iD intValue];
    if (index >= 0 && index < [_tileGrid count]) {
        return _tileGrid[index];
    } else {
        return nil;
    }
}


//-(void) recursionSelectionWithCategory:(NSNumber *) category withSet:(NSMutableSet *) set {
//}
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

@end
