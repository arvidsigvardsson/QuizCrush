//
//  QCTileImageProvider.h
//  QuizCrush
//
//  Created by Arvid on 2014-04-07.
//  Copyright (c) 2014 Planeto. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QCTileImageProvider : NSObject

-(UIView *) provideImageTileOfCategory:(NSNumber *) category frame:(CGRect) frame;

@end
