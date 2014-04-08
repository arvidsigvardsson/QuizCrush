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
@property UIColor *buttonColor;
@property NSArray *buttonArray;

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

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) {
        return self;
    }
    
//    UIImage *image = [UIImage imageNamed:@"popup_alpha"];
//    UIImageView *iv = [[UIImageView alloc] initWithImage:image];
//    [self addSubview:iv];
    
    self.backgroundColor = /*[UIColor colorWithRed:10/255.0 green:246/255.0 blue:255/255.0 alpha:.9]; //*/ [UIColor colorWithWhite:.99 alpha:.97];
//    _popOver.layer.cornerRadius = 25;
//    _popOver.layer.masksToBounds = YES;
    self.layer.cornerRadius = 25;
    self.layer.masksToBounds = YES;
    
    float width = self.frame.size.width;
    float height = self.frame.size.height;
    float offset = 7;
    float buttonHeight = height * 3 / 10 - 2 * offset;
    float buttonWidth = width / 2 - 2 * offset;
    _buttonColor = [UIColor whiteColor]; //[UIColor greenColor]; //[UIColor colorWithRed:0.0f green:145.0 / 255.0f blue:178.0 / 255.0 alpha:1.0f];
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
    _button0.backgroundColor = _buttonColor;
//    _button0.titleLabel.textColor = textColor;
    [_button0 setTitleColor:textColor forState:UIControlStateNormal];
    _button0.layer.masksToBounds = YES;
    _button0.layer.cornerRadius = 15;
    _button0.layer.borderWidth = 2;
    _button0.layer.borderColor = [[UIColor colorWithWhite:.7 alpha:1] CGColor];
    _button0.tag = BUTTON_0;

    
    _button1 = [UIButton buttonWithType:UIButtonTypeSystem];
    _button1.frame = CGRectMake(width / 2 + offset, height * 0.4 + offset, buttonWidth, buttonHeight);
    _button1.titleLabel.numberOfLines = 0;
    _button1.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [_button1 setTitle:@"" forState:UIControlStateNormal];
//    [_button1 setTintColor:[UIColor blackColor]];
    _button1.backgroundColor = _buttonColor;
//    _button1.titleLabel.textColor = textColor;
    [_button1 setTitleColor:textColor forState:UIControlStateNormal];
    _button1.layer.masksToBounds = YES;
    _button1.layer.cornerRadius = 15;
    _button1.layer.borderWidth = 2;
    _button1.layer.borderColor = [[UIColor colorWithWhite:.7 alpha:1] CGColor];
    _button1.tag = BUTTON_1;
    
    _button2 = [UIButton buttonWithType:UIButtonTypeSystem];
    _button2.frame = CGRectMake(offset, height * 0.7 + offset, buttonWidth, buttonHeight);
    _button2.titleLabel.numberOfLines = 0;
    _button2.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [_button2 setTitle:@"" forState:UIControlStateNormal];
//    [_button2 setTintColor:[UIColor blackColor]];
    _button2.backgroundColor = _buttonColor;
//    _button2.titleLabel.textColor = textColor;
    [_button2 setTitleColor:textColor forState:UIControlStateNormal];
    _button2.layer.masksToBounds = YES;
    _button2.layer.cornerRadius = 15;
    _button2.layer.borderWidth = 2;
    _button2.layer.borderColor = [[UIColor colorWithWhite:.7 alpha:1] CGColor];
    _button2.tag = BUTTON_2;

    _button3 = [UIButton buttonWithType:UIButtonTypeSystem];
    _button3.frame = CGRectMake(width / 2 + offset, height * 0.7 + offset, buttonWidth, buttonHeight);
    _button3.titleLabel.numberOfLines = 0;
    _button3.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [_button3 setTitle:@"" forState:UIControlStateNormal];
//    [_button3 setTintColor:[UIColor blackColor]];
    _button3.backgroundColor = _buttonColor;
//    _button3.titleLabel.textColor = textColor;
    [_button3 setTitleColor:textColor forState:UIControlStateNormal];
    _button3.layer.masksToBounds = YES;
    _button3.layer.cornerRadius = 15;
    _button3.layer.borderWidth = 2;
    _button3.layer.borderColor = [[UIColor colorWithWhite:.7 alpha:1] CGColor];
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


    _buttonArray = @[_button0, _button1, _button2, _button3];
    
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

-(void) resetAndLoadQuestionStrings:(QCQuestion *) question {
    self.alpha = 1.0;
    for (UIButton *button in _buttonArray) {
        button.backgroundColor = _buttonColor;
    }
    
    NSArray *strings = [self.delegate questionStrings:question];
    
    [_topicLabel setText:strings[0]];
    [_questionLabel setText:strings[1]];
    [_button0 setTitle:strings[2] forState:UIControlStateNormal];
    [_button1 setTitle:strings[3] forState:UIControlStateNormal];
    [_button2 setTitle:strings[4] forState:UIControlStateNormal];
    [_button3 setTitle:strings[5] forState:UIControlStateNormal];
    
}

-(void) rightAnswerChosenWithIndex:(NSNumber *) index points:(NSNumber *)points {
    UIButton *button = _buttonArray[[index intValue]];
    button.backgroundColor = [UIColor colorWithRed:0.1 green:1 blue:0.1 alpha:.95];
    
    
    UILabel *pointsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, button.frame.size.width * 0.7, button.frame.size.width * 0.5)];
    pointsLabel.center = button.center;
    pointsLabel.text = [NSString stringWithFormat:@"%@p", points];
    pointsLabel.textAlignment = NSTextAlignmentCenter;
    pointsLabel.backgroundColor = [UIColor greenColor];
    pointsLabel.textColor = [UIColor whiteColor];
    pointsLabel.layer.cornerRadius = 15;
    pointsLabel.layer.masksToBounds = YES;
    
    [self addSubview:pointsLabel];
    
    [UIView animateWithDuration:1.5
                          delay:.2
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^ {
                         pointsLabel.center = CGPointMake(button.center.x, button.center.y - 100);
                         pointsLabel.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         self.hidden = YES;
                         [pointsLabel removeFromSuperview];
                         [self.delegate questionAnimationCompleted];
                     }
     ];
    
    
}

-(void) aboutToDismissPopup {
    [self.delegate dismissPopup];
}

-(void) wrongAnswerIndex:(NSNumber *) chosenIndex correctWasIndex:(NSNumber *) correctIndex {
    UIButton *chosenButton = _buttonArray[[chosenIndex intValue]];
    
    UIButton *correctButton = _buttonArray[[correctIndex intValue]];
    
    chosenButton.backgroundColor = [UIColor redColor];
    correctButton.backgroundColor = [UIColor greenColor];
    
    [UIView animateWithDuration:0.2
                          delay:1.15
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         self.hidden = YES;
                     }
     ];

    
}

@end
