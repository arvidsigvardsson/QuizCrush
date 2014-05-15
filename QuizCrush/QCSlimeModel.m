//
//  QCSlimeModel.m
//  QuizCrush
//
//  Created by Arvid on 2014-05-15.
//  Copyright (c) 2014 Planeto. All rights reserved.
//

#import "QCSlimeModel.h"

@implementation QCSlimeModel


-(id) initWithRows:(NSNumber *) rows Columns:(NSNumber *) columns markedPositions:(NSArray *) markedArray {
    if (!(self = [super init])) {
        return self;
    }
    
    _slimeArray = [[NSMutableArray alloc] initWithCapacity:[rows intValue] * [columns intValue]];
    
    return self;
}

-(int) arrayIndexForX:(int) x Y:(int) y {
    
}

@end
