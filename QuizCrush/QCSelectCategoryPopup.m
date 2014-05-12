//
//  QCSelectCategoryPopup.m
//  TestCategoryPopup
//
//  Created by Arvid on 2014-04-11.
//  Copyright (c) 2014 Planeto. All rights reserved.
//

#import "QCSelectCategoryPopup.h"

@interface QCSelectCategoryPopup ()

@property NSArray *buttonIdentity;

@end

@implementation QCSelectCategoryPopup


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    _buttonIdentity = @[@"entertainment",
                        @"geography",
                        @"history",
                        @"arts",
                        @"science",
                        @"sports",
                        @"bomb"];
    
    self.layer.cornerRadius = 25;
    self.layer.masksToBounds = YES;
    float width = self.frame.size.width;
    float height = self.frame.size.height;

    self.backgroundColor = [UIColor colorWithWhite:1 alpha:0.9]; //0.97];
    
    UIImageView *headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width * 0.2, width * 0.2)];
    headerView.center = CGPointMake(width / 2, height * 0.17);
    headerView.image = [UIImage imageNamed:@"color-wheel"];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, height / 6)];
    label.center = CGPointMake(width / 2, height / 3);
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"Select a category";
    [self addSubview:label];
    
    [self addSubview:headerView];
    
    for (int i = 0; i < [_buttonIdentity count]; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, width * 0.25, width * 0.25);
        button.center = CGPointMake(width * ((i % 3) * 2 + 1) / 6, height / 2 + (i / 3) * height / 3);
        [button setImage:[UIImage imageNamed:_buttonIdentity[i]] forState:UIControlStateNormal];
        button.tag = i;
        [button addTarget:self action:@selector(buttonHandler:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
    
    
    return self;
}


-(void) buttonHandler:(id) sender {
    UIButton *button = (UIButton *) sender;
//    NSLog(@"Tag: %ld", button.tag);
    
    [self.delegate selectCategoryButtonHandler:@(button.tag)];
}

@end
