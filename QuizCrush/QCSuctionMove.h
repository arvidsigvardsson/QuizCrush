//
//  QCSuctionMoveClass.h
//  QuizCrush
//
//  Created by Arvid on 2014-03-26.
//  Copyright (c) 2014 Planeto. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QCSuctionMove : NSObject

@property NSMutableArray *tailArray;
@property NSMutableDictionary *movementDict;
@property NSNumber *deletedTile;
@property NSNumber *createdTile;
@end
