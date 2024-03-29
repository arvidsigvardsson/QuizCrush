//
//  QCMoveDescription.h
//  QuizCrush
//
//  Created by Arvid on 2014-03-21.
//  Copyright (c) 2014 Planeto. All rights reserved.
//

// Class with objects that describe ONE movement of tiles: an ID for the new tile created, an ID for the tile to be deleted, and a dictionary for which direction tiles move (including the newly created tiles

#import <Foundation/Foundation.h>

@interface QCMoveDescription : NSObject
-(id) init;
@property NSMutableDictionary *moveDict;
@property NSNumber *createdTileID;
@property NSNumber *tileToDelete;
@property NSString *direction;

@end
