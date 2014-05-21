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

@property (weak, nonatomic) IBOutlet QCTileHolderView *holderView;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *movesLeftLabel;

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@property QCPopupView *popView;
@property QCSelectCategoryPopup *selectCategoryPopup;

@property QCQuestionProvider *questionProvider;
@property QCTileImageProvider *imageProvider;

@property QCQuestion *currentQuestion;

@property NSMutableDictionary *viewDictionary;
@property NSDictionary *uiSettingsDictionary;
@property (nonatomic) NSDictionary *levelSettingsDictionary;
@property QCPlayingFieldModel *playingFieldModel;
@property float lengthOfTile;
@property NSNumber *numberOfRows;
@property NSNumber *numberOfColumns;
@property NSNumber *tilesRequiredToMatch;
@property BOOL animating;
@property BOOL validSwipe;
@property NSMutableSet *tilesTouched;
@property NSSet *matchingTiles;
@property NSNumber *currentTileTouched;
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
@property (weak, nonatomic) IBOutlet UIButton *fiftyFiftyButton;
- (IBAction)fiftyFiftyButtonHandler:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *fiftyXLabel;
@property BOOL fiftyUsed;
@property int animatingCount;
@property (nonatomic) NSMutableSet *slimeSet;
@property (nonatomic) NSString *levelDocument;

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
    _movesLeftLabel.text = [NSString stringWithFormat:@"%d", [_levelSettingsDictionary[@"Max number of moves"] intValue] - _numberOfMovesMade];
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
    NSNumber *booster = nil;
//    if (_answerWasCorrect) {
//        if ([_tilesTouched count] >= 5) {
//            booster = @8;
//        } else if ([_tilesTouched count] == 4) {
//            _numberOfFiftyFiftyBoosters += 1;
//        } else if ([_tilesTouched count] == 3) {
//            booster = @7;
//        }
//    }
    
    // only 50/50
    if (_answerWasCorrect && [_tilesTouched count] >= 7) {
        _numberOfFiftyFiftyBoosters += 1;
        [self animateFiftyButton];
    }
    
    
    // not sure if this should be here...
    _fiftyUsed = NO;
    [self updateFiftyButtonState];
    
//    [self swipeDeleteTiles:_tilesTouched withBooster:booster];
//    [self swipeFallingDeleteTiles:_tilesTouched withBooster:booster];
    
    [self removeAllTileConnections];
    
    // slime management
    if (_answerWasCorrect) {
        for (NSNumber *key in _tilesTouched) {
            QCTile *tile = [_playingFieldModel tileWithID:key];
            QCCoordinates *coord = [[QCCoordinates alloc] initWithX:tile.x Y:tile.y];
            for (QCSlimeTile *slimeTile in _slimeSet) {
                if ([slimeTile.coordinates isEqualToCoordinates:coord]) {
                    [slimeTile.view removeFromSuperview];
                    [_slimeSet removeObject:slimeTile];
                    break;
                }
            }
        }
        
    }
    
    
    
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
//    double duration = 4;//0.7;
    double duration = [_uiSettingsDictionary[@"Duration of one falling spring tile"] doubleValue];
    
    for (NSNumber *animateKey in animateDict) {
        float steps = [animateDict[animateKey] floatValue];
        UIView *view = _viewDictionary[animateKey];
        CGPoint newCenter = CGPointMake(view.center.x, view.center.y + _lengthOfTile * steps);
        
        [UIView animateWithDuration:duration * steps
                              delay:delay
             usingSpringWithDamping:0.5 //0.6
              initialSpringVelocity:0.1
                            options:UIViewAnimationOptionCurveLinear //UIViewAnimationOptionCurveEaseIn
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
    int movesLeft = [_levelSettingsDictionary[@"Max number of moves"] intValue] - _numberOfMovesMade;
    _movesLeftLabel.text = [NSString stringWithFormat:@"%d", movesLeft]; //[_uiSettingsDictionary[@"Max number of moves"] intValue]];
//    _messageLabel.text = [NSString stringWithFormat:@"Reach %d points!"/* to clear level!"*/, [_uiSettingsDictionary[@"Score required"] intValue]];
    _messageLabel.hidden = NO;
    _scoreLabel.text = [NSString stringWithFormat:@"%ld", _score];
//    _messageLabel.text = @"Clear away all the slime!";
    if ([_levelSettingsDictionary[@"Type of level"] isEqualToString:@"SLIME"]) {
        _messageLabel.text = _levelSettingsDictionary[@"Header message"];
    } else if ([_levelSettingsDictionary[@"Type of level"] isEqualToString:@"SCORE"]) {
        _messageLabel.text = [NSString stringWithFormat:_levelSettingsDictionary[@"Header message"], _levelSettingsDictionary[@"Score required"]];
    }
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

- (void) resetSlime
{
    if (![_levelSettingsDictionary[@"Type of level"] isEqualToString:@"SLIME"]) {
        return;
    }
    
    for (QCSlimeTile *tile in _slimeSet) {
        [tile.view removeFromSuperview];
    }
    [_slimeSet removeAllObjects];
    
//    NSArray *slimeArr = @[@0, @0, @1, @1, @2, @2, @3, @3, @4, @2, @5, @1, @6, @0];
//    NSArray *slimeArr = @[@1, @2, @5, @2, @2, @3, @4, @3, @3, @4, @2, @5, @4, @5, @1, @6, @5, @6];
    NSArray *slimeArr = _levelSettingsDictionary[@"Slime array"];
    //    NSMutableArray *interSlime = [[NSMutableArray alloc] init];
    for (int ind = 0; ind < [slimeArr count]; ind += 2) {
        QCCoordinates *c = [[QCCoordinates alloc] initWithX:slimeArr[ind] Y:slimeArr[ind + 1]];
        QCSlimeTile *slimeObj = [[QCSlimeTile alloc] init];
        slimeObj.coordinates = c;
        [_slimeSet addObject:slimeObj];
    }
    
    for (QCSlimeTile *slime in _slimeSet) {
        UIView *slimeView = [[UIView alloc] initWithFrame:CGRectMake([slime.coordinates.x intValue] * _lengthOfTile, [slime.coordinates.y intValue] * _lengthOfTile, _lengthOfTile, _lengthOfTile)];
        slimeView.backgroundColor = [UIColor blackColor];
        slimeView.alpha = .5;
        slimeView.layer.masksToBounds = YES;
        slimeView.layer.cornerRadius = 9;
        slime.view = slimeView;
        [_holderView addSubview:slimeView];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSString *plistCatPath = [[NSBundle mainBundle] pathForResource:@"UISettings" ofType:@"plist"];
    _uiSettingsDictionary = [[NSDictionary alloc] initWithContentsOfFile:plistCatPath];

    NSString *levelPath = [[NSBundle mainBundle] pathForResource:_levelDocument
                                                             ofType:@"plist"];
    _levelSettingsDictionary = [[NSDictionary alloc] initWithContentsOfFile:levelPath];

    // background
    UIImage *background = [UIImage imageNamed:@"QC_background"];
    UIImageView *bgView = [[UIImageView alloc] initWithImage:background];
    [self.view addSubview:bgView];
    [self.view sendSubviewToBack:bgView];

    _numberOfRows = _levelSettingsDictionary[@"Number of rows"];
    _numberOfColumns = _levelSettingsDictionary[@"Number of columns"];
    _tilesRequiredToMatch = _levelSettingsDictionary[@"Number of tiles required to match"];

    // set up holder views dimensions
//    _lengthOfTile = self.view.frame.size.width / [_levelSettingsDictionary[@"Number of columns"] floatValue];
    _lengthOfTile = 45.7142868;
    float frameHeight = [_levelSettingsDictionary[@"Number of rows"] floatValue] * _lengthOfTile;
    CGRect holderFrame = CGRectMake(0, self.view.frame.size.height / 2.0f - frameHeight / 2.0f, _lengthOfTile * [_numberOfColumns floatValue], frameHeight);
    _holderView.frame = holderFrame;
    _holderView.center = self.view.center;



//    _playingFieldModel = [[QCPlayingFieldModel alloc] initWithRows:_numberOfRows Columns:_numberOfColumns];
    _playingFieldModel = [[QCPlayingFieldModel alloc] initWithRows:_numberOfRows
                                                           Columns:_numberOfColumns
                                                     levelDocument:_levelDocument];
    
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
//    _moveArray = [[NSMutableArray alloc] init];
//    _moveDirection = [[NSString alloc] init];
//
//    // suction action
//    _suctionMoveArray = [[NSMutableArray alloc] init];
    
    // even newer pan handler
    UIPanGestureRecognizer *diagonalSwipePanHandler = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(diagonalSwipeDeletePanHandler:)];
    [_holderView addGestureRecognizer:diagonalSwipePanHandler];
    
    // tap action for boosters
    UITapGestureRecognizer *boosterTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(boosterTapHandler:)];
    [_holderView addGestureRecognizer:boosterTapRecognizer];

    // slime
    _slimeSet = [[NSMutableSet alloc] init];
    [self resetSlime];

    
    
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

    // new popups
    _popupFrame = CGRectMake(0, 0, 280, 350);
    _popView = [[QCPopupView alloc] initWithFrame:_popupFrame];
    _popView.center = _holderView.center;
    [_popView setDelegate:self];
    _popView.hidden = YES;
//    [_holderView addSubview:_popView];
    [self.view addSubview:_popView];

    _selectCategoryPopup = [[QCSelectCategoryPopup alloc] initWithFrame:_popupFrame];
    [_selectCategoryPopup setDelegate:self];
    _selectCategoryPopup.hidden = YES;
    [_holderView addSubview:_selectCategoryPopup];

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
//        
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
    if ([_levelSettingsDictionary[@"Type of level"] isEqualToString:@"SLIME"]) {
        if ([_slimeSet count] <= 0) {
            [self gameOverLevelAccomplished:YES];
            return;
        }
    } else if ([_levelSettingsDictionary[@"Type of level"] isEqualToString:@"SCORE"]) {
        if (_score >= [_levelSettingsDictionary[@"Score required"] intValue]) {
            [self gameOverLevelAccomplished:YES];
            return;
        }
    }
    
    if (_numberOfMovesMade >= [_levelSettingsDictionary[@"Max number of moves"] intValue]) {
        [self gameOverLevelAccomplished:NO];
    }


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

-(void) finishAvatarSwipe {
    NSLog(@"Spelplan innan delete:\n%@", _playingFieldModel);
    [_playingFieldModel swapPositionsOfTile:[_playingFieldModel IDOfAvatar] andTile:_currentTileTouched];
    NSLog(@"Spelplan efter swap:\n%@", _playingFieldModel);
    [_tilesTouched addObject:_currentTileTouched];
//    [self swipeDeleteTiles:_tilesTouched withBooster:nil];
    NSLog(@"Spelplan efter delete:\n%@", _playingFieldModel);
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
   
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        [self unMarkTiles:_tilesTouched];
        [self removeAllTileConnections];
        //        NSLog(@"Unmarking tiles: %@", _tilesTouched);
        [_tilesTouched removeAllObjects];
        //        [_moveArray removeAllObjects];
//        [_suctionMoveArray removeAllObjects];
        
        
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
        // lets see if this fixes bug...
        if (!newTileTouched) {
            return;
        }
        
        if ([newTileTouched isEqualToNumber:_currentTileTouched]) {
            return;
        }

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

        
        [self connectTile:_currentTileTouched toTile:newTileTouched];
        _currentTileTouched = newTileTouched;
        [_tilesTouched addObject:newTileTouched];
        [self markTiles:_tilesTouched];
        
        
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded) {
        NSLog(@"Swipe state ended, current tile touched: %@", _currentTileTouched);
        
        if (!_validSwipe) {
            NSLog(@"Invalid swipe");
            [self unMarkTiles:_tilesTouched];
            [self removeAllTileConnections];
            
            //            NSLog(@"Invalid swipe");
            [_tilesTouched removeAllObjects];
            //            [_moveArray removeAllObjects];
            //            [_suctionMoveArray removeAllObjects];
            return;
        }
        if ([_tilesTouched count] < [_levelSettingsDictionary[@"Number of tiles swiped required"] intValue]) {
            NSLog(@"Invalid swipe, not enough tiles swiped!");
            [self unMarkTiles:_tilesTouched];
            [self removeAllTileConnections];
            
            [_tilesTouched removeAllObjects];
           
            return;
        }

        [self markTiles:_tilesTouched];
        
        if (!_currentTileTouched || ![_playingFieldModel categoryOfTileWithID:_currentTileTouched]) {
            return;
        }
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
                [self bombBoosterHandling:tileTouched];
                return;
            } else if ([category isEqualToNumber:@8]) {
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
    // for now
    return;
    
    if (!set) {
        return;
    }
    for (NSNumber *key in set) {
        [_viewDictionary[key] setAlpha:[_uiSettingsDictionary[@"Alpha of selected tile"] floatValue]];
    }
}

-(void) unMarkTiles:(NSSet *) set {
    // for now
    return;
    
    if (!set) {
        return;
    }
    for (NSNumber *key in set) {
        [_viewDictionary[key] setAlpha:1.0];
    }

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


    _animating = YES;
    
    _popOverIsActive = YES;
//    [_holderView bringSubviewToFront:_popOver];

    //    CGRect endFrame = CGRectMake(15, 100, 290, 300);
    UIView *tileView = _viewDictionary[ID];


    UIView *popOverAnimatingView = [[UIView alloc] initWithFrame:tileView.frame];
    [popOverAnimatingView setBackgroundColor:tileView.backgroundColor];
    popOverAnimatingView.layer.cornerRadius = 25;
    popOverAnimatingView.layer.masksToBounds = YES;
    [_holderView addSubview:popOverAnimatingView];

//    CGPoint center = [self.view convertPoint:self.view.center toView:_holderView];
    CGPoint center = [_holderView convertPoint:self.view.center fromView:self.view];
    CGRect frame = CGRectMake(center.x - 0.5 * _popView.frame.size.width, center.y - 0.5 * _popView.frame.size.height, _popView.frame.size.width, _popView.frame.size.height);   //_popView.frame;
    
    NSNumber *category = [_playingFieldModel categoryOfTileWithID:ID];  //_currentTileTouched];
  
    QCQuestion *question = [_questionProvider provideQuestionOfCategory:category];
    _currentQuestion = question;
    [_popView resetAndLoadQuestionStrings:question withFiftyFifty:@(_numberOfFiftyFiftyBoosters)];


    [UIView animateWithDuration:.3
                          delay:0.03
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
//                         popOverAnimatingView.frame = _popView.frame;
                         popOverAnimatingView.frame = frame;
//                         popOverAnimatingView.center = center;
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
//    NSUInteger points = round(pow(1.6, [_tilesTouched count]) * 10) * 10;
    NSUInteger points = round(pow(1.45, [_tilesTouched count]) * 17) * 10;
    _score += points;
    _scoreLabel.text = [NSString stringWithFormat:@"%ld", _score];
    
    [_popView rightAnswerChosenWithIndex:_currentQuestion.correctAnswerIndex points:@(points)];
    

    _animating = YES;

}

-(void) playerAnsweredWrong {
    _answerWasCorrect = NO;
}

-(void) changeTileToBooster:(NSNumber *) ID {
    UIView *tile = _viewDictionary[ID];
    tile.backgroundColor = [UIColor blackColor];
}

-(void) gameOverLevelAccomplished:(BOOL) accomplished {
    if (accomplished) {

        [self launchStartNewGameWithTitle:@"Level accomplished!" message:@""];

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
            [self launchStartNewGameWithTitle:@"Game over" message:@"Out of moves"];
            
        } else if (buttonIndex == 1) {
            _numberOfMovesMade -= 5;
            [self updateMovesLeftLabel];
        }
    } else if (alertView.tag == 3003) {
        NSLog(@"Start new game");
        if (buttonIndex == 0) {
            [self startNewGame];
        } else if (buttonIndex == 1) {
            NSLog(@"Go back to level switcher");
            [self dismissViewControllerAnimated:NO completion:^{
                
            }];
        }
    }
    
}

-(void) launchStartNewGameWithTitle:(NSString *) title message:(NSString *) message {
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:title //@"Game over"
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:@"Play again!"
                                              otherButtonTitles:@"Choose level", nil];
    alertview.tag = 3003;
    [alertview show];
}

-(void) startNewGame {
    [self resetGameplayVariables];
    [self resetMessages];
    [self resetState];
    [self updateFiftyButtonState];
    [self resetSlime];
    
    // select all tiles
    NSMutableSet *selectionSet = [[NSMutableSet alloc] init];
    for (NSNumber *selectKey in _viewDictionary) {
        [selectionSet addObject:selectKey];
    }

    // identify if new tiles have been created and give them a view etc
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
     _animating = YES;
    
    
    [UIView animateWithDuration:1
                     animations:^{
                         for (NSNumber *aniKey in animateDict) {
                             UIView *aniView = _viewDictionary[aniKey];
                             CGPoint newCenter = CGPointMake(aniView.center.x, aniView.center.y + [animateDict[aniKey] intValue] * _lengthOfTile);
                             [aniView setCenter:newCenter];
                         }
                     } completion:^(BOOL finished) {
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

-(void) animateFiftyButton {
    [UIView animateWithDuration:0.2
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _fiftyFiftyButton.transform = CGAffineTransformMakeScale(1.5, 1.5);
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.3
                                               delay:0.1
                                             options:UIViewAnimationOptionCurveEaseInOut
                                          animations:^{
                                              _fiftyFiftyButton.transform = CGAffineTransformMakeScale(1, 1);
                                          } completion:^(BOOL finished) {
                                              
                                          }];
                     }];
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

-(void) connectTile:(NSNumber *) tile1 toTile:(NSNumber *) tile2 {
    UIView *view1 = _viewDictionary[tile1];
    UIView *view2 = _viewDictionary[tile2];
    [_holderView drawLineFromX1:view1.center.x
                             Y1:view1.center.y
                             X2:view2.center.x
                             Y2:view2.center.y];
}

-(void) removeAllTileConnections {
    [_holderView removeAllLines];
}

-(void) setLevelDocument:(NSString *) document {
//    NSString *plistCatPath = [[NSBundle mainBundle] pathForResource:document
//                                                             ofType:@"plist"];
//    _levelSettingsDictionary = [[NSDictionary alloc] initWithContentsOfFile:plistCatPath];
    _levelDocument = document;
}

@end







