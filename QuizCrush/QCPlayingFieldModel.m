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
        QCTile *tile = [[QCTile alloc] initWithCategory:randomCategory iD:[NSNumber numberWithInt:i]];
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
    [self recursionSelctionWithCategory:category withSet:parameterSet];
    
    return parameterSet;
//    return [self recursionSelctionWithCategory:category withSet:parameterSet];
}

-(NSNumber *) iDOfTileAtPosition:(NSNumber *)position {
    
    //test!
    NSLog(@"Tile right: %@ tile left: %@ tile above: %@ tile below: %@", [self iDOfTileRightOfTile:position], [self iDOfTileLeftOfTile:position], [self iDOfTileAboveTile:position], [self iDOfTileBelowfTile:position]);
    
    
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

-(void) recursionSelctionWithCategory:(NSNumber *) category withSet:(NSMutableSet *) set {
}

-(NSNumber *) iDOfTileRightOfTile:(NSNumber *) iD {
    int column = ([iD intValue] + 1) % [_noRowsAndCols intValue];
    if ([iD intValue] < 0 || [iD intValue] >= [_tileGrid count] || column >= [_noRowsAndCols intValue]) {
        return nil;
    } else {
        return [_tileGrid[[iD intValue] + 1] iD];
    }
}

-(NSNumber *) iDOfTileLeftOfTile:(NSNumber *) iD {
    int column = ([iD intValue] + 1) % [_noRowsAndCols intValue];
    if ([iD intValue] < 0 || [iD intValue] >= [_tileGrid count] || column <= 0) {
        return nil;
    } else {
        return [_tileGrid[[iD intValue] - 1] iD];
    }
}

-(NSNumber *) iDOfTileAboveTile:(NSNumber *) iD {
    int row = [iD intValue] % [_noRowsAndCols intValue];
    if ([iD intValue] < 0 || [iD intValue] >= [_tileGrid count] || row <= 0) {
        return nil;
    } else {
        return [_tileGrid[[iD intValue] - [_noRowsAndCols intValue]] iD];
    }
}

-(NSNumber *) iDOfTileBelowfTile:(NSNumber *) iD {
    int row = [iD intValue] % [_noRowsAndCols intValue];
    if ([iD intValue] < 0 || [iD intValue] >= [_tileGrid count] || row >= ([_noRowsAndCols intValue] - 1)) {
        return nil;
    } else {
        return [_tileGrid[[iD intValue] + [_noRowsAndCols intValue]] iD];
    }
}
@end
