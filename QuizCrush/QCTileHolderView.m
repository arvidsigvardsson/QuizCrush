//
//  QCTileHolderView.m
//  QuizCrush
//
//  Created by Arvid on 2014-05-08.
//  Copyright (c) 2014 Planeto. All rights reserved.
//

#import "QCTileHolderView.h"

@interface QCTileHolderView ()

@property (nonatomic) NSMutableArray *coordinates;

@end

@implementation QCTileHolderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
//    NSLog(@"Draw rect, coordinates: %@", _coordinates);
    if (!_coordinates) {
        return;
    }
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    
    // Draw them with a 2.0 stroke width so they are a bit more visible.
    CGContextSetLineWidth(context, 4.0);
    
    for (int i = 0; i < [_coordinates count]; i += 4) {
        CGContextMoveToPoint(context, [_coordinates[i] floatValue], [_coordinates[i + 1] floatValue]); //start at this point
        
        CGContextAddLineToPoint(context, [_coordinates[i + 2] floatValue], [_coordinates[i + 3] floatValue]); //draw to this point
        
        // and now draw the Path!
        CGContextStrokePath(context);
        
    }
}

-(void) drawLineFromX1:(float) x1 Y1:(float) y1 X2:(float) x2 Y2:(float) y2 {
    if (!_coordinates) {
        _coordinates = [[NSMutableArray alloc] init];
    }

    [_coordinates addObjectsFromArray:@[@(x1), @(y1), @(x2), @(y2)]];
    [self setNeedsDisplay];
}

-(void) removeAllLines {
    [_coordinates removeAllObjects];
    [self setNeedsDisplay];
}

@end
