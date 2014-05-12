//
//  QCTileHolderView.h
//  QuizCrush
//
//  Created by Arvid on 2014-05-08.
//  Copyright (c) 2014 Planeto. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QCTileHolderView : UIView

-(void) drawLineFromX1:(float) x1 Y1:(float) y1 X2:(float) x2 Y2:(float) y2;

-(void) removeAllLines;
@end
