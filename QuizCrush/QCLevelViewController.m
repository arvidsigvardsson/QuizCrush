//
//  QCLevelViewController.m
//  QuizCrush
//
//  Created by Arvid on 2014-03-17.
//  Copyright (c) 2014 Planeto. All rights reserved.
//

#import "QCLevelViewController.h"

@interface QCLevelViewController ()

typedef enum {
    BOMB,
    CHANGE_CAT,
    NONE
} BoosterState;
@property BoosterState boosterState;

@property (weak, nonatomic) IBOutlet UIView *holderView;
//@property NSMutableArray *viewArray;
//@prperty (weak, nonatomic) IBOutlet UIView *popup;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *movesLeftLabel;

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
//@property UIView *popOver;

@property QCPopupView *popView;
@property QCSelectCategoryPopup *selectCategoryPopup;

@property QCQuestionProvider *questionProvider;
@property QCTileImageProvider *imageProvider;

@property QCQuestion *currentQuestion;

@property NSMutableDictionary *viewDictionary;
@property NSDictionary *uiSettingsDictionary;
@property QCPlayingFieldModel *playingFieldModel;
@property float lengthOfTile;
//@property NSNumber *noRowsAndCols;
@property NSNumber *numberOfRows;
@property NSNumber *numberOfColumns;
@property NSArray *colorArray;
@property NSNumber *tilesRequiredToMatch;
@property BOOL animating;
@property BOOL validSwipe;
@property NSMutableSet *tilesTouched;
@property NSSet *matchingTiles;
@property NSNumber *currentTileTouched;
@property NSMutableArray *moveArray;
@property NSString *moveDirection;
@property NSMutableArray *suctionMoveArray;
@property BOOL popOverIsActive;
@property NSNumber *selectedBoosterTile;
@property NSUInteger score;
@property int numberOfMovesMade;
@property BOOL answerWasCorrect;
@property int numberOfFiftyFiftyBoosters;
@property CGRect popupFrame;
@property BOOL bombBoosterIsActive;
@property BOOL changeCategoryBoosterIsActive;
@property NSNumber *tileToChangeCategoryOf;
//@property UIButton *fiftyFiftyButton;
@property (weak, nonatomic) IBOutlet UIButton *fiftyFiftyButton;
- (IBAction)fiftyFiftyButtonHandler:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *fiftyXLabel;
@property BOOL fiftyUsed;
//@property NSMutableArray *avatarMovement;
@property int animatingCount;

@end

@implementation QCLevelViewController

// delegate methods

-(void) selectCategoryButtonHandler:(NSNumber *) category {
    // I think this belongs here...
    _changeCategoryBoosterIsActive = NO;
    
    
//    NSLog(@"Kategori vald: %@", category);
    NSSet *selectionSet = [_playingFieldModel matchingAdjacentTilesToTileWithID:_tileToChangeCategoryOf];
    
    [self deleteTheBoosterTile:_selectedBoosterTile excludingCategory:[_playingFieldModel categoryOfTileWithID:_tileToChangeCategoryOf]];
    
    [_playingFieldModel changeTiles:selectionSet toCategory:category];
    
    _selectCategoryPopup.hidden = YES;
    // change views of tiles
    
//    NSMutableSet *oldViews = [[NSMutableSet alloc] init];
//    NSMutableSet *newViews = [[NSMutableSet alloc] init];
    NSMutableDictionary *oldViews = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *newViews = [[NSMutableDictionary alloc] init];
    for (NSNumber *key in selectionSet) {
        QCTile *tile = [_playingFieldModel tileWithID:key];
        UIView *oldView = _viewDictionary[key];
        UIView *newView = [self tileViewCreatorXIndex:[tile.x intValue]
                                               yIndex:[tile.y intValue]
                                                   iD:key];
        newView.alpha = 0;
        [_holderView addSubview:newView];
//        [oldViews addObject:oldView];
//        [newViews addObject:newView];
        [oldViews setObject:oldView forKey:key];
        [newViews setObject:newView forKey:key];
    }
    
    [UIView animateWithDuration:0.8
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         for (NSNumber *animateKey in oldViews) {
                             [oldViews[animateKey] setAlpha:0];
                             [newViews[animateKey] setAlpha:1];
                         }
                     }
                     completion:^(BOOL finished) {
                         for (NSNumber *delKey in oldViews) {
                             [oldViews[delKey] removeFromSuperview];
                             [_viewDictionary removeObjectForKey:delKey];
                             [_viewDictionary setObject:newViews[delKey] forKey:delKey];
                             _popOverIsActive = NO;
                             
                         }
                     }
     ];
    
    
//        [oldView removeFromSuperview];
//        [_viewDictionary removeObjectForKey:key];
//        [_viewDictionary setObject:newView forKey:key];
//        [_holderView addSubview:newView];
//    }
    
}

-(NSArray *) questionStrings:(QCQuestion *) question {
//    return nil;
    return @[question.topic,
             question.questionString,
             question.answers[0],
             question.answers[1],
             question.answers[2],
             question.answers[3],
             question.correctAnswerIndex];

}

-(UIImage *) provideCategoryImage{
    
//    return [UIImage imageNamed:@"arts"];
    
    
    NSDictionary *dict = @{@0 : @"entertainment",
                           @1 : @"geography",
                           @2 : @"history",
                           @3 : @"arts",
                           @4 : @"science",
                           @5 : @"sports",
                           @7 : @"bomb"};
    
    UIImage *image = [UIImage imageNamed:dict[_currentQuestion.category]];
    return image;
}

- (void)updateMovesLeftLabel {
    _movesLeftLabel.text = [NSString stringWithFormat:@"%d", [_uiSettingsDictionary[@"Max number of moves"] intValue] - _numberOfMovesMade];
}

-(void) answerButtonHandler:(NSNumber *)index {
    [self unMarkTiles:_tilesTouched];
    _popOverIsActive = NO;


    _numberOfMovesMade += 1;
    [self updateMovesLeftLabel];
    NSLog(@"Knapp nr: %@", index);
    if ([index isEqualToNumber:_currentQuestion.correctAnswerIndex]) {
        [self playerAnsweredCorrect];
//        [_popView rightAnswerChosenWithIndex:index points:@(-1)];
    } else {
        [self playerAnsweredWrong];
        [_popView wrongAnswerIndex:index correctWasIndex:_currentQuestion.correctAnswerIndex];
    }



//    _popView.hidden = YES;
}

-(void) dismissPopup {
    _popView.hidden = YES;
}

-(void) questionAnimationCompleted {
//    if (_numberOfFiftyFiftyBoosters >= 1) {
//        _fiftyFiftyButton.hidden = NO;
//    }
    
    
    NSNumber *booster = nil;
    if (_answerWasCorrect) {
        if ([_tilesTouched count] >= 5) {
            booster = @8;
        } else if ([_tilesTouched count] == 4) {
            _numberOfFiftyFiftyBoosters += 1;
        } else if ([_tilesTouched count] == 3) {
            booster = @7;
        }
    }
    
    // not sure if this should be here...
    _fiftyUsed = NO;
    [self updateFiftyButtonState];
    
//    [self swipeDeleteTiles:_tilesTouched withBooster:booster];
//    [self swipeFallingDeleteTiles:_tilesTouched withBooster:booster];
    [self deleteFallingTilesWithSpringForSet:_tilesTouched withBooster:booster];
}

-(NSSet *) answerButtonsToDisableFiftyFifty {
    NSMutableSet *set = [NSMutableSet setWithArray:@[@0, @1, @2, @3]];
    [set removeObject:_currentQuestion.correctAnswerIndex];
    
    NSMutableArray *array = (NSMutableArray *) [set allObjects];
    
    int randomIndex = arc4random_uniform((u_int32_t)[array count]);
    NSNumber *removeNumber = array[randomIndex];
    [set removeObject:removeNumber];
    
    //    [array removeObjectAtIndex:randomIndex];
    
    
    
    return set;
}

-(void) decreaseFiftyFifty {
    _numberOfFiftyFiftyBoosters -= 1;
}

-(void) deleteFallingTilesWithSpringForSet:(NSSet *) selectionSet withBooster:(NSNumber *) booster {
    NSSet *newTiles = [_playingFieldModel getNewTilesReplacing:selectionSet excludingCategory:nil withBooster:booster];
    
    for (NSNumber *addNewKey in newTiles) {
        QCTile *newTile = [_playingFieldModel tileWithID:addNewKey];
        int x = [newTile.x intValue];
        int y = [newTile.y intValue];
        
        UIView *newView = [self tileViewCreatorXIndex:x yIndex:y iD:addNewKey];
        [_viewDictionary setObject:newView
                            forKey:addNewKey];
        [_holderView addSubview:newView];
    }
    
    
    // dict with ids of tiles to move, with their corresponding moves
    NSDictionary *animateDict = [_playingFieldModel removeAndReturnVerticalTranslations:selectionSet];
    
    for (NSNumber *key in selectionSet) {
        UIView * view = _viewDictionary[key];
        //        [view setBackgroundColor:[UIColor blackColor]];
        [view removeFromSuperview];
        [_viewDictionary removeObjectForKey:key];
    }
    
    _animating = YES;
    
    _animatingCount = (int)[animateDict count];
    
    double delay = 0;
    double duration = 0.7;
    
    for (NSNumber *animateKey in animateDict) {
        float steps = [animateDict[animateKey] floatValue];
        UIView *view = _viewDictionary[animateKey];
        CGPoint newCenter = CGPointMake(view.center.x, view.center.y + _lengthOfTile * steps);
        
        [UIView animateWithDuration:duration * steps
                              delay:delay
             usingSpringWithDamping:0.6
              initialSpringVelocity:0.1
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             view.center = newCenter;
                         }
                         completion:^(BOOL finished) {
                             _animatingCount -= 1;
                             if (_animatingCount <= 0) {
                                 _animating = NO;
                                 [self checkIfGameOver];
                             }
                             
                         }
         ];
    }
    
    
}


- (UIView *)tileViewCreatorXIndex:(int)xIndex yIndex:(int)yIndex iD:(NSNumber *)iD
{
    NSNumber *category = [_playingFieldModel categoryOfTileWithID:iD];

    UIView *tile = [_imageProvider provideImageTileOfCategory:category
                                                        frame:CGRectMake(xIndex * _lengthOfTile,
                                                                         yIndex * _lengthOfTile,
                                                                         _lengthOfTile/* * 0.9*/,
                                                                         _lengthOfTile/* * 0.9*/)];

    tile.center = CGPointMake(xIndex * _lengthOfTile + _lengthOfTile / 2, yIndex * _lengthOfTile + _lengthOfTile / 2);
    return tile;
//    UIView *tile = [[UIView alloc] initWithFrame:CGRectMake(xIndex * _lengthOfTile, yIndex * _lengthOfTile, _lengthOfTile, _lengthOfTile)];
//    tile.layer.cornerRadius = 17.0;
//    tile.layer.masksToBounds = YES;
//    //        NSNumber *category = [_playingFieldModel categoryOfTileAtPosition:[NSNumber numberWithInt:i]];
//
//    UIColor *color;
//    // check if a booster has been created
//    if ([category isEqualToNumber:@7]) {
////        [self changeTileToBooster:iD];
//        color = [UIColor blackColor];
//    } else {
//        color = _colorArray[[category intValue]];
//    }
//
//    [tile setBackgroundColor:color];
//
//    return tile;
}

- (void)resetGameplayVariables
{
    // game play variables etc
    _score = 0;
    _numberOfMovesMade = 0;
    _numberOfFiftyFiftyBoosters = 0;

}

- (void)resetMessages
{
    int movesLeft = [_uiSettingsDictionary[@"Max number of moves"] intValue] - _numberOfMovesMade;
    _movesLeftLabel.text = [NSString stringWithFormat:@"%d", movesLeft]; //[_uiSettingsDictionary[@"Max number of moves"] intValue]];
    _messageLabel.text = [NSString stringWithFormat:@"Reach %d points to clear level!", [_uiSettingsDictionary[@"Score required"] intValue]];
    _messageLabel.hidden = NO;
    _scoreLabel.text = [NSString stringWithFormat:@"%ld", _score];
}

- (void)resetState
{
    // for booster
//    _bombBoosterIsActive = NO;
//    _changeCategoryBoosterIsActive = NO;
    _boosterState = NONE;
    
    _popOverIsActive = NO;

}

- (void)seedAvatar
{
    NSNumber *avatarID = [_playingFieldModel iDOfTileAtX:@([_numberOfColumns intValue] / 2) Y: @([_numberOfRows intValue] / 2)];
    [_playingFieldModel switchTileToAvatar:avatarID];
//    QCTile *avatarTile = [_playingFieldModel tileWithID:avatarID];
//    
//    UIView *view = _viewDictionary[avatarID];
//    [view removeFromSuperview];
//    UIView *avatarView = [self tileViewCreatorXIndex:[avatarTile.x intValue]
//                                              yIndex:[avatarTile.y intValue]
//                                                  iD:avatarID];
//    [_holderView addSubview:avatarView];
//    [_viewDictionary setObject:avatarView forKey:avatarID];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSString *plistCatPath = [[NSBundle mainBundle] pathForResource:@"UISettings" ofType:@"plist"];
    _uiSettingsDictionary = [[NSDictionary alloc] initWithContentsOfFile:plistCatPath];

//    _colorArray = @[[UIColor orangeColor], [UIColor purpleColor], [UIColor greenColor], [UIColor brownColor], [UIColor blueColor], [UIColor yellowColor]];

    _colorArray = @[[UIColor purpleColor],
                    [UIColor blueColor],
                    [UIColor yellowColor],
                    [UIColor brownColor],
                    [UIColor greenColor],
                    [UIColor orangeColor]];


    // background
    UIImage *background = [UIImage imageNamed:@"QC_background"];
    UIImageView *bgView = [[UIImageView alloc] initWithImage:background];
    [self.view addSubview:bgView];
    [self.view sendSubviewToBack:bgView];


    // set up holder views dimensions
    _lengthOfTile = self.view.frame.size.width / [_uiSettingsDictionary[@"Number of columns"] floatValue];
    float frameHeight = [_uiSettingsDictionary[@"Number of rows"] floatValue] * _lengthOfTile;
    CGRect holderFrame = CGRectMake(0, self.view.frame.size.height / 2.0f - frameHeight / 2.0f, self.view.frame.size.width, frameHeight);
    _holderView.frame = holderFrame;


    _numberOfRows = _uiSettingsDictionary[@"Number of rows"];
    _numberOfColumns = _uiSettingsDictionary[@"Number of columns"];
    _tilesRequiredToMatch = _uiSettingsDictionary[@"Number of tiles required to match"];

    _playingFieldModel = [[QCPlayingFieldModel alloc] initWithRows:_numberOfRows Columns:_numberOfColumns];
    
    // for avatar, now taking it away
//    [self seedAvatar];
//    _avatarMovement = [[NSMutableArray alloc] init];
    
    _viewDictionary = [[NSMutableDictionary alloc] init];

    [self resetGameplayVariables];
    [self resetState];
    [self resetMessages];
    
    // 50/50 booster
//    _fiftyFiftyButton.imageView.image = [UIImage imageNamed:@"fifty"];
    [_fiftyFiftyButton setTitle:@"" forState:UIControlStateNormal];
    [_fiftyFiftyButton setBackgroundImage:[UIImage imageNamed:@"fifty"] forState:UIControlStateNormal];
    _fiftyFiftyButton.hidden = YES;
//    _fiftyXLabel.textColor = [UIColor greenColor];
    

    // questionProvider and imageProvider
    _questionProvider = [[QCQuestionProvider alloc] init];
    _imageProvider = [[QCTileImageProvider alloc] init];

    // swipe handling properties
    _animating = NO;
    _tilesTouched = [[NSMutableSet alloc] init];
    _moveArray = [[NSMutableArray alloc] init];
    _moveDirection = [[NSString alloc] init];

    // suction action
    _suctionMoveArray = [[NSMutableArray alloc] init];

    // pan action for suction
//    UIPanGestureRecognizer *suctionPanRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(suctionPanHandler:)];
//    suctionPanRecognizer.maximumNumberOfTouches = 1;
//    [_holderView addGestureRecognizer:suctionPanRecognizer];

    // swipe delete pan handler
//    UIPanGestureRecognizer *swipeDeletePanRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDeletePanHandler:)];
//    [_holderView addGestureRecognizer:swipeDeletePanRecognizer];

    // discrete pan Handler, so that player can swipe diagonally
//    UIPanGestureRecognizer *discreteSwipeDeletePanRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(discreteSwipeDeletePanHandler:)];
//    [_holderView addGestureRecognizer:discreteSwipeDeletePanRecognizer];
    
    // even newer pan handler
    UIPanGestureRecognizer *diagonalSwipePanHandler = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(diagonalSwipeDeletePanHandler:)];
    [_holderView addGestureRecognizer:diagonalSwipePanHandler];
    
    // test
//    UIPanGestureRecognizer *testRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(testPanHandler:)];
//    [_holderView addGestureRecognizer:testRecognizer];
    
    
    
    
    
    // move avatar pan handler
//    UIPanGestureRecognizer *avatarPanRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
//                                                                                          action:@selector(avatarPanHandler:)];
//    [_holderView addGestureRecognizer:avatarPanRecognizer];
    
    // tap action for boosters
    UITapGestureRecognizer *boosterTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(boosterTapHandler:)];
    [_holderView addGestureRecognizer:boosterTapRecognizer];

    int xIndex, yIndex;
    NSNumber *iD;

    for (int i = 0; i < [_numberOfRows intValue] * [_numberOfColumns intValue]; i++) {
        xIndex = i % [_numberOfColumns intValue];
        yIndex = i / [_numberOfColumns intValue];

        iD = [NSNumber numberWithInt:i];

        UIView *tile;
//        tile = [self tileViewCreator:yIndex xIndex:xIndex iD:iD];
        tile = [self tileViewCreatorXIndex:xIndex yIndex:yIndex iD:iD];
//        [_viewArray addObject:tile];
        [_viewDictionary setObject:tile
                            forKey:iD];
        [_holderView addSubview:tile];
    }

//    // test
//    QCPlayingFieldModel *testModel = [[QCPlayingFieldModel alloc] initWithRows:@2 Columns:@3];
//    NSLog(@"Testmodell: %@", testModel);

    // new popups
    _popupFrame = CGRectMake(20, 10, 280, 350);
    _popView = [[QCPopupView alloc] initWithFrame:_popupFrame];
    [_popView setDelegate:self];
    _popView.hidden = YES;
    [_holderView addSubview:_popView];

    _selectCategoryPopup = [[QCSelectCategoryPopup alloc] initWithFrame:_popupFrame];
    [_selectCategoryPopup setDelegate:self];
    _selectCategoryPopup.hidden = YES;
    [_holderView addSubview:_selectCategoryPopup];

    // test
//    UIImageView *connectorView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"connector"]];
//    [_holderView addSubview:connectorView];
//    [connectorView setCenter:CGPointMake(50, 50)];
    

}




- (void)deleteTiles:(NSNumber *)IDTileClicked {
    NSSet *selectionSet = [_playingFieldModel matchingAdjacentTilesToTileWithID:IDTileClicked];
    if ([selectionSet count] < [_tilesRequiredToMatch intValue]) {
        return;
    }

    // identify if new tiles have been created and give them a view etc
//    NSSet *newTiles = [_playingFieldModel getNewTilesReplacing:selectionSet];
    NSSet *newTiles = [_playingFieldModel getNewTilesReplacing:selectionSet excludingCategory:nil withBooster:NO];

    for (NSNumber *addNewKey in newTiles) {
        QCTile *newTile = [_playingFieldModel tileWithID:addNewKey];
        int x = [newTile.x intValue];
        int y = [newTile.y intValue];
        //
        UIView *newView = [[UIView alloc] initWithFrame:CGRectMake(x * _lengthOfTile, y * _lengthOfTile, _lengthOfTile, _lengthOfTile)];
        newView.layer.cornerRadius = 17.0;
        newView.layer.masksToBounds = YES;
        NSNumber *category = [_playingFieldModel categoryOfTileWithID:addNewKey];

        UIColor *color = _colorArray[[category intValue]];

        [newView setBackgroundColor:color];
        [_viewDictionary setObject:newView
                            forKey:addNewKey];
        [_holderView addSubview:newView];
    }


    // dict with ids of tiles to move, with their corresponding moves
    NSDictionary *animateDict = [_playingFieldModel removeAndReturnVerticalTranslations:selectionSet];

    for (NSNumber *key in selectionSet) {
        UIView * view = _viewDictionary[key];
        //        [view setBackgroundColor:[UIColor blackColor]];
        [view removeFromSuperview];
        [_viewDictionary removeObjectForKey:key];
    }

       _animating = YES;

    [UIView animateWithDuration:[_uiSettingsDictionary[@"Falling animation duration"] floatValue] animations:^{
        for (NSNumber *aniKey in animateDict) {
            UIView *aniView = _viewDictionary[aniKey];
            CGPoint newCenter = CGPointMake(aniView.center.x, aniView.center.y + [animateDict[aniKey] intValue] * _lengthOfTile);
            [aniView setCenter:newCenter];
        }
    }completion:^(BOOL finished) {
        _animating = NO;
    }];
}

-(void) swipeFallingDeleteTiles:(NSSet *) selectionSet withBooster:(NSNumber *) booster {
    NSSet *newTiles = [_playingFieldModel getNewTilesReplacing:selectionSet excludingCategory:nil withBooster:booster];
    
    for (NSNumber *addNewKey in newTiles) {
        QCTile *newTile = [_playingFieldModel tileWithID:addNewKey];
        int x = [newTile.x intValue];
        int y = [newTile.y intValue];
        
        UIView *newView = [self tileViewCreatorXIndex:x yIndex:y iD:addNewKey];
        [_viewDictionary setObject:newView
                            forKey:addNewKey];
        [_holderView addSubview:newView];
    }
    
    
    // dict with ids of tiles to move, with their corresponding moves
    NSDictionary *animateDict = [_playingFieldModel removeAndReturnVerticalTranslations:selectionSet];
    
    for (NSNumber *key in selectionSet) {
        UIView * view = _viewDictionary[key];
        //        [view setBackgroundColor:[UIColor blackColor]];
        [view removeFromSuperview];
        [_viewDictionary removeObjectForKey:key];
    }
    
    _animating = YES;
    
    _animatingCount = (int)[animateDict count];
    
    for (NSNumber *animeTile in animateDict) {
        [self fallingRecursionAnimationOfTile:animeTile
                               StepsRemaining:[animateDict[animeTile] intValue]];
    }
}

-(void) fallingRecursionAnimationOfTile:(NSNumber *) ID StepsRemaining:(int) steps {
    UIView *view = _viewDictionary[ID];
    CGPoint newCenter = CGPointMake(view.center.x, view.center.y + _lengthOfTile);
//    NSUInteger duration = 0.5;
    
    if (steps == 1) {
        [UIView animateWithDuration:0.15
                              delay:0
             usingSpringWithDamping:0.2
              initialSpringVelocity:0.8
                            options:0
                         animations:^ {
                             view.center = newCenter;
                         }
                         completion:^(BOOL finished) {
                             
                             NSLog(@"animating count: %d", _animatingCount);
                             
                             if (steps > 1) {
                                 [self fallingRecursionAnimationOfTile:ID
                                                        StepsRemaining:steps - 1];
                             } else {
                                 _animatingCount -= 1;
                                 if (_animatingCount <= 0) {
                                     _animating = NO;
                                     [self checkIfGameOver];
                                 }
                             }
                         }
         ];
//        [UIView animateWithDuration:1
//                              delay:0
//                            options:UIViewAnimationOptionCurveLinear
//                         animations:^ {
//                             view.center = newCenter;
//                         }
//                         completion:^(BOOL finished) {
//                             
//                             NSLog(@"animating count: %d", _animatingCount);
//                             
//                             if (steps > 1) {
//                                 [self fallingRecursionAnimationOfTile:ID
//                                                        StepsRemaining:steps - 1];
//                             } else {
//                                 _animatingCount -= 1;
//                                 if (_animatingCount <= 0) {
//                                     _animating = NO;
//                                     [self checkIfGameOver];
//                                 }
//                             }
//                         }
//         ];
    } else {
        [UIView animateWithDuration:0.15
                              delay:0
                            options:UIViewAnimationOptionCurveLinear
                         animations:^ {
                             view.center = newCenter;
                         }
                         completion:^(BOOL finished) {
                             
                             NSLog(@"animating count: %d", _animatingCount);
                             
                             if (steps > 1) {
                                 [self fallingRecursionAnimationOfTile:ID
                                                        StepsRemaining:steps - 1];
                             } else {
                                 _animatingCount -= 1;
                                 if (_animatingCount <= 0) {
                                     _animating = NO;
                                     [self checkIfGameOver];
                                 }
                             }
                         }
         ];
    }
}

- (void)checkIfGameOver {
    if (_numberOfMovesMade >= [_uiSettingsDictionary[@"Max number of moves"] intValue] || _score >= [_uiSettingsDictionary[@"Score required"] intValue]) {
        [self gameOver];
    }
}

-(void) swipeDeleteTiles:(NSSet *) selectionSet withBooster:(NSNumber *) booster {
    NSSet *newTiles = [_playingFieldModel getNewTilesReplacing:selectionSet excludingCategory:nil withBooster:booster];
    
    for (NSNumber *addNewKey in newTiles) {
        QCTile *newTile = [_playingFieldModel tileWithID:addNewKey];
        int x = [newTile.x intValue];
        int y = [newTile.y intValue];
        
        UIView *newView = [self tileViewCreatorXIndex:x yIndex:y iD:addNewKey];
        [_viewDictionary setObject:newView
                            forKey:addNewKey];
        [_holderView addSubview:newView];
    }
    
    
    // dict with ids of tiles to move, with their corresponding moves
    NSDictionary *animateDict = [_playingFieldModel removeAndReturnVerticalTranslations:selectionSet];
    
    for (NSNumber *key in selectionSet) {
        UIView * view = _viewDictionary[key];
        //        [view setBackgroundColor:[UIColor blackColor]];
        [view removeFromSuperview];
        [_viewDictionary removeObjectForKey:key];
    }
    
    _animating = YES;
    
    [UIView animateWithDuration:[_uiSettingsDictionary[@"Falling animation duration"] floatValue]
                     animations:^{
                         for (NSNumber *aniKey in animateDict) {
                             UIView *aniView = _viewDictionary[aniKey];
                             CGPoint newCenter = CGPointMake(aniView.center.x, aniView.center.y + [animateDict[aniKey] intValue] * _lengthOfTile);
                             [aniView setCenter:newCenter];
                         }
                     }completion:^(BOOL finished) {
                         _animating = NO;
                         [self checkIfGameOver];

                     }
     ];
}


-(void) deleteTheBoosterTile:(NSNumber *) boosterTile excludingCategory:(NSNumber *) excludeCategory {
    NSSet *selectionSet = [NSSet setWithObject:boosterTile];
    // identify if new tiles have been created and give them a view etc
    NSSet *newTiles = [_playingFieldModel getNewTilesReplacing:selectionSet
                                             excludingCategory:excludeCategory
                                                   withBooster:NO];

    for (NSNumber *addNewKey in newTiles) {
        QCTile *newTile = [_playingFieldModel tileWithID:addNewKey];
        int x = [newTile.x intValue];
        int y = [newTile.y intValue];
        //

        //        UIView *newView = [[UIView alloc] initWithFrame:CGRectMake(x * _lengthOfTile, y * _lengthOfTile, _lengthOfTile, _lengthOfTile)];
        //        newView.layer.cornerRadius = 17.0;
        //        newView.layer.masksToBounds = YES;
        //        NSNumber *category = [_playingFieldModel categoryOfTileWithID:addNewKey];
        //
        //        UIColor *color = _colorArray[[category intValue]];
        //
        //        [newView setBackgroundColor:color];

        UIView *newView = [self tileViewCreatorXIndex:x yIndex:y iD:addNewKey];
        [_viewDictionary setObject:newView
                            forKey:addNewKey];
        [_holderView addSubview:newView];
    }


    // dict with ids of tiles to move, with their corresponding moves
    NSDictionary *animateDict = [_playingFieldModel removeAndReturnVerticalTranslations:selectionSet];

    for (NSNumber *key in selectionSet) {
        UIView * view = _viewDictionary[key];
        //        [view setBackgroundColor:[UIColor blackColor]];
        [view removeFromSuperview];
        [_viewDictionary removeObjectForKey:key];
    }

    _animating = YES;

    [UIView animateWithDuration:[_uiSettingsDictionary[@"Falling animation duration"] floatValue]
                     animations:^{
                         for (NSNumber *aniKey in animateDict) {
                             UIView *aniView = _viewDictionary[aniKey];
                             CGPoint newCenter = CGPointMake(aniView.center.x, aniView.center.y + [animateDict[aniKey] intValue] * _lengthOfTile);
                             [aniView setCenter:newCenter];
                         }
                     }
                     completion:^(BOOL finished) {
                         _animating = NO;
                     }
     ];
}


- (void)boosterDeleteTiles:(NSNumber *)IDTileClicked {
    NSSet *selectionSet = [_playingFieldModel matchingAdjacentTilesToTileWithID:IDTileClicked];
//    if ([selectionSet count] < [_tilesRequiredToMatch intValue]) {
//        return;
//    }

    // identify if new tiles have been created and give them a view etc
    NSSet *newTiles = [_playingFieldModel getNewTilesReplacing:selectionSet
                                             excludingCategory:[_playingFieldModel categoryOfTileWithID:IDTileClicked]
                                                   withBooster:NO];

    for (NSNumber *addNewKey in newTiles) {
        QCTile *newTile = [_playingFieldModel tileWithID:addNewKey];
        int x = [newTile.x intValue];
        int y = [newTile.y intValue];
        //

//        UIView *newView = [[UIView alloc] initWithFrame:CGRectMake(x * _lengthOfTile, y * _lengthOfTile, _lengthOfTile, _lengthOfTile)];
//        newView.layer.cornerRadius = 17.0;
//        newView.layer.masksToBounds = YES;
//        NSNumber *category = [_playingFieldModel categoryOfTileWithID:addNewKey];
//
//        UIColor *color = _colorArray[[category intValue]];
//
//        [newView setBackgroundColor:color];

        UIView *newView = [self tileViewCreatorXIndex:x yIndex:y iD:addNewKey];
        [_viewDictionary setObject:newView
                            forKey:addNewKey];
        [_holderView addSubview:newView];
    }


    // dict with ids of tiles to move, with their corresponding moves
    NSDictionary *animateDict = [_playingFieldModel removeAndReturnVerticalTranslations:selectionSet];

    for (NSNumber *key in selectionSet) {
        UIView * view = _viewDictionary[key];
        //        [view setBackgroundColor:[UIColor blackColor]];
        [view removeFromSuperview];
        [_viewDictionary removeObjectForKey:key];
    }

    _animating = YES;

    [UIView animateWithDuration:[_uiSettingsDictionary[@"Falling animation duration"] floatValue]
                     animations:^{
                         for (NSNumber *aniKey in animateDict) {
                             UIView *aniView = _viewDictionary[aniKey];
                             CGPoint newCenter = CGPointMake(aniView.center.x, aniView.center.y + [animateDict[aniKey] intValue] * _lengthOfTile);
                             [aniView setCenter:newCenter];
                         }
                     }
                     completion:^(BOOL finished) {
                         _animating = NO;
                         [self deleteTheBoosterTile:_selectedBoosterTile excludingCategory:IDTileClicked];//[_playingFieldModel categoryOfTileWithID:tileTouched]];

                     }];
}

-(void)onViewClickedHandler:(UITapGestureRecognizer *)recognizer {

//    if (_animating) {
//        return;
//    }
//
//    CGPoint point = [recognizer locationInView:_holderView];
//    NSDictionary *posDict = [self gridPositionOfPoint:point numberOfRows:_noRowsAndCols lengthOfSides:_lengthOfTile];
//    NSNumber *IDTileClicked = [_playingFieldModel iDOfTileAtX:posDict[@"x"] Y:posDict[@"y"]];
//
//    [self deleteTiles:IDTileClicked];

}


-(NSNumber *)arrayIndexForX: (float)x y:(float)y numberOfRows:(NSNumber *)numberOfRows lengthOfSides:(float)lengthOfSide {

    if (x < 0.0f || y < 0.0) {
        return nil;
    }

    int row, column;

    row = (int) floorf(x / lengthOfSide);
    column = (int) floorf(y / lengthOfSide);

    if (row >= [numberOfRows intValue] || column >= [numberOfRows intValue]) {
        return nil;
    }

    return [NSNumber numberWithInt:row + column * [numberOfRows intValue]];
}

-(NSDictionary *) gridPositionOfPoint: (CGPoint)point
                         numberOfRows:(NSNumber *)numberOfRows
                      numberOfColumns:(NSNumber *)numberOfColumns
                        lengthOfSides:(float)lengthOfSide {
    int row, column;

    column = (int) floorf(point.x / lengthOfSide);
    row = (int) floorf(point.y / lengthOfSide);

    if (row >= [numberOfRows intValue] || column >= [numberOfColumns intValue]) {
        return nil;
    }

    NSDictionary *dict = @{@"x" : [NSNumber numberWithInt:column], @"y" : [NSNumber numberWithInt:row]};

    // test
//    NSLog(@"Grid position, row: %d, column %d", row, column);
    return dict;
}

-(gridPosition) discreteGridPositionOfPoint: (CGPoint) point
                               numberOfRows:(NSNumber *)numberOfRows
                            numberOfColumns:(NSNumber *)numberOfColumns
                              lengthOfSides:(float)lengthOfSide {
    
    gridPosition returnPoint;
    int row, column;
    
    
    column = (int) floorf(point.x / lengthOfSide);
    row = (int) floorf(point.y / lengthOfSide);
    
    CGPoint center;
    center.x = column * lengthOfSide + 0.5 * lengthOfSide;
    center.y = row * lengthOfSide + 0.5 * lengthOfSide;
    
    float distance = sqrtf(powf(point.x - center.x, 2) + powf(point.y - center.y, 2));
    
    if (distance > lengthOfSide * 0.3) {
        returnPoint.x = -1;
        returnPoint.y = -1;
    } else {
        returnPoint.x = column;
        returnPoint.y = row;
    }
    
    return returnPoint;
}

-(void) suctionPanHandler:(UIPanGestureRecognizer *) recognizer {
    if (_animating) {
        return;
    }
    if (_popOverIsActive) {
        return;
    }


    CGPoint point = [recognizer locationInView:_holderView];
//    NSDictionary *touchPoint = [self gridPositionOfPoint:point numberOfRows:_noRowsAndCols lengthOfSides:_lengthOfTile];
    NSDictionary *touchPoint = [self gridPositionOfPoint:point
                                            numberOfRows:_numberOfRows
                                         numberOfColumns:_numberOfColumns
                                           lengthOfSides:_lengthOfTile];
    NSNumber *x = touchPoint[@"x"];
    NSNumber *y = touchPoint[@"y"];
    //    NSMutableSet *tilesTouched = [[NSMutableSet alloc] init];
    //    NSLog(@"Touchpoint: %@", touchPoint);




    if (recognizer.state == UIGestureRecognizerStateBegan) {
        [self unMarkTiles:_tilesTouched];
//        NSLog(@"Unmarking tiles: %@", _tilesTouched);
        [_tilesTouched removeAllObjects];
//        [_moveArray removeAllObjects];
        [_suctionMoveArray removeAllObjects];


        _validSwipe = YES;
        //        NSNumber *firstTile = [_playingFieldModel iDOfTileAtX:x Y:y];
        _currentTileTouched = [_playingFieldModel iDOfTileAtX:x Y:y];

        [_tilesTouched addObject:_currentTileTouched];
        _matchingTiles = [_playingFieldModel matchingAdjacentTilesToTileWithID:_currentTileTouched];
    }

    else if (recognizer.state == UIGestureRecognizerStateChanged) {
        if (!_validSwipe) {
            return;
        }

        // make sure booster is not swiped
            if ([[_playingFieldModel categoryOfTileWithID:_currentTileTouched] isEqualToNumber:@7]) {
                return;
            }

        NSNumber *newTileTouched = [_playingFieldModel iDOfTileAtX:x Y:y];
        if ([newTileTouched isEqualToNumber:_currentTileTouched]) {
            return;
        }
        if (![_matchingTiles member:newTileTouched]) {
            _validSwipe = NO;
//            if (_moveArray) {
//                [self abortSwipeWithMoves:_moveArray];
//            }
            [self abortSuctionSwipeWithMoves:_suctionMoveArray];
            return;
        }

        // cancel booster action if player wants to swipe instead
        _bombBoosterIsActive = NO;
        _messageLabel.hidden = YES;

        if (![_playingFieldModel tilesAreAdjacentID1:_currentTileTouched ID2:newTileTouched]) {
            _validSwipe = NO;
//            if (_moveArray) {
//                [self abortSwipeWithMoves:_moveArray];
//            }
            [self abortSuctionSwipeWithMoves:_suctionMoveArray];
            return;
        }
        // prevent player from moving backwards, ie retouch an already touched tile
        if ([_tilesTouched member:newTileTouched]) {
//            if (_moveArray) {
//                [self abortSwipeWithMoves:_moveArray];
//            }
            [self abortSuctionSwipeWithMoves:_suctionMoveArray];
            _validSwipe = NO;
            return;
        }
        // prevent stepping on tail
        NSNumber *testOnTailID = [_playingFieldModel IDOfTileDuringMotionAtX:x Y:y];
        if ([[[_suctionMoveArray lastObject] tailArray] containsObject:testOnTailID]) {
            NSLog(@"Can't hit your own tail!");
            [self abortSuctionSwipeWithMoves:_suctionMoveArray];
            _validSwipe = NO;
            return;
        }

        // ok, tiles are matching, adjacent, swipe is still valid. Now do stuff!
        _moveDirection = [_playingFieldModel directionFromID:_currentTileTouched toID:newTileTouched];

//        QCMoveDescription *move = [_playingFieldModel takeOneStepAndReturnMoveForID:_currentTileTouched InDirection:_moveDirection];
//        if (move) {
//            [_moveArray addObject:move];
//        }

        // check if first step has been taken
        QCSuctionMove *suctionMove;
        if (![_suctionMoveArray count] > 0) {
            suctionMove = [_playingFieldModel takeFirstSuctionStepFrom:_currentTileTouched
                                                                          inDirection:_moveDirection];
        } else {
            suctionMove = [_playingFieldModel takeNewSuctionStepFromID:_currentTileTouched WithMove:[_suctionMoveArray lastObject]
                                                           inDirection:_moveDirection];
        }
        [_suctionMoveArray addObject:suctionMove];

        _currentTileTouched = newTileTouched;
        [_tilesTouched addObject:newTileTouched];
        [self markTiles:_tilesTouched];


    }
    else if (recognizer.state == UIGestureRecognizerStateEnded) {
        if (!_validSwipe) {
            NSLog(@"Invalid swipe");
            [self unMarkTiles:_tilesTouched];

            //            NSLog(@"Invalid swipe");
            [_tilesTouched removeAllObjects];
//            [_moveArray removeAllObjects];
//            [_suctionMoveArray removeAllObjects];
            return;
        }
        if ([_tilesTouched count] < [_uiSettingsDictionary[@"Number of tiles swiped required"] intValue]) {
            NSLog(@"Invalid swipe, not enough tiles swiped!");
            [self unMarkTiles:_tilesTouched];

            //            NSLog(@"Invalid swipe, not enough tiles swiped!");

            [_tilesTouched removeAllObjects];
//            [_moveArray removeAllObjects];
//            [_suctionMoveArray removeAllObjects];
//            if (_moveArray) {
//                [self abortSwipeWithMoves:_moveArray];
//            }

            // abort suctionSwipe
            [self abortSuctionSwipeWithMoves:_suctionMoveArray];
            return;
        }
        //        NSLog(@"Valid swipe, tiles touched: %@", _tilesTouched);
        [self markTiles:_tilesTouched];

        // make final move
//        QCMoveDescription *finalMove = [_playingFieldModel takeOneStepAndReturnMoveForID:_currentTileTouched InDirection:_moveDirection];
//        [_moveArray addObject:finalMove];

        // final suction move
        QCSuctionMove *finalSuctionMove = [_playingFieldModel takeNewSuctionStepFromID:_currentTileTouched
                                                                              WithMove:[_suctionMoveArray lastObject]
                                                                           inDirection:_moveDirection];
        [_suctionMoveArray addObject:finalSuctionMove];

        //        [_tilesTouched removeAllObjects];
        //        NSLog(@"Valid swipes, moveArray: %@", _moveArray);
//        for (QCMoveDescription *moveInspect in _moveArray) {
//            NSLog(@"%@", moveInspect);
//        }

        //        NSLog(@"moveArray: %@", _moveArray);
//        [self performAndAnimateMoves:_moveArray];
//        [_playingFieldModel updateModelWithMoves:_moveArray];

        // perform animations and update model
//        for (QCSuctionMove *move in _suctionMoveArray) {
//            NSLog(@"Suction move: %@", move);
//        }

        [self launchPopOverFromID:_currentTileTouched withColor:[UIColor redColor]];
//        _animating = YES;
//        [self performAndAnimateSuctionMoves:_suctionMoveArray];
//        [_playingFieldModel updateModelWithSuctionMoves:_suctionMoveArray];

    }
    else if (recognizer.state == UIGestureRecognizerStateCancelled) {
        [self abortSwipeWithMoves:_moveArray];
    }
    else if (recognizer.state == UIGestureRecognizerStateFailed) {
        [self abortSwipeWithMoves:_moveArray];
    }

    //    NSLog(@"Tiles touched: %@", _tilesTouched);

}

//-(void) avatarPanHandler:(UIPanGestureRecognizer *) recognizer {
//    
//    if (_animating) {
//        return;
//    }
//    if (_popOverIsActive) {
//        return;
//    }
//    
//    _changeCategoryBoosterIsActive = NO;
//    _bombBoosterIsActive = NO;
//    
//    CGPoint point = [recognizer locationInView:_holderView];
//    //    NSDictionary *touchPoint = [self gridPositionOfPoint:point numberOfRows:_noRowsAndCols lengthOfSides:_lengthOfTile];
//    NSDictionary *touchPoint = [self gridPositionOfPoint:point
//                                            numberOfRows:_numberOfRows
//                                         numberOfColumns:_numberOfColumns
//                                           lengthOfSides:_lengthOfTile];
//    NSNumber *x = touchPoint[@"x"];
//    NSNumber *y = touchPoint[@"y"];
//    //    NSMutableSet *tilesTouched = [[NSMutableSet alloc] init];
//    //    NSLog(@"Touchpoint: %@", touchPoint);
//    
//    NSLog(@"Kategori för tile: %@", [_playingFieldModel categoryOfTileWithID:[_playingFieldModel iDOfTileAtX:x Y:y]]);
//    
//    
//    
//    if (recognizer.state == UIGestureRecognizerStateBegan) {
//        [self unMarkTiles:_tilesTouched];
//        [_tilesTouched removeAllObjects];
////        [_suctionMoveArray removeAllObjects];
//
//        //        NSNumber *firstTile = [_playingFieldModel iDOfTileAtX:x Y:y];
//        _currentTileTouched = [_playingFieldModel iDOfTileAtX:x Y:y];
//        
//        // make sure swipe starts on avatar
//        if (![[_playingFieldModel categoryOfTileWithID:_currentTileTouched] isEqualToNumber:@9]) {
//            _validSwipe = NO;
//            return;
//        }
//        
//        _validSwipe = YES;
//        
//        _matchingTiles = nil;
//        
//        [_tilesTouched removeAllObjects];
//
////        [_avatarMovement removeAllObjects];
//    }
//    
//    else if (recognizer.state == UIGestureRecognizerStateChanged) {
//        if (!_validSwipe) {
//            return;
//        }
//        
////        // make sure booster is not swiped
////        if ([[_playingFieldModel categoryOfTileWithID:_currentTileTouched] isEqualToNumber:@7]) {
////            return;
////        }
//        
//        NSNumber *newTileTouched = [_playingFieldModel iDOfTileAtX:x Y:y];
//        if ([newTileTouched isEqualToNumber:_currentTileTouched]) {
//            return;
//        }
//        
//        // prevent booster in swipe
//        if ([@[@7, @8] containsObject:[_playingFieldModel categoryOfTileWithID:newTileTouched]]) {
//            _validSwipe = NO;
//            [self unMarkTiles: _tilesTouched];
//            return;
//        }
//
////        NSLog(@"New tile touched: %@", newTileTouched);
//        
//        if (!_matchingTiles) {
//            _matchingTiles = [_playingFieldModel matchingAdjacentTilesToTileWithID:newTileTouched];
//        }
//        
//        if (![_matchingTiles member:newTileTouched]) {
//            _validSwipe = NO;
//            [self unMarkTiles:_tilesTouched];
//            //            if (_moveArray) {
//            //                [self abortSwipeWithMoves:_moveArray];
//            //            }
////            [self abortSuctionSwipeWithMoves:_suctionMoveArray];
//            return;
//        }
//        
//        if (![_playingFieldModel tilesAreAdjacentID1:_currentTileTouched ID2:newTileTouched]) {
//            _validSwipe = NO;
//            [self unMarkTiles: _tilesTouched];
//            return;
//        }
//
//        // prevent player from moving backwards
//        if ([_tilesTouched member:newTileTouched]) {
//            _validSwipe = NO;
//            [self unMarkTiles:_tilesTouched];
//            return;
//        }
//        
//        [_tilesTouched addObject:newTileTouched];
//        
//        [self markTiles:_tilesTouched];
//        Direction direction = [_playingFieldModel enumDirectionFromID:_currentTileTouched
//                                                                 toID:newTileTouched];
////        [_avatarMovement addObject:@(direction)];
//        _currentTileTouched = newTileTouched;
//    }
//    
//    else if (recognizer.state == UIGestureRecognizerStateEnded) {
////        [self unMarkTiles:_tilesTouched];
//        
//        if (!_validSwipe) {
//            return;
//        }
//        
////        NSLog(@"current tile touched: %@", _currentTileTouched);
////        UIView *destinationView = _viewDictionary[_currentTileTouched];
//        UIView *avatarView = _viewDictionary[[_playingFieldModel IDOfAvatar]];
//        [_holderView bringSubviewToFront:avatarView];
//        
//        // log avatar movement
////        NSLog(@"Avatar movement: %@", _avatarMovement);
//        
//        [self recursionAvatarAnimation:0];
//        
////        [UIView animateWithDuration:1
////                              delay:0
////                            options:UIViewAnimationOptionCurveLinear
////                         animations:^ {
//////                             avatarView.alpha = 0;
////                             avatarView.center = destinationView.center;
//////                             avatarView.center = CGPointMake(0, 0);
////                         }
////                         completion:^(BOOL finished) {
////                             [destinationView removeFromSuperview];
//////                             [self finishAvatarSwipe];
////                             [self launchPopOverFromID:_currentTileTouched withColor:[UIColor redColor]];
////                             [_playingFieldModel swapPositionsOfTile:[_playingFieldModel IDOfAvatar] andTile:_currentTileTouched];
////
////
////                         }
////         ];
//        
//    }
//}

//-(void) recursionAvatarAnimation:(int) index {
////    CGPoint newCenter;
//    float deltaX, deltaY;
//    UIView *avatarView = _viewDictionary[[_playingFieldModel IDOfAvatar]];
//    
////    Direction direction = [_avatarMovement[index] intValue];
//    
//    switch (direction) {
//        case UP: {
//            deltaX = 0;
//            deltaY =-_lengthOfTile;
//            break;
//        }
//        case DOWN: {
//            deltaX = 0;
//            deltaY = _lengthOfTile;
//            break;
//        }
//        case RIGHT: {
//            deltaX = _lengthOfTile;
//            deltaY = 0;
//            break;
//        }
//        case LEFT: {
//            deltaX = -_lengthOfTile;
//            deltaY = 0;
//            break;
//        }
//        case NO_DIRECTION: {
//            [NSException raise:@"Avatar must move in a specified direction" format:@"Avatar must move in a specified direction"];
//        }
//    }
//    
//    CGPoint newCenter = CGPointMake(avatarView.center.x + deltaX,
//                                    avatarView.center.y + deltaY);
//    
//    NSTimeInterval duration;
//    NSUInteger options;
//    if (index == [_avatarMovement count] - 1) {
//        duration = 0.6;
//        options = UIViewAnimationOptionCurveEaseOut;
//    } else {
//        duration = 0.3;
//        options = UIViewAnimationOptionCurveLinear;
//    }
//    
//    [UIView animateWithDuration:duration
//                          delay:0
//                        options:options
//                     animations:^ {
//                         avatarView.center = newCenter;
//                     }
//                     completion:^(BOOL finished) {
//                         if (index < ([_avatarMovement count] - 1)) {
//                             [self recursionAvatarAnimation:index + 1];
//                         } else {
//                             UIView *destinationView = _viewDictionary[_currentTileTouched];
//                             [destinationView removeFromSuperview];
//                             [self launchPopOverFromID:_currentTileTouched
//                                             withColor:[UIColor redColor]];
//                             [_playingFieldModel swapPositionsOfTile:[_playingFieldModel IDOfAvatar]
//                                                             andTile:_currentTileTouched];
//                             
//
//                         }
//                     }
//     ];
//}

-(void) finishAvatarSwipe {
    NSLog(@"Spelplan innan delete:\n%@", _playingFieldModel);
    [_playingFieldModel swapPositionsOfTile:[_playingFieldModel IDOfAvatar] andTile:_currentTileTouched];
    NSLog(@"Spelplan efter swap:\n%@", _playingFieldModel);
    [_tilesTouched addObject:_currentTileTouched];
    [self swipeDeleteTiles:_tilesTouched withBooster:nil];
    NSLog(@"Spelplan efter delete:\n%@", _playingFieldModel);
}

//-(void) testPanHandler:(UIPanGestureRecognizer *) recognizer {
//    CGPoint point = [recognizer locationInView:_holderView];
//    gridPosition position = [self discreteGridPositionOfPoint:point
//                                                 numberOfRows:_numberOfRows
//                                              numberOfColumns:_numberOfColumns
//                                                lengthOfSides:_lengthOfTile];
//    
//    if (position.x == -1 && position.y == -1) {
//        return;
//    }
//    
//    NSNumber *tile = [_playingFieldModel iDOfTileAtX:@(position.x) Y:@(position.y)];
//    
//    
//    if (position.x == -1 && position.y == -1) {
//        return;
//    }
//    
//    if (recognizer.state == UIGestureRecognizerStateBegan) {
//        [_tilesTouched removeAllObjects];
//        [_tilesTouched addObject:tile];
//        _currentTileTouched = tile;
//    }
//    
//    else if (recognizer.state == UIGestureRecognizerStateChanged) {
//        if (![tile isEqualToNumber:_currentTileTouched]) {
//            [_tilesTouched addObject:tile];
//        }
//    }
//    
//    else if (recognizer.state == UIGestureRecognizerStateEnded) {
//        NSLog(@"Tiles touched: %@", _tilesTouched);
//    }
//}

-(void) discreteSwipeDeletePanHandler:(UIPanGestureRecognizer *) recognizer {
    if (_animating) {
        return;
    }
    if (_popOverIsActive) {
        return;
    }
    
    _changeCategoryBoosterIsActive = NO;
    _bombBoosterIsActive = NO;
    
    CGPoint point = [recognizer locationInView:_holderView];
    //    NSDictionary *touchPoint = [self gridPositionOfPoint:point numberOfRows:_noRowsAndCols lengthOfSides:_lengthOfTile];
//    NSDictionary *touchPoint = [self gridPositionOfPoint:point
//                                            numberOfRows:_numberOfRows
//                                         numberOfColumns:_numberOfColumns
//                                           lengthOfSides:_lengthOfTile];
    
    NSLog(@"Point x: %f, y: %f", point.x, point.y);
    
    if (point.x < 0 || point.y < 0 || point.x > _holderView.frame.size.width || point.y > _holderView.frame.size.height) {
        _validSwipe = NO;
        return;
    }
    
    gridPosition position = [self discreteGridPositionOfPoint:point
                                                 numberOfRows:_numberOfRows
                                              numberOfColumns:_numberOfColumns
                                                lengthOfSides:_lengthOfTile];
   
    
    NSNumber *x = @(position.x);  //touchPoint[@"x"];
    NSNumber *y = @(position.y);    //touchPoint[@"y"];
    //    NSMutableSet *tilesTouched = [[NSMutableSet alloc] init];
    //    NSLog(@"Touchpoint: %@", touchPoint);
    
    
    
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        [self unMarkTiles:_tilesTouched];
        //        NSLog(@"Unmarking tiles: %@", _tilesTouched);
        [_tilesTouched removeAllObjects];
        //        [_moveArray removeAllObjects];
//        [_suctionMoveArray removeAllObjects];
        
        // reading coordinates different in state began
        NSDictionary *touchPoint = [self gridPositionOfPoint:point
                                                numberOfRows:_numberOfRows
                                             numberOfColumns:_numberOfColumns
                                               lengthOfSides:_lengthOfTile];

        
        _validSwipe = YES;
        //        NSNumber *firstTile = [_playingFieldModel iDOfTileAtX:x Y:y];
        _currentTileTouched = [_playingFieldModel iDOfTileAtX:touchPoint[@"x"] Y:touchPoint[@"y"]];
        
        if (_currentTileTouched) {            
            [_tilesTouched addObject:_currentTileTouched];
            //        _matchingTiles = [_playingFieldModel matchingAdjacentTilesToTileWithID:_currentTileTouched];
            [self markTiles:_tilesTouched];
        }
    }
    
    else if (recognizer.state == UIGestureRecognizerStateChanged) {
        if (!_validSwipe) {
            return;
        }
        
        if (position.x == -1 && position.y == -1) {
            if (recognizer.state == UIGestureRecognizerStateEnded) {
                [self unMarkTiles:_tilesTouched];
            }
            return;
        }
        
        if (!_currentTileTouched) {
            _currentTileTouched = [_playingFieldModel iDOfTileAtX:x Y:y];
            if (_currentTileTouched) {
                [_tilesTouched addObject:_currentTileTouched];
            }
        }
        
        // make sure booster is not swiped
        if ([[_playingFieldModel categoryOfTileWithID:_currentTileTouched] isEqualToNumber:@7]) {
            return;
        }
        
        NSNumber *newTileTouched = [_playingFieldModel iDOfTileAtX:x Y:y];
        if ([newTileTouched isEqualToNumber:_currentTileTouched]) {
            return;
        }
        
        if (![_playingFieldModel tilesAreLinkedID1:_currentTileTouched ID2:newTileTouched]) {
            _validSwipe = NO;
            [self unMarkTiles:_tilesTouched];
            return;
        }
        
//        if (![_matchingTiles member:newTileTouched]) {
//            _validSwipe = NO;
//            //            if (_moveArray) {
//            //                [self abortSwipeWithMoves:_moveArray];
//            //            }
//            [self abortSuctionSwipeWithMoves:_suctionMoveArray];
//            return;
//        }
        
        NSNumber *cat1 = [_playingFieldModel categoryOfTileWithID:_currentTileTouched];
        NSNumber *cat2 = [_playingFieldModel categoryOfTileWithID:newTileTouched];
        if (![cat1 isEqualToNumber:cat2]) {
//            _validSwipe = NO;
            return;
        }
        
        // cancel booster action if player wants to swipe instead
        _bombBoosterIsActive = NO;
        _messageLabel.hidden = YES;
        
        //        if (![_playingFieldModel tilesAreAdjacentID1:_currentTileTouched ID2:newTileTouched]) {
        //            _validSwipe = NO;
        //            //            if (_moveArray) {
        //            //                [self abortSwipeWithMoves:_moveArray];
        //            //            }
        //            [self abortSuctionSwipeWithMoves:_suctionMoveArray];
        //            return;
        //        }
        
        
        // prevent player from moving backwards, ie retouch an already touched tile
        if ([_tilesTouched member:newTileTouched]) {
            //            if (_moveArray) {
            //                [self abortSwipeWithMoves:_moveArray];
            //            }
//            [self abortSuctionSwipeWithMoves:_suctionMoveArray];
            _validSwipe = NO;
            [self unMarkTiles:_tilesTouched];

            return;
        }
        _currentTileTouched = newTileTouched;
        [_tilesTouched addObject:newTileTouched];
        [self markTiles:_tilesTouched];
        
        
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded) {
//        [self unMarkTiles:_tilesTouched];
        if (!_validSwipe) {
            NSLog(@"Invalid swipe");
            [self unMarkTiles:_tilesTouched];
            
            //            NSLog(@"Invalid swipe");
            [_tilesTouched removeAllObjects];
            //            [_moveArray removeAllObjects];
            //            [_suctionMoveArray removeAllObjects];
            return;
        }
        if ([_tilesTouched count] < [_uiSettingsDictionary[@"Number of tiles swiped required"] intValue]) {
            NSLog(@"Invalid swipe, not enough tiles swiped!");
            [self unMarkTiles:_tilesTouched];
            
            //            NSLog(@"Invalid swipe, not enough tiles swiped!");
            
            [_tilesTouched removeAllObjects];
            //            [_moveArray removeAllObjects];
            //            [_suctionMoveArray removeAllObjects];
            //            if (_moveArray) {
            //                [self abortSwipeWithMoves:_moveArray];
            //            }
            
            //            // abort suctionSwipe
            //            [self abortSuctionSwipeWithMoves:_suctionMoveArray];
            return;
        }
        //        NSLog(@"Valid swipe, tiles touched: %@", _tilesTouched);
//        [self markTiles:_tilesTouched];
        
        
//        _currentTileTouched = nil;
        [self launchPopOverFromID:_currentTileTouched withColor:[UIColor redColor]];
    }
}

-(void) diagonalSwipeDeletePanHandler:(UIPanGestureRecognizer *) recognizer {
    if (_animating) {
        return;
    }
    if (_popOverIsActive) {
        return;
    }
    
    _changeCategoryBoosterIsActive = NO;
    _bombBoosterIsActive = NO;
    
    CGPoint point = [recognizer locationInView:_holderView];
    //    NSDictionary *touchPoint = [self gridPositionOfPoint:point numberOfRows:_noRowsAndCols lengthOfSides:_lengthOfTile];
    NSDictionary *touchPoint = [self gridPositionOfPoint:point
                                            numberOfRows:_numberOfRows
                                         numberOfColumns:_numberOfColumns
                                           lengthOfSides:_lengthOfTile];
    NSNumber *x = touchPoint[@"x"];
    NSNumber *y = touchPoint[@"y"];
    //    NSMutableSet *tilesTouched = [[NSMutableSet alloc] init];
    //    NSLog(@"Touchpoint: %@", touchPoint);
    
    
    
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        [self unMarkTiles:_tilesTouched];
        //        NSLog(@"Unmarking tiles: %@", _tilesTouched);
        [_tilesTouched removeAllObjects];
        //        [_moveArray removeAllObjects];
        [_suctionMoveArray removeAllObjects];
        
        
        _validSwipe = YES;
        //        NSNumber *firstTile = [_playingFieldModel iDOfTileAtX:x Y:y];
        _currentTileTouched = [_playingFieldModel iDOfTileAtX:x Y:y];
        
        [_tilesTouched addObject:_currentTileTouched];
//        _matchingTiles = [_playingFieldModel matchingAdjacentTilesToTileWithID:_currentTileTouched];
        [self markTiles:_tilesTouched];
    }
    
    else if (recognizer.state == UIGestureRecognizerStateChanged) {
        if (!_validSwipe) {
            return;
        }
        
        // make sure booster is not swiped
        if ([[_playingFieldModel categoryOfTileWithID:_currentTileTouched] isEqualToNumber:@7]) {
            return;
        }
        
        NSNumber *newTileTouched = [_playingFieldModel iDOfTileAtX:x Y:y];
        if ([newTileTouched isEqualToNumber:_currentTileTouched]) {
            return;
        }
//        if (![_matchingTiles member:newTileTouched]) {
//            _validSwipe = NO;
//            //            if (_moveArray) {
//            //                [self abortSwipeWithMoves:_moveArray];
//            //            }
//            [self abortSuctionSwipeWithMoves:_suctionMoveArray];
//            return;
//        }
        
        if (![_playingFieldModel tilesAreLinkedID1:newTileTouched ID2:_currentTileTouched]) {
            return;
        }
        NSNumber *cat1 = [_playingFieldModel categoryOfTileWithID:_currentTileTouched];
        NSNumber *cat2 = [_playingFieldModel categoryOfTileWithID:newTileTouched];
        if (![cat1 isEqualToNumber:cat2]) {
            //            _validSwipe = NO;
            return;
        }
        
        // cancel booster action if player wants to swipe instead
        _bombBoosterIsActive = NO;
        _messageLabel.hidden = YES;
        
        //        if (![_playingFieldModel tilesAreAdjacentID1:_currentTileTouched ID2:newTileTouched]) {
        //            _validSwipe = NO;
        //            //            if (_moveArray) {
        //            //                [self abortSwipeWithMoves:_moveArray];
        //            //            }
        //            [self abortSuctionSwipeWithMoves:_suctionMoveArray];
        //            return;
        //        }
        
        
        // prevent player from moving backwards, ie retouch an already touched tile
//        if ([_tilesTouched member:newTileTouched]) {
//            //            if (_moveArray) {
//            //                [self abortSwipeWithMoves:_moveArray];
//            //            }
//            [self abortSuctionSwipeWithMoves:_suctionMoveArray];
//            _validSwipe = NO;
//            return;
//        }
        _currentTileTouched = newTileTouched;
        [_tilesTouched addObject:newTileTouched];
        [self markTiles:_tilesTouched];
        
        
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded) {
        if (!_validSwipe) {
            NSLog(@"Invalid swipe");
            [self unMarkTiles:_tilesTouched];
            
            //            NSLog(@"Invalid swipe");
            [_tilesTouched removeAllObjects];
            //            [_moveArray removeAllObjects];
            //            [_suctionMoveArray removeAllObjects];
            return;
        }
        if ([_tilesTouched count] < [_uiSettingsDictionary[@"Number of tiles swiped required"] intValue]) {
            NSLog(@"Invalid swipe, not enough tiles swiped!");
            [self unMarkTiles:_tilesTouched];
            
            //            NSLog(@"Invalid swipe, not enough tiles swiped!");
            
            [_tilesTouched removeAllObjects];
            //            [_moveArray removeAllObjects];
            //            [_suctionMoveArray removeAllObjects];
            //            if (_moveArray) {
            //                [self abortSwipeWithMoves:_moveArray];
            //            }
            
            //            // abort suctionSwipe
            //            [self abortSuctionSwipeWithMoves:_suctionMoveArray];
            return;
        }
        //        NSLog(@"Valid swipe, tiles touched: %@", _tilesTouched);
        [self markTiles:_tilesTouched];
        
        
        
        [self launchPopOverFromID:_currentTileTouched withColor:[UIColor redColor]];
    }
}

-(void) swipeDeletePanHandler:(UIPanGestureRecognizer *) recognizer {
    if (_animating) {
        return;
    }
    if (_popOverIsActive) {
        return;
    }
    
    _changeCategoryBoosterIsActive = NO;
    _bombBoosterIsActive = NO;
    
    CGPoint point = [recognizer locationInView:_holderView];
    //    NSDictionary *touchPoint = [self gridPositionOfPoint:point numberOfRows:_noRowsAndCols lengthOfSides:_lengthOfTile];
    NSDictionary *touchPoint = [self gridPositionOfPoint:point
                                            numberOfRows:_numberOfRows
                                         numberOfColumns:_numberOfColumns
                                           lengthOfSides:_lengthOfTile];
    NSNumber *x = touchPoint[@"x"];
    NSNumber *y = touchPoint[@"y"];
    //    NSMutableSet *tilesTouched = [[NSMutableSet alloc] init];
    //    NSLog(@"Touchpoint: %@", touchPoint);
    
    
    
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        [self unMarkTiles:_tilesTouched];
        //        NSLog(@"Unmarking tiles: %@", _tilesTouched);
        [_tilesTouched removeAllObjects];
        //        [_moveArray removeAllObjects];
        [_suctionMoveArray removeAllObjects];
        
        
        _validSwipe = YES;
        //        NSNumber *firstTile = [_playingFieldModel iDOfTileAtX:x Y:y];
        _currentTileTouched = [_playingFieldModel iDOfTileAtX:x Y:y];
        
        [_tilesTouched addObject:_currentTileTouched];
        _matchingTiles = [_playingFieldModel matchingAdjacentTilesToTileWithID:_currentTileTouched];
        [self markTiles:_tilesTouched];
    }
    
    else if (recognizer.state == UIGestureRecognizerStateChanged) {
        if (!_validSwipe) {
            return;
        }
        
        // make sure booster is not swiped
        if ([[_playingFieldModel categoryOfTileWithID:_currentTileTouched] isEqualToNumber:@7]) {
            return;
        }
        
        NSNumber *newTileTouched = [_playingFieldModel iDOfTileAtX:x Y:y];
        if ([newTileTouched isEqualToNumber:_currentTileTouched]) {
            return;
        }
        if (![_matchingTiles member:newTileTouched]) {
            _validSwipe = NO;
            //            if (_moveArray) {
            //                [self abortSwipeWithMoves:_moveArray];
            //            }
            [self abortSuctionSwipeWithMoves:_suctionMoveArray];
            return;
        }
        
        // cancel booster action if player wants to swipe instead
        _bombBoosterIsActive = NO;
        _messageLabel.hidden = YES;
        
//        if (![_playingFieldModel tilesAreAdjacentID1:_currentTileTouched ID2:newTileTouched]) {
//            _validSwipe = NO;
//            //            if (_moveArray) {
//            //                [self abortSwipeWithMoves:_moveArray];
//            //            }
//            [self abortSuctionSwipeWithMoves:_suctionMoveArray];
//            return;
//        }
        
        
        // prevent player from moving backwards, ie retouch an already touched tile
        if ([_tilesTouched member:newTileTouched]) {
            //            if (_moveArray) {
            //                [self abortSwipeWithMoves:_moveArray];
            //            }
            [self abortSuctionSwipeWithMoves:_suctionMoveArray];
            _validSwipe = NO;
            return;
        }
               _currentTileTouched = newTileTouched;
        [_tilesTouched addObject:newTileTouched];
        [self markTiles:_tilesTouched];
        
        
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded) {
        if (!_validSwipe) {
            NSLog(@"Invalid swipe");
            [self unMarkTiles:_tilesTouched];
            
            //            NSLog(@"Invalid swipe");
            [_tilesTouched removeAllObjects];
            //            [_moveArray removeAllObjects];
            //            [_suctionMoveArray removeAllObjects];
            return;
        }
        if ([_tilesTouched count] < [_uiSettingsDictionary[@"Number of tiles swiped required"] intValue]) {
            NSLog(@"Invalid swipe, not enough tiles swiped!");
            [self unMarkTiles:_tilesTouched];
            
            //            NSLog(@"Invalid swipe, not enough tiles swiped!");
            
            [_tilesTouched removeAllObjects];
            //            [_moveArray removeAllObjects];
            //            [_suctionMoveArray removeAllObjects];
            //            if (_moveArray) {
            //                [self abortSwipeWithMoves:_moveArray];
            //            }
            
//            // abort suctionSwipe
//            [self abortSuctionSwipeWithMoves:_suctionMoveArray];
            return;
        }
        //        NSLog(@"Valid swipe, tiles touched: %@", _tilesTouched);
        [self markTiles:_tilesTouched];
        
    
        
        [self launchPopOverFromID:_currentTileTouched withColor:[UIColor redColor]];
    }
}

-(void) boosterTapHandler:(UITapGestureRecognizer *) recognizer {
    CGPoint point = [recognizer locationInView:_holderView];
    NSDictionary *touchPoint = [self gridPositionOfPoint:point
                                            numberOfRows:_numberOfRows
                                         numberOfColumns:_numberOfColumns
                                           lengthOfSides:_lengthOfTile];

    NSNumber *tileTouched = [_playingFieldModel iDOfTileAtX:touchPoint[@"x"] Y:touchPoint[@"y"]];
    NSNumber *category = [_playingFieldModel categoryOfTileWithID:tileTouched];
    
    // New structure
    
    switch (_boosterState) {
        case NONE: {
            if ([category isEqualToNumber:@7]) {
//                _boosterState = BOMB;
//                _messageLabel.hidden = NO;
//                _messageLabel.text = @"Tap squares you want to remove!";
//                _selectedBoosterTile = tileTouched;
                [self bombBoosterHandling:tileTouched];
                return;
            } else if ([category isEqualToNumber:@8]) {
//                _boosterState = CHANGE_CAT;
//                _messageLabel.hidden = NO;
//                _messageLabel.text = @"Tap squares you want to swap category of";
//                _selectedBoosterTile = tileTouched;
                [self changeCategoryBoosterHandling:tileTouched];
                return;
            } else {
                return;
            }
            break;
        }
        case BOMB: {
            if ([category isEqualToNumber:@7] || [category isEqualToNumber:@9]) {
                _boosterState = NONE;
                return;
            } else if ([category isEqualToNumber:@8]) {
                _boosterState = NONE;
                [self changeCategoryBoosterHandling:tileTouched];
                return;
            } else {
                [self bombBoosterHandling:tileTouched];
                return;
            }
            break;
        }
        case CHANGE_CAT: {
            if ([category isEqualToNumber:@8] || [category isEqualToNumber:@9]) {
                _boosterState = NONE;
                return;
            } else if ([category isEqualToNumber:@7]) {
                _boosterState = NONE;
                [self bombBoosterHandling:tileTouched];
                return;
            } else {
                [self changeCategoryBoosterHandling:tileTouched];
                return;
            }
            break;
        }
    }
    
    
//    
//    if ([[_playingFieldModel categoryOfTileWithID:tileTouched] isEqualToNumber:@7] || _bombBoosterIsActive) {
//        // bomb booster
//        [self bombBoosterHandling:tileTouched];
//    }
//    if ([[_playingFieldModel categoryOfTileWithID:tileTouched] isEqualToNumber:@8] || _changeCategoryBoosterIsActive) {
//        // change category
//        [self changeCategoryBoosterHandling:tileTouched];
//    }

}

-(void) changeCategoryBoosterHandling:(NSNumber *) tileTouched {
    if (_boosterState != CHANGE_CAT) {
        _boosterState = CHANGE_CAT;
//        _changeCategoryBoosterIsActive = YES;
        _messageLabel.hidden = NO;
        _messageLabel.text = @"Tap squares you want to swap category of";
        _selectedBoosterTile = tileTouched;
        return;
    }
    
    // booster is active, let user tap a tile, find surrounding tiles and change color
    if ([[_playingFieldModel categoryOfTileWithID:tileTouched] isEqualToNumber:@7] || [[_playingFieldModel categoryOfTileWithID:tileTouched] isEqualToNumber:@8]) {
        return;
    }
    
    _messageLabel.hidden = YES;
    _changeCategoryBoosterIsActive = NO;

//    NSSet *selectSet = [_playingFieldModel matchingAdjacentTilesToTileWithID:tileTouched];
    
    _tileToChangeCategoryOf = tileTouched;
    
    // launch popover
    UIView *tileView = _viewDictionary[tileTouched];
    UIView *popOverAnimatingView = [[UIView alloc] initWithFrame:tileView.frame];
    [popOverAnimatingView setBackgroundColor:[UIColor colorWithWhite:1 alpha:1]];   //tileView.backgroundColor];
    popOverAnimatingView.layer.cornerRadius = 25;
    popOverAnimatingView.layer.masksToBounds = YES;
    [_holderView addSubview:popOverAnimatingView];
    _popOverIsActive = YES;

    [UIView animateWithDuration:.3
                          delay:0.03
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         popOverAnimatingView.frame = _popupFrame;
//                         [popOverAnimatingView setBackgroundColor:_popOver.backgroundColor];
                         [popOverAnimatingView setAlpha:.97];
                         
                     }
                     completion:^(BOOL finished) {
                         _selectCategoryPopup.hidden = NO;
                         [_holderView bringSubviewToFront:_selectCategoryPopup];
                         [popOverAnimatingView removeFromSuperview];
                     }];

    _boosterState = NONE;
}

-(void) bombBoosterHandling:(NSNumber *) tileTouched {
    NSLog(@"Bomb booster handling");
    
    if (_boosterState != BOMB) {
        _boosterState = BOMB;
        _messageLabel.hidden = NO;
        _messageLabel.text = @"Tap squares you want to remove!";
//        NSLog(@"Booster!");
//        _bombBoosterIsActive = YES;
        _selectedBoosterTile = tileTouched;
        return;
    }
    
    // booster is active, let user tap a tile, find surrounding tiles and remove them
    if ([[_playingFieldModel categoryOfTileWithID:tileTouched] isEqualToNumber:@7] || [[_playingFieldModel categoryOfTileWithID:tileTouched] isEqualToNumber:@8]) {
        return;
    }
    
    //    [self deleteTheBoosterTile:_selectedBoosterTile excludingCategory:[_playingFieldModel categoryOfTileWithID:tileTouched]];
    [self boosterDeleteTiles:tileTouched];
    _messageLabel.hidden = YES;
//    _bombBoosterIsActive = NO;
    _boosterState = NONE;
}



-(void) panHandler:(UIPanGestureRecognizer *) recognizer {
//    NSLog(@"Pan handler");
    CGPoint point = [recognizer locationInView:_holderView];
//    NSDictionary *touchPoint = [self gridPositionOfPoint:point numberOfRows:_noRowsAndCols lengthOfSides:_lengthOfTile];
    NSDictionary *touchPoint = [self gridPositionOfPoint:point
                                            numberOfRows:_numberOfRows
                                         numberOfColumns:_numberOfColumns
                                           lengthOfSides:_lengthOfTile];

    NSNumber *x = touchPoint[@"x"];
    NSNumber *y = touchPoint[@"y"];
//    NSMutableSet *tilesTouched = [[NSMutableSet alloc] init];
//    NSLog(@"Touchpoint: %@", touchPoint);




    if (recognizer.state == UIGestureRecognizerStateBegan) {
        [self unMarkTiles:_tilesTouched];
        NSLog(@"Unmarking tiles: %@", _tilesTouched);
        [_tilesTouched removeAllObjects];
        [_moveArray removeAllObjects];

        _validSwipe = YES;
//        NSNumber *firstTile = [_playingFieldModel iDOfTileAtX:x Y:y];
        _currentTileTouched = [_playingFieldModel iDOfTileAtX:x Y:y];

        // test, skall nog inte vara så här
//        if (!_currentTileTouched) {
//            return;
//        }
        // debug
        NSLog(@"Hela planen: %@", _playingFieldModel);

        [_tilesTouched addObject:_currentTileTouched];
        _matchingTiles = [_playingFieldModel matchingAdjacentTilesToTileWithID:_currentTileTouched];
//        NSLog(@"State began, possible matches: %@", _matchingTiles);
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged) {
        if (!_validSwipe) {
            return;
        }
        NSNumber *newTileTouched = [_playingFieldModel iDOfTileAtX:x Y:y];
        if ([newTileTouched isEqualToNumber:_currentTileTouched]) {
            return;
        }
        if (![_matchingTiles member:newTileTouched]) {
            _validSwipe = NO;
            if (_moveArray) {
                [self abortSwipeWithMoves:_moveArray];
            }
            return;
        }
        if (![_playingFieldModel tilesAreAdjacentID1:_currentTileTouched ID2:newTileTouched]) {
            _validSwipe = NO;
            if (_moveArray) {
                [self abortSwipeWithMoves:_moveArray];
            }
            return;
        }
        // prevent player from moving backwards, ie retouch an already touched tile
        if ([_tilesTouched member:newTileTouched]) {
            if (_moveArray) {
                [self abortSwipeWithMoves:_moveArray];
            }
            _validSwipe = NO;
            return;
        }
        // ok, tiles are matching, adjacent, swipe is still valid. Now do stuff!

        // test
//        NSLog(@"Direction swiped: %@", [_playingFieldModel directionFromID:_currentTileTouched toID:newTileTouched]);
//        _vaildSwipe = NO;
//        return;

        _moveDirection = [_playingFieldModel directionFromID:_currentTileTouched toID:newTileTouched];

        QCMoveDescription *move = [_playingFieldModel takeOneStepAndReturnMoveForID:_currentTileTouched InDirection:_moveDirection];
        if (move) {
            [_moveArray addObject:move];
        }

        _currentTileTouched = newTileTouched;
        [_tilesTouched addObject:newTileTouched];
        [self markTiles:_tilesTouched];
        // TODO store the move, figure out how to deal with if user backtracks on valid tiles


    }
    else if (recognizer.state == UIGestureRecognizerStateEnded) {
        if (!_validSwipe) {
            NSLog(@"Invalid swipe");
            [self unMarkTiles:_tilesTouched];

//            NSLog(@"Invalid swipe");
            [_tilesTouched removeAllObjects];
            [_moveArray removeAllObjects];
            return;
        }
        if ([_tilesTouched count] < [_uiSettingsDictionary[@"Number of tiles swiped required"] intValue]) {
            NSLog(@"Invalid swipe, not enough tiles swiped!");
            [self unMarkTiles:_tilesTouched];

//            NSLog(@"Invalid swipe, not enough tiles swiped!");

            [_tilesTouched removeAllObjects];
            [_moveArray removeAllObjects];
            if (_moveArray) {
                [self abortSwipeWithMoves:_moveArray];
            }
            return;
        }
//        NSLog(@"Valid swipe, tiles touched: %@", _tilesTouched);
        [self markTiles:_tilesTouched];

        // make final move
        QCMoveDescription *finalMove = [_playingFieldModel takeOneStepAndReturnMoveForID:_currentTileTouched InDirection:_moveDirection];
        [_moveArray addObject:finalMove];


//        [_tilesTouched removeAllObjects];
//        NSLog(@"Valid swipes, moveArray: %@", _moveArray);
        for (QCMoveDescription *moveInspect in _moveArray) {
            NSLog(@"%@", moveInspect);
        }

//        NSLog(@"moveArray: %@", _moveArray);
        [self performAndAnimateMoves:_moveArray];
        [_playingFieldModel updateModelWithMoves:_moveArray];

    }
    else if (recognizer.state == UIGestureRecognizerStateCancelled) {
        [self abortSwipeWithMoves:_moveArray];
    }
    else if (recognizer.state == UIGestureRecognizerStateFailed) {
        [self abortSwipeWithMoves:_moveArray];
    }

//    NSLog(@"Tiles touched: %@", _tilesTouched);
}

-(void) abortSwipeWithMoves:(NSArray *) arrayOfMoves {
    if (!arrayOfMoves) {
        return;
    }
    NSLog(@"Aborted swipe");
    [_playingFieldModel swipeWasAbortedWithMoves:arrayOfMoves];
}

-(void) abortSuctionSwipeWithMoves:(NSArray *) arrayOfSuctionMoves {
    [_playingFieldModel suctionSwipeWasAbortedWithMoves:arrayOfSuctionMoves];
}

-(void) markTiles:(NSSet *) set  {
    if (!set) {
        return;
    }
    for (NSNumber *key in set) {
        [_viewDictionary[key] setAlpha:[_uiSettingsDictionary[@"Alpha of selected tile"] floatValue]];
    }
}

-(void) unMarkTiles:(NSSet *) set {
    if (!set) {
        return;
    }
    for (NSNumber *key in set) {
//        int color = [[_playingFieldModel categoryOfTileWithID:key] intValue];
//        [_viewDictionary[key] setBackgroundColor:_colorArray[color]];
        [_viewDictionary[key] setAlpha:1.0];
    }

}

-(void) performAndAnimateMoves:(NSArray *) moves {
    // remove deleted tiles
//    return;
    for (QCMoveDescription *deleteMove in moves) {
        NSNumber *deleteID = deleteMove.tileToDelete;
        [_viewDictionary[deleteID] removeFromSuperview];
        [_viewDictionary removeObjectForKey:deleteID];
    }

    // create new views
    for (QCMoveDescription *createNew in moves) {
        QCTile *newTile = [_playingFieldModel tileWithID:createNew.createdTileID];
        UIView *newTileView = [self tileViewCreatorXIndex:[newTile.x intValue]
                                                   yIndex:[newTile.y intValue]
                                                       iD:newTile.iD];
        [_holderView addSubview:newTileView];
        [_viewDictionary setObject:newTileView forKey:newTile.iD];
    }

    [self recursionAnimation:moves index:0];

}

-(void) performAndAnimateSuctionMoves:(NSArray *) moves withBooster:(BOOL) booster {
    // remove deleted tiles
    for (QCSuctionMove *deleteMove in moves) {
        NSNumber *deleteID = deleteMove.deletedTile;
        [_viewDictionary[deleteID] removeFromSuperview];
        [_viewDictionary removeObjectForKey:deleteID];
    }

    // change first created tile to booster
    if (booster) {
        NSNumber *boosterTile = [[moves firstObject] createdTile];
        [_playingFieldModel changeToBoosterForID:boosterTile];
    }

    // create new views
    for (QCSuctionMove *createNew in moves) {
        QCTile *newTile = [_playingFieldModel tileWithID:createNew.createdTile];
        UIView *newTileView = [self tileViewCreatorXIndex:[newTile.x intValue]
                                                   yIndex:[newTile.y intValue]
                                                       iD:newTile.iD];
        [_holderView addSubview:newTileView];
        [_viewDictionary setObject:newTileView forKey:newTile.iD];
    }

    // start recursion animation
    [self recursionSuctionAnimation:moves index:0];

}

-(void) recursionAnimation:(NSArray *)moves index:(int) index {
    if (!(index < [moves count])) {
        return;
    }

    QCMoveDescription *move = moves[index];

    float xCenterDisplacement;
    float yCenterDisplacement;
    if ([move.direction isEqualToString:@"up"]) {
        xCenterDisplacement = 0;
        yCenterDisplacement = -_lengthOfTile;
    } else if ([move.direction isEqualToString:@"right"]) {
        xCenterDisplacement = _lengthOfTile;
        yCenterDisplacement = 0;
    } else if ([move.direction isEqualToString:@"down"]) {
        xCenterDisplacement = 0;
        yCenterDisplacement = _lengthOfTile;
    } else if ([move.direction isEqualToString:@"left"]) {
        xCenterDisplacement = -_lengthOfTile;
        yCenterDisplacement = 0;
    }

    [UIView animateWithDuration:[_uiSettingsDictionary[@"Tile animation duration"] floatValue]
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         for (NSNumber *moveKey in move.moveDict) {
                             UIView *aniView = _viewDictionary[moveKey];
                             CGPoint newCenter = CGPointMake(aniView.center.x + xCenterDisplacement, aniView.center.y + yCenterDisplacement);
                             [aniView setCenter:newCenter];                             }

    }
                     completion:^(BOOL finished) {
        [self recursionAnimation:moves index:index + 1];
    }];
}

-(void) recursionSuctionAnimation:(NSArray *) moves index:(int) index{
    if (!(index < [moves count])) {
        _animating = NO;
        return;
    }
    QCSuctionMove *move = moves[index];

    // slows down last move to ease in
    NSUInteger animationStyle;
    float duration;
    if (index == [moves count] - 1) {
        animationStyle = UIViewAnimationOptionCurveEaseOut;
        duration = [_uiSettingsDictionary[@"Suction animation duration"] floatValue] + 0.12;
    } else {
        animationStyle = UIViewAnimationOptionCurveLinear;
        duration = [_uiSettingsDictionary[@"Suction animation duration"] floatValue];
    }


    [UIView animateWithDuration:duration
                          delay:0
                        options:animationStyle
                     animations:^{
                         for (NSNumber *moveKey in move.movementDict) {
                             UIView *aniView = _viewDictionary[moveKey];
                             if (aniView) {
                                 float xCenterDisplacement;
                                 float yCenterDisplacement;
                                 if ([move.movementDict[moveKey] isEqualToString:@"up"]) {
                                     xCenterDisplacement = 0;
                                     yCenterDisplacement = -_lengthOfTile;
                                 } else if ([move.movementDict[moveKey] isEqualToString:@"right"]) {
                                     xCenterDisplacement = _lengthOfTile;
                                     yCenterDisplacement = 0;
                                 } else if ([move.movementDict[moveKey] isEqualToString:@"down"]) {
                                     xCenterDisplacement = 0;
                                     yCenterDisplacement = _lengthOfTile;
                                 } else if ([move.movementDict[moveKey] isEqualToString:@"left"]) {
                                     xCenterDisplacement = -_lengthOfTile;
                                     yCenterDisplacement = 0;
                                 }
                                 CGPoint newCenter = CGPointMake(aniView.center.x + xCenterDisplacement, aniView.center.y + yCenterDisplacement);
                                 [aniView setCenter:newCenter];
                             }
                         }
                     }
                     completion:^(BOOL finished) {
                         [self recursionSuctionAnimation:moves index:index + 1];
                     }];
}

-(void) launchPopOverFromID:(NSNumber *) ID withColor:(UIColor *) color {
    _popOverIsActive = YES;
//    [_holderView bringSubviewToFront:_popOver];

    //    CGRect endFrame = CGRectMake(15, 100, 290, 300);
    UIView *tileView = _viewDictionary[ID];


    UIView *popOverAnimatingView = [[UIView alloc] initWithFrame:tileView.frame];
    [popOverAnimatingView setBackgroundColor:tileView.backgroundColor];
    popOverAnimatingView.layer.cornerRadius = 25;
    popOverAnimatingView.layer.masksToBounds = YES;
    [_holderView addSubview:popOverAnimatingView];


//    _popView = [[QCPopupView alloc] initWithFrame:CGRectMake(20, 10, 280, 350)];
//    [_popView setDelegate:self];
//    QCQuestion *question = [[QCQuestion alloc] initWithCategory:@1 topic:@"Fysik"
//                                                 questionString:@"Vad f\u00f6rs\u00f6ker man hitta i LIGO-experimentet?"
//                                                        answers:@[@"Tyngdv\u00e5gor", @"Higgs-bosoner", @"Liv i rymden", @"Gammastr\u00e5lning"]
//                                             correctAnswerIndex:@0];

    NSNumber *category = [_playingFieldModel categoryOfTileWithID:_currentTileTouched];

    QCQuestion *question = [_questionProvider provideQuestionOfCategory:category];
    _currentQuestion = question;
    [_popView resetAndLoadQuestionStrings:question withFiftyFifty:@(_numberOfFiftyFiftyBoosters)];


    [UIView animateWithDuration:.3
                          delay:0.03
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         popOverAnimatingView.frame = _popView.frame;
                         [popOverAnimatingView setBackgroundColor:_popView.backgroundColor];
                         [popOverAnimatingView setAlpha:.97];

    }
                     completion:^(BOOL finished) {
//                         _popOver.hidden = NO;
//                         [_holderView addSubview:_popView];
                         _popView.hidden = NO;
                         [_holderView bringSubviewToFront:_popView];
                         [popOverAnimatingView removeFromSuperview];
                     }];
}

- (void)playerAnsweredCorrect {
    _answerWasCorrect = YES;
    NSUInteger points = round(pow(1.6, [_tilesTouched count]) * 10) * 10;
    _score += points;
    _scoreLabel.text = [NSString stringWithFormat:@"%ld", _score];
    
    [_popView rightAnswerChosenWithIndex:_currentQuestion.correctAnswerIndex points:@(points)];
    

    _animating = YES;

}

-(void) playerAnsweredWrong {
//    _messageLabel.text = @"Sorry, incorrect answer";
//    _messageLabel.hidden = NO;
    
//    [self abortSuctionSwipeWithMoves:_suctionMoveArray];

    _answerWasCorrect = NO;
//    if (_numberOfMovesMade >= [_uiSettingsDictionary[@"Max number of moves"] intValue]) {
//        [self gameOver];
//    }
}

//-(void) answerPopButtonHandler:(id) sender {
////    UIButton *senderButton = (UIButton *) sender;
//    _popOver.hidden = YES;
//    _popOverIsActive = NO;
//    [self unMarkTiles:_tilesTouched];
//
//    _numberOfMovesMade += 1;
//    _movesLeftLabel.text = [NSString stringWithFormat:@"%d", [_uiSettingsDictionary[@"Max number of moves"] intValue] - _numberOfMovesMade];
//
//    int outcome = arc4random_uniform(3);
//    if (outcome == 0) {
//        [self playerAnsweredWrong];
//    } else {
//        [self playerAnsweredCorrect];
//    }
//
////    switch (senderButton.tag) {
////        case 1001: {
////            [self playerAnsweredCorrect];
////            break;
////        }
////        case 2002: {
////            [self playerAnsweredCorrect];
////
//////            NSLog(@"Rätt svar X");
//////            _animating = YES;
//////            if ([_tilesTouched count] >= 3) {
//////                NSNumber *tileToChangeToBooster = [_playingFieldModel changeHeadOfSnakeToBoosterAndReturnItForMove:[_suctionMoveArray lastObject]];
//////                [self changeTileToBooster:tileToChangeToBooster];
//////            }            [self performAndAnimateSuctionMoves:_suctionMoveArray];
//////            [_playingFieldModel updateModelWithSuctionMoves:_suctionMoveArray];
////            break;
////        }
////        case 3003: {
////            NSLog(@"Fel svar 2");
////            _messageLabel.hidden = NO;
////            _messageLabel.text = @"Sorry, incorrect answer";
////            [self abortSuctionSwipeWithMoves:_suctionMoveArray];
////            break;
////        }
////    }
//}

//-(void) playerAnsweredCorrect {
//
//}

-(void) changeTileToBooster:(NSNumber *) ID {
    UIView *tile = _viewDictionary[ID];
    tile.backgroundColor = [UIColor blackColor];
}

-(void) gameOver {
//    NSString *string;
    if (_score >= [_uiSettingsDictionary[@"Score required"] intValue]) {
////        string = @"Good Job! Level accomplished";
//        _messageLabel.hidden = NO;
//        _messageLabel.text = @"Good Job! Level accomplished";
//
//        for (UIGestureRecognizer *rec in _holderView.gestureRecognizers) {
//            [_holderView removeGestureRecognizer:rec];
//        }
        
        [self launchStartNewGame:@"Good Job! Level accomplished"];

    } else {
//        string = @"Out of moves...";
        UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"Out of moves"
                                                            message:@"Would you like to buy five more moves?"
                                                           delegate:self
                                                  cancelButtonTitle:@"No, thank you"
                                                  otherButtonTitles:@"Yes, please!", nil];
        alertview.tag = 202;
        [alertview show];
    }

}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"Index of button clicked: %ld", buttonIndex);
    NSLog(@"Alertview tag: %ld", alertView.tag);
    
    if (alertView.tag == 202) {
        if (buttonIndex == 0) {
//            for (UIGestureRecognizer *rec in _holderView.gestureRecognizers) {
//                [_holderView removeGestureRecognizer:rec];
//            }
//            _messageLabel.hidden = NO;
//            _messageLabel.text = @"Game over";
            [self launchStartNewGame:@"Out of moves"];
            
        } else if (buttonIndex == 1) {
            _numberOfMovesMade -= 5;
            [self updateMovesLeftLabel];
        }
    } else if (alertView.tag == 3003) {
        NSLog(@"Start new game");
        [self startNewGame];
    }
    
}

-(void) launchStartNewGame:(NSString *) message {
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"Game over"
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:@"Play again!"
                                              otherButtonTitles:nil];
    alertview.tag = 3003;
    [alertview show];
}

-(void) startNewGame {
    [self resetGameplayVariables];
    [self resetMessages];
    [self resetState];
    [self updateFiftyButtonState];
    
    // select all tiles
    NSMutableSet *selectionSet = [[NSMutableSet alloc] init];
    for (NSNumber *selectKey in _viewDictionary) {
        [selectionSet addObject:selectKey];
    }
    
    
    // identify if new tiles have been created and give them a view etc
    //    NSSet *newTiles = [_playingFieldModel getNewTilesReplacing:selectionSet];
    NSSet *newTiles = [_playingFieldModel getNewTilesReplacing:selectionSet excludingCategory:nil withBooster:NO];
    
    
    for (NSNumber *addNewKey in newTiles) {
        QCTile *newTile = [_playingFieldModel tileWithID:addNewKey];
        int x = [newTile.x intValue];
        int y = [newTile.y intValue];

        UIView *newView = [self tileViewCreatorXIndex:x yIndex:y iD:addNewKey];
        [_viewDictionary setObject:newView
                            forKey:addNewKey];
        [_holderView addSubview:newView];
    }
    
    
    // dict with ids of tiles to move, with their corresponding moves
    NSDictionary *animateDict = [_playingFieldModel removeAndReturnVerticalTranslations:selectionSet];
    
    
    for (NSNumber *key in selectionSet) {
        UIView * view = _viewDictionary[key];
        //        [view setBackgroundColor:[UIColor blackColor]];
        [view removeFromSuperview];
        [_viewDictionary removeObjectForKey:key];
    }
    
//    [self seedAvatar];
//    NSNumber *avatarID = [_playingFieldModel IDOfAvatar];
//    QCTile *avatarTile = [_playingFieldModel tileWithID:avatarID];
//    
//    UIView *view = _viewDictionary[avatarID];
//    [view removeFromSuperview];
//    UIView *avatarView = [self tileViewCreatorXIndex:[avatarTile.x intValue]
//                                              yIndex:[avatarTile.y intValue] - [_numberOfRows intValue]
//                                                  iD:avatarID];
//    [_holderView addSubview:avatarView];
//    [_viewDictionary setObject:avatarView forKey:avatarID];

    
    _animating = YES;
    
    
    [UIView animateWithDuration:1
                     animations:^{
                         for (NSNumber *aniKey in animateDict) {
                             UIView *aniView = _viewDictionary[aniKey];
                             CGPoint newCenter = CGPointMake(aniView.center.x, aniView.center.y + [animateDict[aniKey] intValue] * _lengthOfTile);
                             [aniView setCenter:newCenter];
                         }
                     }completion:^(BOOL finished) {
                         _animating = NO;
                     }
     ];
}

- (void)updateFiftyButtonState {
    if (_numberOfFiftyFiftyBoosters >= 1) {
        _fiftyFiftyButton.hidden = NO;
    } else {
        _fiftyFiftyButton.hidden = YES;
    }
    
    if (_numberOfFiftyFiftyBoosters >= 2) {
        _fiftyXLabel.text = [NSString stringWithFormat:@"X %d", _numberOfFiftyFiftyBoosters];
        _fiftyXLabel.hidden = NO;
    } else {
        _fiftyXLabel.hidden = YES;
    }
}

- (IBAction)fiftyFiftyButtonHandler:(id)sender {
    if (!_popOverIsActive || _fiftyUsed) {
        return;
    }
    _fiftyUsed = YES;
    [_popView invokeFiftyFifty];
    _numberOfFiftyFiftyBoosters -= 1;
    
    [self updateFiftyButtonState];
}

@end
