//
//  QCCoordinates.h
//  QuizCrush
//
//  Created by Arvid on 2014-05-15.
//  Copyright (c) 2014 Planeto. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QCCoordinates : NSObject

@property (nonatomic) int x;
@property (nonatomic) int y;

-(id) initWithX:(int) x Y:(int) y;

@end
