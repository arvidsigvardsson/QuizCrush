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

-(id) initWithNumberOfRowsAndColumns:(int) rowsAndCols;
-(int) categoryOfTileAtPosition:(int) position;
-(int) categoryOfTileWithID:(int) ID;
-(int) iDOfTileAtPosition:(int) position;

@end
