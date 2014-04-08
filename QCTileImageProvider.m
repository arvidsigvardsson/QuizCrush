//
//  QCTileImageProvider.m
//  QuizCrush
//
//  Created by Arvid on 2014-04-07.
//  Copyright (c) 2014 Planeto. All rights reserved.
//

#import "QCTileImageProvider.h"

@implementation QCTileImageProvider

-(UIView *) provideImageTileOfCategory:(NSNumber *) category frame:(CGRect) frame {
    NSDictionary *dict = @{@0 : @"entertainment",
                           @1 : @"geography",
                           @2 : @"history",
                           @3 : @"arts",
                           @4 : @"science",
                           @5 : @"sports",
                           @7 : @"bomb"};
    
    UIImage *image = [UIImage imageNamed:dict[category]];
    UIImageView *view = [[UIImageView alloc] initWithImage:image];
    view.frame = frame;
    view.contentMode = UIViewContentModeScaleAspectFit;
    view.clipsToBounds = YES;
    return view;
}
@end
