//
//  QCPlayingFieldModel.h
//  QuizCrush
//
//  Created by Arvid on 2014-03-17.
//  Copyright (c) 2014 Planeto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QCTile.h"

@interface QCPlayingFieldModel : NSObject

-(id) initWithNumberOfRowsAndColumns:(NSNumber *) rowsAndCols;
-(NSNumber *) categoryOfTileAtPosition:(NSNumber *) position;
-(NSSet *) matchingAdjacentTilesToTileAtPosition:(NSNumber *) position;
-(NSNumber *) categoryOfTileWithID:(NSNumber *) ID;
-(NSNumber *) iDOfTileAtPosition:(NSNumber *) position;
-(NSNumber *) iDOfTileAtX:(NSNumber *) x Y:(NSNumber *) y;


@end
