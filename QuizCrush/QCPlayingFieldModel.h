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


@interface QCPlayingFieldModel : NSObject

-(id) initWithNumberOfRowsAndColumns:(NSNumber *) rowsAndCols;
-(NSSet *) matchingAdjacentTilesToTileWithID:(NSNumber *) iD;
-(NSNumber *) categoryOfTileWithID:(NSNumber *) ID;
-(NSNumber *) iDOfTileAtX:(NSNumber *) x Y:(NSNumber *) y;
-(QCTile *) tileWithID:(NSNumber *) iD;
-(NSDictionary *) removeAndReturnVerticalTranslations:(NSSet *) removeSet;
-(NSSet *) getNewTilesReplacing:(NSSet *) set;
-(BOOL) tilesAreAdjacentID1:(NSNumber *) tile1ID ID2:(NSNumber *) tile2ID;

@end
