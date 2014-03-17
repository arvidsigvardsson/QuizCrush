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
//    NSLog(@"Number of categories: %ld", noCategories);

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
    
    NSSet *parameterSet = [NSSet setWithObject:iD];
    return [self surroundedTileOfCategory:category withSet:parameterSet];
}

-(NSNumber *) iDOfTileAtPosition:(NSNumber *)position {
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

-(NSSet *) surroundedTileOfCategory:(NSNumber *) category withSet:(NSSet *) set {
    return nil;
}

@end
