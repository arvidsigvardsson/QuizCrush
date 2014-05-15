//
//  QCSlimeModel.h
//  QuizCrush
//
//  Created by Arvid on 2014-05-15.
//  Copyright (c) 2014 Planeto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QCCoordinates.h"

@interface QCSlimeModel : NSObject

@property (nonatomic) int rows;
@property (nonatomic) int columns;
//@property (nonatomic) NSMutableDictionary *slimeDict;
//@property (nonatomic) NSMutableArray *slimeArray;
@property (nonatomic) NSMutableSet *slimeSet;

-(id) initWithRows:(NSNumber *) rows Columns:(NSNumber *) columns markedPositions:(NSArray *) markedArray;

@end
