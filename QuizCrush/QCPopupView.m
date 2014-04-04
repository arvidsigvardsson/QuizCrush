//
//  QCGridView.m
//  NewTestViews
//
//  Created by Arvid on 2014-04-04.
//  Copyright (c) 2014 Planeto. All rights reserved.
//

#import "QCPopupView.h"

@interface QCPopupView ()

@property UILabel *topicLabel;
@property UILabel *questionLabel;
@property UIButton *button0;
@property UIButton *button1;
@property UIButton *button2;
@property UIButton *button3;

@end

@implementation QCPopupView

//static int BUTTON_0_TAG = 7575;
//static int BUTTON_1_TAG = 6253;
//static int BUTTON_2_TAG = 8797;
//static int BUTTON_3_TAG = 7892;

typedef enum {
    BUTTON_0,
    BUTTON_1,
    BUTTON_2,
    BUTTON_3
} BUTTON_NO;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        return self;
    }
    
//    UIImage *image = [UIImage imageNamed:@"popup_alpha"];
//    UIImageView *iv = [[UIImageView alloc] initWithImage:image];
//    [self addSubview:iv];
    
    self.backgroundColor = [UIColor colorWithWhite:.9 alpha:.97];
//    _popOver.layer.cornerRadius = 25;
//    _popOver.layer.masksToBounds = YES;
    self.layer.cornerRadius = 25;
    self.layer.masksToBounds = YES;
    
    float width = self.frame.size.width;
    float height = self.frame.size.height;
    float offset = 3;
    float buttonHeight = height * 3 / 10 - 2 * offset;
    float buttonWidth = width / 2 - 2 * offset;
    UIColor *buttonColor = [UIColor greenColor]; //[UIColor colorWithRed:0.0f green:145.0 / 255.0f blue:178.0 / 255.0 alpha:1.0f];
    UIColor *textColor = [UIColor blackColor];
    
    _topicLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, height * 0.05, width * 0.8, height * 0.1)];
    _topicLabel.textAlignment = NSTextAlignmentLeft;
//    myLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
    _topicLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    
    _questionLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, height * 0.12, width - 20, height * 0.25)];
    _questionLabel.textAlignment = NSTextAlignmentCenter;
    _questionLabel.numberOfLines = 0;
    _questionLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    [self addSubview:_topicLabel];
    [self addSubview:_questionLabel];
    
    
    
    _button0 = [UIButton buttonWithType:UIButtonTypeSystem];
    _button0.frame = CGRectMake(offset, height * 0.4 + offset, buttonWidth, buttonHeight);
    _button0.titleLabel.numberOfLines = 0;
    _button0.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [_button0 setTitle:@"" forState:UIControlStateNormal];
//    [_button0 setTintColor:[UIColor blackColor]];
    _button0.backgroundColor = buttonColor;
//    _button0.titleLabel.textColor = textColor;
    [_button0 setTitleColor:textColor forState:UIControlStateNormal];
    _button0.layer.masksToBounds = YES;
    _button0.layer.cornerRadius = 15;
    _button0.tag = BUTTON_0;

    
    _button1 = [UIButton buttonWithType:UIButtonTypeSystem];
    _button1.frame = CGRectMake(width / 2 + offset, height * 0.4 + offset, buttonWidth, buttonHeight);
    _button1.titleLabel.numberOfLines = 0;
    _button1.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [_button1 setTitle:@"" forState:UIControlStateNormal];
//    [_button1 setTintColor:[UIColor blackColor]];
    _button1.backgroundColor = buttonColor;
//    _button1.titleLabel.textColor = textColor;
    [_button1 setTitleColor:textColor forState:UIControlStateNormal];
    _button1.layer.masksToBounds = YES;
    _button1.layer.cornerRadius = 15;
    _button1.tag = BUTTON_1;
    
    _button2 = [UIButton buttonWithType:UIButtonTypeSystem];
    _button2.frame = CGRectMake(offset, height * 0.7 + offset, buttonWidth, buttonHeight);
    _button2.titleLabel.numberOfLines = 0;
    _button2.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [_button2 setTitle:@"" forState:UIControlStateNormal];
//    [_button2 setTintColor:[UIColor blackColor]];
    _button2.backgroundColor = buttonColor;
//    _button2.titleLabel.textColor = textColor;
    [_button2 setTitleColor:textColor forState:UIControlStateNormal];
    _button2.layer.masksToBounds = YES;
    _button2.layer.cornerRadius = 15;
    _button2.tag = BUTTON_2;

    _button3 = [UIButton buttonWithType:UIButtonTypeSystem];
    _button3.frame = CGRectMake(width / 2 + offset, height * 0.7 + offset, buttonWidth, buttonHeight);
    _button3.titleLabel.numberOfLines = 0;
    _button3.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [_button3 setTitle:@"" forState:UIControlStateNormal];
//    [_button3 setTintColor:[UIColor blackColor]];
    _button3.backgroundColor = buttonColor;
//    _button3.titleLabel.textColor = textColor;
    [_button3 setTitleColor:textColor forState:UIControlStateNormal];
    _button3.layer.masksToBounds = YES;
    _button3.layer.cornerRadius = 15;
    _button3.tag = BUTTON_3;

    
    [self addSubview:_button0];
    [self addSubview:_button1];
    [self addSubview:_button2];
    [self addSubview:_button3];
    
    [_button0 addTarget:self
                 action:@selector(buttonHandler:)
       forControlEvents:UIControlEventTouchUpInside];
    
    [_button1 addTarget:self
                action:@selector(buttonHandler:)
      forControlEvents:UIControlEventTouchUpInside];
    
    [_button2 addTarget:self
                action:@selector(buttonHandler:)
      forControlEvents:UIControlEventTouchUpInside];
    
    [_button3 addTarget:self
                 action:@selector(buttonHandler:)
       forControlEvents:UIControlEventTouchUpInside];


    return self;
}

-(void) buttonHandler:(id) sender {
    UIButton *button = (UIButton *) sender;
//    NSLog(@"Knapptyryck från %ld", button.tag);
    
    switch (button.tag) {
        case BUTTON_0: {
            [self.delegate answerButtonHandler:@0];
            break;
        }
        case BUTTON_1: {
            [self.delegate answerButtonHandler:@1];
            break;
        }
        case BUTTON_2: {
            [self.delegate answerButtonHandler:@2];
            break;
        }
        case BUTTON_3: {
            [self.delegate answerButtonHandler:@3];
            break;
        }
        default:
            break;
    }
    
}

-(void) loadQuestionStrings {
    NSArray *strings = [self.delegate questionStrings];
    
    [_topicLabel setText:strings[0]];
    [_questionLabel setText:strings[1]];
    [_button0 setTitle:strings[2] forState:UIControlStateNormal];
    [_button1 setTitle:strings[3] forState:UIControlStateNormal];
    [_button2 setTitle:strings[4] forState:UIControlStateNormal];
    [_button3 setTitle:strings[5] forState:UIControlStateNormal];
    
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
