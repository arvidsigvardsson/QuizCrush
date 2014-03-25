//
//  QCTile.m
//  QuizCrush
//
//  Created by Arvid on 2014-03-17.
//  Copyright (c) 2014 Planeto. All rights reserved.
//

#import "QCTile.h"

@implementation QCTile

//@synthesize category = _category;
//@synthesize id = _id;

-(id) initWithCategory:(NSNumber *)category iD:(NSNumber *)iD {
    if(self = [super init]){
        _category = category;
        _iD = iD;
        _hasBeenMoved = NO;
    }
    return self;
}

-(id) initWithCategory:(NSNumber *) category iD:(NSNumber *) iD x:(NSNumber *) x y:(NSNumber *) y {
    if(self = [super init]){
        _category = category;
        _iD = iD;
        _x = x;
        _y = y;
        _xDuringMotion = x;
        _yDuringMotion = y;
        _hasBeenMoved = NO;
    }
    return self;

}


@end
