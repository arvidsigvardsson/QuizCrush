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
@property int id;

-(id) initWithCategory:(int) category ID:(int) id;

@end
