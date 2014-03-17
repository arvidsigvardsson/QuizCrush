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

-(id) initWithNumberOfRowsAndColumns:(int)rowsAndCols {
    if(!(self = [super init])){
        return self;
    }

    //initialization
    NSString *plistCatPath = [[NSBundle mainBundle] pathForResource:@"UISettings" ofType:@"plist"];
    NSDictionary *uiSettingsDictionary = [[NSDictionary alloc] initWithContentsOfFile:plistCatPath];
    int noCategories = [uiSettingsDictionary[@"Number of categories"] intValue];
//    NSLog(@"Number of categories: %ld", noCategories);

    _tileGrid = [[NSMutableArray alloc] init];


    for (int i = 0; i < rowsAndCols * rowsAndCols; i++) {
        int randomCategory = arc4random_uniform(noCategories);
        QCTile *tile = [[QCTile alloc] initWithCategory:randomCategory iD:i];
        [_tileGrid addObject:tile];

    }

    return self;
}

-(int) categoryOfTileAtPosition:(int)position {
    if (0 <= position < [_tileGrid count]) {
        return [_tileGrid[position] category];
    } else {
        return -1;
    }
}

-(NSSet *) matchingAdjacentTilesToTileAtPosition:(int) position {
//    return nil;
    // method should start recursive method calls
    NSNumber *iD = [NSNumber numberWithInt:[self iDOfTileAtPosition:position]];
    int category = [self categoryOfTileAtPosition:position];
    
    NSSet *parameterSet = [NSSet setWithObject:iD];
    return [self surroundedTileOfCategory:category withSet:parameterSet];
}

-(int) iDOfTileAtPosition:(int)position {
    if (0 <= position < [_tileGrid count]) {
        return [_tileGrid[position] iD];
    } else {
        return -1;
    }
}

-(int) categoryOfTileWithID:(int)ID {
    // needs to be modified if switching tileGrid to dictionary
    if (0 <= ID < [_tileGrid count]) {
        return [_tileGrid[ID] category];
    } else {
        return -1;
    }

}

-(NSSet *) surroundedTileOfCategory:(int) category withSet:(NSSet *) set {
    return nil;
}

@end
