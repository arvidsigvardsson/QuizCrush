//
//  QCSlimeModel.h
//  QuizCrush
//
//  Created by Arvid on 2014-05-15.
//  Copyright (c) 2014 Planeto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QCCoordinates.m"

@interface QCSlimeModel : NSObject

//@property (nonatomic) NSMutableDictionary *slimeDict;
@property (nonatomic) NSMutableArray *slimeArray;

-(id) initWithRows:(NSNumber *) rows Columns:(NSNumber *) columns markedPositions:(NSArray *) markedArray;

@end
