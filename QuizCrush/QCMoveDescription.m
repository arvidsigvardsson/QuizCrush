//
//  QCMoveDescription.m
//  QuizCrush
//
//  Created by Arvid on 2014-03-21.
//  Copyright (c) 2014 Planeto. All rights reserved.
//

#import "QCMoveDescription.h"

@implementation QCMoveDescription

-(id) init {
    if(!(self = [super init])){
        return self;
    }
    
    _moveDict = [[NSMutableDictionary alloc] init];
    _createdTileID = [[NSNumber alloc] init];
    _tileToDelete = [[NSNumber alloc] init];
    
    return self;
}

-(NSString *) description {
    return [NSString stringWithFormat:@"Move object, moveDict: %@, new item: %@, deleted item: %@", _moveDict, _createdTileID, _tileToDelete];
}
@end
