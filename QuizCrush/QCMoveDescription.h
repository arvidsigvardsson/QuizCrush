//
//  QCMoveDescription.h
//  QuizCrush
//
//  Created by Arvid on 2014-03-21.
//  Copyright (c) 2014 Planeto. All rights reserved.
//

// Class with objects that describe ONE movement of tiles: a dictionary for new tiles and a dictionary for which direction tiles move (including the newly created tiles

#import <Foundation/Foundation.h>

@interface QCMoveDescription : NSObject

@property NSMutableDictionary *moveDict;
@property NSMutableDictionary *newTilesDict;

@end
