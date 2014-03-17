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

-(id) initWithCategory:(int)category ID:(int)id {
    if(self = [super init]){
        _category = category;
        _id = id;
    }
    return self;
}

@end
