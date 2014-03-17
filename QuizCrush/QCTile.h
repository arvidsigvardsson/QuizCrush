//
//  QCTile.h
//  QuizCrush
//
//  Created by Arvid on 2014-03-17.
//  Copyright (c) 2014 Planeto. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QCTile : NSObject

@property NSNumber *category;
@property NSNumber *iD;

-(id) initWithCategory:(NSNumber *) category iD:(NSNumber *) id;

@end
