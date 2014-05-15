//
//  QCCoordinates.m
//  QuizCrush
//
//  Created by Arvid on 2014-05-15.
//  Copyright (c) 2014 Planeto. All rights reserved.
//

#import "QCCoordinates.h"

@implementation QCCoordinates

-(id) initWithX:(int) x Y:(int) y {
    if (!(self = [super init])) {
        return self;
    }
    _x = x;
    _y = y;
    return self;
}

@end
