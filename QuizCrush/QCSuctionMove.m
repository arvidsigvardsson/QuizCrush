//
//  QCSuctionMoveClass.m
//  QuizCrush
//
//  Created by Arvid on 2014-03-26.
//  Copyright (c) 2014 Planeto. All rights reserved.
//

#import "QCSuctionMove.h"

@implementation QCSuctionMove

-(id) init {
    if(!(self = [super init])){
        return self;
    }
    
    _tailArray = [[NSMutableArray alloc] init];
    _movementDict = [[NSMutableDictionary alloc] init];
    _deletedTile = [[NSNumber alloc] init];
    _createdTile = [[NSNumber alloc] init];
    _creationSiteX = [[NSNumber alloc] init];
    _creationSiteY = [[NSNumber alloc] init];
    
    return self;
}

-(NSString *) description {
    return [NSString stringWithFormat:@"SuctionMoveObject, tailArray: %@, movementDict: %@, deletedTile: %@, createdTile: %@, creationSite (x,y): (%@,%@)", _tailArray, _movementDict, _deletedTile, _createdTile, _creationSiteX, _creationSiteY];
}

@end
