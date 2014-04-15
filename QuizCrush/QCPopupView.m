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
@property UIImageView *categoryView;
@property UIButton *fiftyButton;
@property UILabel *fiftyXLabel;

//@property UIImageView *categoryView;

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
    
    _categoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 45, 45)];  //initWithImage:[self.delegate provideCategoryImage]];
    //    categoryView.image = [self.delegate provideCategoryImage];
    _categoryView.center = CGPointMake(self.frame.size.width * 0.10, self.frame.size.height * 0.08);
    [self addSubview:_categoryView];
    
    
    
    _topicLabel = [[UILabel alloc] initWithFrame:CGRectMake(width * 0.2, height * 0.04, width * 0.8, height * 0.1)];
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
    _button0.titleEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    _button0.titleLabel.textAlignment = NSTextAlignmentCenter;
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
    _button1.titleEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    _button1.titleLabel.textAlignment = NSTextAlignmentCenter;
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
    _button2.titleEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    _button2.titleLabel.textAlignment = NSTextAlignmentCenter;
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
    _button3.titleEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    _button3.titleLabel.textAlignment = NSTextAlignmentCenter;
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
    
    
//    _categoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arts"]];
//    _categoryView = [[UIImageView alloc] init];
//    _categoryView.center = CGPointMake(self.frame.size.width * 0.87, self.frame.size.height * 0.1);
//    
//    [self addSubview:_categoryView];
//
    
    // 50/50
    UIImage *fiftyImage = [UIImage imageNamed:@"fifty"];
    _fiftyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _fiftyButton.frame = CGRectMake(0, 0, self.frame.size.width * 0.13, self.frame.size.width * 0.13);
    _fiftyButton.center = CGPointMake(self.frame.size.width * 0.75, self.frame.size.height * 0.1);
    
    [_fiftyButton setBackgroundImage:fiftyImage forState:UIControlStateNormal];
    _fiftyButton.hidden = YES;
    
    [_fiftyButton addTarget:self
                    action:@selector(fiftyButtonHandler:)
          forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_fiftyButton];

    _fiftyXLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width * 0.1, self.frame.size.width * 0.13)];
    _fiftyXLabel.center = CGPointMake(self.frame.size.width * 0.90, self.frame.size.height * 0.1);
//    _fiftyXLabel.text = @"X 2";
    _fiftyXLabel.hidden = YES;
    [self addSubview:_fiftyXLabel];
    
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

-(void) resetAndLoadQuestionStrings:(QCQuestion *) question withFiftyFifty:(NSNumber *) numberOfFiftyFifty {
    self.alpha = 1.0;
    for (UIButton *button in _buttonArray) {
        button.backgroundColor = _buttonColor;
        button.hidden = NO;
        button.alpha = 1;
    }
    
    NSArray *strings = [self.delegate questionStrings:question];
    
    [_topicLabel setText:strings[0]];
    [_questionLabel setText:strings[1]];
    [_button0 setTitle:strings[2] forState:UIControlStateNormal];
    [_button1 setTitle:strings[3] forState:UIControlStateNormal];
    [_button2 setTitle:strings[4] forState:UIControlStateNormal];
    [_button3 setTitle:strings[5] forState:UIControlStateNormal];
    
//    UIImageView *categoryView = [[UIImageView alloc] initWithImage:[self.delegate provideCategoryImage]];
////    categoryView.image = [self.delegate provideCategoryImage];
//    categoryView.center = CGPointMake(self.frame.size.width * 0.10, self.frame.size.height * 0.08);
//    [self addSubview:categoryView];
    
    [_categoryView setImage:[self.delegate provideCategoryImage]];

    if ([numberOfFiftyFifty intValue] >= 2) {
        _fiftyButton.hidden = NO;
        _fiftyXLabel.hidden = NO;
        _fiftyXLabel.text = [NSString stringWithFormat:@"X %@", numberOfFiftyFifty];
    }
    else if ([numberOfFiftyFifty intValue] == 1) {
        _fiftyButton.hidden = NO;
        _fiftyXLabel.hidden = YES;
    }
    else if ([numberOfFiftyFifty intValue] <= 0) {
        _fiftyButton.hidden = YES;
        _fiftyXLabel.hidden = YES;
    }
    
    //if (fiftyFifty) {
//        UIImage *fiftyImage = [UIImage imageNamed:@"fifty"];
//        UIButton *fiftyButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        fiftyButton.frame = CGRectMake(0, 0, self.frame.size.width * 0.13, self.frame.size.width * 0.13);
//        fiftyButton.center = CGPointMake(self.frame.size.width * 0.87, self.frame.size.height * 0.1);
//        
//        [fiftyButton setBackgroundImage:fiftyImage forState:UIControlStateNormal];
//        [fiftyButton addTarget:self
//                        action:@selector(fiftyButtonHandler:)
//              forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:fiftyButton];
//    }

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
                          delay:1.0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         self.hidden = YES;
                         [self.delegate questionAnimationCompleted];
                     }
     ];

    
}

-(void) fiftyButtonHandler:(id) sender {
//    UIButton * button = (UIButton *) sender;
//    button.enabled = NO;
//    [button removeFromSuperview];
    [self.delegate decreaseFiftyFifty];
    
    NSSet *set = [self.delegate answerButtonsToDisableFiftyFifty];
    
    [UIView animateWithDuration:0.1
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         for (NSNumber *index in set) {
                             [_buttonArray[[index intValue]] setAlpha:0];
                         }

                     }
                     completion:^(BOOL completion) {
                         for (NSNumber *index in set) {
                             [_buttonArray[[index intValue]] setHidden:YES];
                         }
                     }
     ];
    
    
    
}


@end
