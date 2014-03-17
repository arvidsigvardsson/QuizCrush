//
//  QCTile.h
//  QuizCrush
//
//  Created by Arvid on 2014-03-17.
//  Copyright (c) 2014 Planeto. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QCTile : NSObject

@property int category;
@property int iD;

-(id) initWithCategory:(int) category iD:(int) id;

@end
