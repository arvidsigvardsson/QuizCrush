//
//  QCCoordinates.h
//  QuizCrush
//
//  Created by Arvid on 2014-05-15.
//  Copyright (c) 2014 Planeto. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QCCoordinates : NSObject

@property (nonatomic) NSNumber *x;
@property (nonatomic) NSNumber *y;

-(id) initWithX:(NSNumber *) x Y:(NSNumber *) y;
-(BOOL) isEqualToCoordinates:(QCCoordinates *) coordinates;

@end
