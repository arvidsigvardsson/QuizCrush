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
        QCTile *tile = [[QCTile alloc] initWithCategory:randomCategory ID:i];
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

@end
