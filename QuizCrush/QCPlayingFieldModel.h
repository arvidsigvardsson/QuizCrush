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

-(id) initWithNumberOfRowsAndColumns:(NSNumber *) rowsAndCols;
-(NSSet *) matchingAdjacentTilesToTileWithID:(NSNumber *) iD;
-(NSNumber *) categoryOfTileWithID:(NSNumber *) ID;
-(NSNumber *) iDOfTileAtX:(NSNumber *) x Y:(NSNumber *) y;
-(QCTile *) tileWithID:(NSNumber *) iD;
-(NSDictionary *) removeAndReturnVerticalTranslations:(NSSet *) removeSet;
-(NSSet *) getNewTilesReplacing:(NSSet *) set;
-(BOOL) tilesAreAdjacentID1:(NSNumber *) tile1ID ID2:(NSNumber *) tile2ID;
-(QCMoveDescription *) takeOneStepAndReturnMoveForID:(NSNumber *) tileID InDirection:(NSString *) direction;
-(NSDictionary *) positionOneStepFromID:(NSNumber *) ID inDirection:(NSString *) direction;
-(NSString *) directionFromID:(NSNumber *) IDStart toID:(NSNumber *) IDEnd;
-(void) deleteTiles:(NSSet *) IDsToDelete;
-(void) updateModelWithMoves:(NSArray *) moveArray;
-(void) swipeWasAbortedWithMoves:(NSArray *) moveArray;
-(QCSuctionMove *) takeFirstSuctionStepFrom:(NSNumber *) startID inDirection:(NSString *) direction;
-(QCSuctionMove *) takeNewSuctionStepWithMove:(QCSuctionMove *) suctionMove inDirection:(NSString *) direction;

@end
