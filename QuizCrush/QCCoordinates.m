//
//  QCCoordinates.m
//  QuizCrush
//
//  Created by Arvid on 2014-05-15.
//  Copyright (c) 2014 Planeto. All rights reserved.
//

#import "QCCoordinates.h"

@implementation QCCoordinates

-(id) initWithX:(NSNumber *) x Y:(NSNumber *) y {
    if (!(self = [super init])) {
        return self;
    }
    _x = x;
    _y = y;
    return self;
}
-(BOOL) isEqualToCoordinates:(QCCoordinates *) coordinates {
    if (!coordinates) {
        return NO;
    }
    
    BOOL haveEqualX = (!self.x && !coordinates.x) || [self.x isEqualToNumber:coordinates.x];
    BOOL haveEqualY = (!self.y && !coordinates.y) || [self.y isEqualToNumber:coordinates.y];
    
    return haveEqualX && haveEqualY;
}

-(BOOL) isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    if (![object isKindOfClass:[QCCoordinates class]]) {
        return NO;
    }
    return [self isEqualToCoordinates:(QCCoordinates *)object];
}

-(NSUInteger) hash {
    return [self.x hash] ^ [self.y hash];
}

@end
