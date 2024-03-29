//
//  QCPlayingFieldModel.h
//  QuizCrush
//
//  Created by Arvid on 2014-03-17.
//  Copyright (c) 2014 Planeto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QCTile.h"
#import "QCMoveDescription.h"
#import "QCSuctionMove.h"

@interface QCPlayingFieldModel : NSObject

typedef enum {
    UP,
    DOWN,
    LEFT,
    RIGHT,
    NO_DIRECTION
} Direction;

-(NSDictionary *) returnPlayingField;
-(id) initWithNumberOfRowsAndColumns:(NSNumber *) rowsAndCols;
-(id) initWithRows:(NSNumber *) numberOfRows Columns:(NSNumber *) numberOfColumns;
-(id) initWithRows:(NSNumber *) numberOfRows Columns:(NSNumber *) numberOfColumns levelDocument:(NSString *) document;
-(id) initWithAvatarRows:(NSNumber *) numberOfRows Columns:(NSNumber *) numberOfColumns;
-(NSSet *) matchingAdjacentTilesToTileWithID:(NSNumber *) iD;
-(NSNumber *) categoryOfTileWithID:(NSNumber *) ID;
-(NSNumber *) iDOfTileAtX:(NSNumber *) x Y:(NSNumber *) y;
-(NSNumber *) IDOfTileDuringMotionAtX:(NSNumber *) x Y:(NSNumber *) y;
-(QCTile *) tileWithID:(NSNumber *) iD;
-(NSDictionary *) removeAndReturnVerticalTranslations:(NSSet *) removeSet;
-(NSSet *) getNewTilesReplacing:(NSSet *) set
              excludingCategory:(NSNumber *) excludeCategory
                    withBooster:(NSNumber *) booster;
-(BOOL) tilesAreAdjacentID1:(NSNumber *) tile1ID ID2:(NSNumber *) tile2ID;
-(QCMoveDescription *) takeOneStepAndReturnMoveForID:(NSNumber *) tileID
                                         InDirection:(NSString *) direction;
-(NSDictionary *) positionOneStepFromID:(NSNumber *) ID inDirection:(NSString *) direction;
-(NSString *) directionFromID:(NSNumber *) IDStart toID:(NSNumber *) IDEnd;
-(void) deleteTiles:(NSSet *) IDsToDelete;
-(void) updateModelWithMoves:(NSArray *) moveArray;
-(void) swipeWasAbortedWithMoves:(NSArray *) moveArray;
-(QCSuctionMove *) takeFirstSuctionStepFrom:(NSNumber *) startID inDirection:(NSString *) direction;
-(QCSuctionMove *) takeNewSuctionStepFromID:(NSNumber *) startID WithMove:(QCSuctionMove *) suctionMove
                                inDirection:(NSString *) direction;
-(void) suctionSwipeWasAbortedWithMoves:(NSArray *) moveArray;
-(void) updateModelWithSuctionMoves:(NSArray *) moves;
-(NSNumber *) changeHeadOfSnakeToBoosterAndReturnItForMove:(QCSuctionMove *) move;
-(void) changeToBoosterForID:(NSNumber *) ID;
-(void) changeTiles:(NSSet *)set toCategory:(NSNumber *) category;
-(void) swapPositionsOfTile:(NSNumber *) firstID
                    andTile:(NSNumber *) secondID;
-(void) switchTileToAvatar:(NSNumber *) ID;
-(NSNumber *) IDOfAvatar;
-(Direction) enumDirectionFromID:(NSNumber *) IDStart toID:(NSNumber *) IDEnd;
-(BOOL) tilesAreLinkedID1:(NSNumber *) tile1ID ID2:(NSNumber *) tile2ID;

@end
