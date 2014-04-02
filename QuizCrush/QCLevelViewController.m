//
//  QCLevelViewController.m
//  QuizCrush
//
//  Created by Arvid on 2014-03-17.
//  Copyright (c) 2014 Planeto. All rights reserved.
//

#import "QCLevelViewController.h"

@interface QCLevelViewController ()

@property (weak, nonatomic) IBOutlet UIView *holderView;
//@property NSMutableArray *viewArray;
//@prperty (weak, nonatomic) IBOutlet UIView *popup;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@property UIView *popOver;

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
@property BOOL vaildSwipe;
@property NSMutableSet *tilesTouched;
@property NSSet *matchingTiles;
@property NSNumber *currentTileTouched;
@property NSMutableArray *moveArray;
@property NSString *moveDirection;
@property NSMutableArray *suctionMoveArray;
@property BOOL popOverIsActive;
@property BOOL boosterIsActive;
@property NSNumber *selectedBoosterTile;

@end

@implementation QCLevelViewController



- (UIView *)tileViewCreatorXIndex:(int)xIndex yIndex:(int)yIndex iD:(NSNumber *)iD
{
    UIView *tile = [[UIView alloc] initWithFrame:CGRectMake(xIndex * _lengthOfTile, yIndex * _lengthOfTile, _lengthOfTile, _lengthOfTile)];
    tile.layer.cornerRadius = 17.0;
    tile.layer.masksToBounds = YES;
    //        NSNumber *category = [_playingFieldModel categoryOfTileAtPosition:[NSNumber numberWithInt:i]];
    NSNumber *category = [_playingFieldModel categoryOfTileWithID:iD];

    UIColor *color;
    // check if a booster has been created
    if ([category isEqualToNumber:@7]) {
//        [self changeTileToBooster:iD];
        color = [UIColor blackColor];
    } else {
        color = _colorArray[[category intValue]];
    }
 
    [tile setBackgroundColor:color];

    return tile;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSString *plistCatPath = [[NSBundle mainBundle] pathForResource:@"UISettings" ofType:@"plist"];
    _uiSettingsDictionary = [[NSDictionary alloc] initWithContentsOfFile:plistCatPath];

    _colorArray = @[[UIColor orangeColor], [UIColor purpleColor], [UIColor greenColor], [UIColor brownColor], [UIColor blueColor], [UIColor yellowColor]];

    // set up holder views dimensions
    _lengthOfTile = self.view.frame.size.width / [_uiSettingsDictionary[@"Number of columns"] floatValue];
    float frameHeight = [_uiSettingsDictionary[@"Number of rows"] floatValue] * _lengthOfTile;
    CGRect holderFrame = CGRectMake(0, self.view.frame.size.height / 2.0f - frameHeight / 2.0f, self.view.frame.size.width, frameHeight);
    _holderView.frame = holderFrame;
    
    
    _numberOfRows = _uiSettingsDictionary[@"Number of rows"];
    _numberOfColumns = _uiSettingsDictionary[@"Number of columns"];
    _tilesRequiredToMatch = _uiSettingsDictionary[@"Number of tiles required to match"];
    
    _playingFieldModel = [[QCPlayingFieldModel alloc] initWithRows:_numberOfRows Columns:_numberOfColumns];
    _viewDictionary = [[NSMutableDictionary alloc] init];

    // swipe handling properties
    _animating = NO;
    _tilesTouched = [[NSMutableSet alloc] init];
    _moveArray = [[NSMutableArray alloc] init];
    _moveDirection = [[NSString alloc] init];
    
    // suction action
    _suctionMoveArray = [[NSMutableArray alloc] init];

    // pan action for suction
    UIPanGestureRecognizer *suctionPanRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(suctionPanHandler:)];
    suctionPanRecognizer.maximumNumberOfTouches = 1;
    [_holderView addGestureRecognizer:suctionPanRecognizer];
    
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
    
    

    // for popup dialogue
    _popOverIsActive = NO;
    _popOver = [[UIView alloc] initWithFrame:CGRectMake(15, 25, 300, 300)];
    [_popOver setBackgroundColor:[UIColor whiteColor]];
    _popOver.layer.cornerRadius = 25;
    _popOver.layer.masksToBounds = YES;
    _popOver.hidden = YES;
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeSystem];
    button1.frame = CGRectMake(70, 70, 150, 40);
    [button1 setTitle:@"Answer 1" forState:UIControlStateNormal];
    [button1 setTintColor:[UIColor blackColor]];
    button1.backgroundColor = [UIColor grayColor]; //[UIColor greenColor];
    button1.layer.masksToBounds = YES;
    button1.layer.cornerRadius = 15;
    button1.tag = 1001;
    
    UIButton *buttonX = [UIButton buttonWithType:UIButtonTypeSystem];
    buttonX.frame = CGRectMake(70, 140, 150, 40);
    [buttonX setTitle:@"Answer 2" forState:UIControlStateNormal];
    [buttonX setTintColor:[UIColor blackColor]];
    buttonX.backgroundColor = [UIColor grayColor]; //[UIColor purpleColor];
    buttonX.layer.masksToBounds = YES;
    buttonX.layer.cornerRadius = 15;
    buttonX.tag = 2002;
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeSystem];
    button2.frame = CGRectMake(70, 210, 150, 40);
    [button2 setTitle:@"Answer 3" forState:UIControlStateNormal];
    [button2 setTintColor:[UIColor blackColor]];
    button2.backgroundColor = [UIColor grayColor]; //[UIColor blueColor];
    button2.layer.masksToBounds = YES;
    button2.layer.cornerRadius = 15;
    button2.tag = 3003;
    
    [_popOver addSubview:button1];
    [_popOver addSubview:buttonX];
    [_popOver addSubview:button2];
    
    [button1 addTarget:self
                action:@selector(answerButtonHandler:)
      forControlEvents:UIControlEventTouchUpInside];
    [buttonX addTarget:self
                action:@selector(answerButtonHandler:)
      forControlEvents:UIControlEventTouchUpInside];
    [button2 addTarget:self
                action:@selector(answerButtonHandler:)
      forControlEvents:UIControlEventTouchUpInside];
    
    [_holderView addSubview:_popOver];

    // for booster
    _boosterIsActive = NO;
}




- (void)deleteTiles:(NSNumber *)IDTileClicked {
    NSSet *selectionSet = [_playingFieldModel matchingAdjacentTilesToTileWithID:IDTileClicked];
    if ([selectionSet count] < [_tilesRequiredToMatch intValue]) {
        return;
    }

    // identify if new tiles have been created and give them a view etc
//    NSSet *newTiles = [_playingFieldModel getNewTilesReplacing:selectionSet];
    NSSet *newTiles = [_playingFieldModel getNewTilesReplacing:selectionSet excludingCategory:nil];

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

-(void) deleteTheBoosterTile:(NSNumber *) boosterTile excludingCategory:(NSNumber *) excludeCategory {
    NSSet *selectionSet = [NSSet setWithObject:boosterTile];
    // identify if new tiles have been created and give them a view etc
    NSSet *newTiles = [_playingFieldModel getNewTilesReplacing:selectionSet
                                             excludingCategory:excludeCategory];
    
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
                     }];
}


- (void)boosterDeleteTiles:(NSNumber *)IDTileClicked {
    NSSet *selectionSet = [_playingFieldModel matchingAdjacentTilesToTileWithID:IDTileClicked];
//    if ([selectionSet count] < [_tilesRequiredToMatch intValue]) {
//        return;
//    }
    
    // identify if new tiles have been created and give them a view etc
    NSSet *newTiles = [_playingFieldModel getNewTilesReplacing:selectionSet
                                             excludingCategory:[_playingFieldModel categoryOfTileWithID:IDTileClicked]];
    
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

-(NSDictionary *) gridPositionOfPoint: (CGPoint)point numberOfRows:(NSNumber *)numberOfRows
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
        
        
        _vaildSwipe = YES;
        //        NSNumber *firstTile = [_playingFieldModel iDOfTileAtX:x Y:y];
        _currentTileTouched = [_playingFieldModel iDOfTileAtX:x Y:y];
        
        [_tilesTouched addObject:_currentTileTouched];
        _matchingTiles = [_playingFieldModel matchingAdjacentTilesToTileWithID:_currentTileTouched];
    }
    
    else if (recognizer.state == UIGestureRecognizerStateChanged) {
        if (!_vaildSwipe) {
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
            _vaildSwipe = NO;
//            if (_moveArray) {
//                [self abortSwipeWithMoves:_moveArray];
//            }
            [self abortSuctionSwipeWithMoves:_suctionMoveArray];
            return;
        }
        
        // cancel booster action if player wants to swipe instead
        _boosterIsActive = NO;
        _messageLabel.hidden = YES;
        
        if (![_playingFieldModel tilesAreAdjacentID1:_currentTileTouched ID2:newTileTouched]) {
            _vaildSwipe = NO;
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
            _vaildSwipe = NO;
            return;
        }
        // prevent stepping on tail
        NSNumber *testOnTailID = [_playingFieldModel IDOfTileDuringMotionAtX:x Y:y];
        if ([[[_suctionMoveArray lastObject] tailArray] containsObject:testOnTailID]) {
            NSLog(@"Can't hit your own tail!");
            [self abortSuctionSwipeWithMoves:_suctionMoveArray];
            _vaildSwipe = NO;
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
        if (!_vaildSwipe) {
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

-(void) boosterTapHandler:(UITapGestureRecognizer *) recognizer {
//    NSLog(@"Spelplanen: \n%@", _playingFieldModel);
    
    CGPoint point = [recognizer locationInView:_holderView];
    NSDictionary *touchPoint = [self gridPositionOfPoint:point
                                            numberOfRows:_numberOfRows
                                         numberOfColumns:_numberOfColumns
                                           lengthOfSides:_lengthOfTile];

    NSNumber *tileTouched = [_playingFieldModel iDOfTileAtX:touchPoint[@"x"] Y:touchPoint[@"y"]];
    
    if (!_boosterIsActive) {
        if (![[_playingFieldModel categoryOfTileWithID:tileTouched] isEqualToNumber:@7]) {
            return;
        }
        _messageLabel.hidden = NO;
        _messageLabel.text = @"Tap squares you want to remove!";
        NSLog(@"Booster!");
        _boosterIsActive = YES;
        _selectedBoosterTile = tileTouched;
        return;
    }
    
    // booster is active, let user tap a tile, find surrounding tiles and remove them
    if ([[_playingFieldModel categoryOfTileWithID:tileTouched] isEqualToNumber:@7]) {
        return;
    }

//    [self deleteTheBoosterTile:_selectedBoosterTile excludingCategory:[_playingFieldModel categoryOfTileWithID:tileTouched]];
    [self boosterDeleteTiles:tileTouched];
    _messageLabel.hidden = YES;
    _boosterIsActive = NO;
//    NSLog(@"Spelplanen: \n%@", _playingFieldModel);

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

        _vaildSwipe = YES;
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
        if (!_vaildSwipe) {
            return;
        }
        NSNumber *newTileTouched = [_playingFieldModel iDOfTileAtX:x Y:y];
        if ([newTileTouched isEqualToNumber:_currentTileTouched]) {
            return;
        }
        if (![_matchingTiles member:newTileTouched]) {
            _vaildSwipe = NO;
            if (_moveArray) {
                [self abortSwipeWithMoves:_moveArray];
            }
            return;
        }
        if (![_playingFieldModel tilesAreAdjacentID1:_currentTileTouched ID2:newTileTouched]) {
            _vaildSwipe = NO;
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
            _vaildSwipe = NO;
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
        if (!_vaildSwipe) {
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

-(void) performAndAnimateSuctionMoves:(NSArray *) moves {
    // remove deleted tiles
    for (QCSuctionMove *deleteMove in moves) {
        NSNumber *deleteID = deleteMove.deletedTile;
        [_viewDictionary[deleteID] removeFromSuperview];
        [_viewDictionary removeObjectForKey:deleteID];
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
    [_holderView bringSubviewToFront:_popOver];
    
    //    CGRect endFrame = CGRectMake(15, 100, 290, 300);
    UIView *tileView = _viewDictionary[ID];
    
    
    UIView *popOverAnimatingView = [[UIView alloc] initWithFrame:tileView.frame];
    [popOverAnimatingView setBackgroundColor:tileView.backgroundColor];
    popOverAnimatingView.layer.cornerRadius = 25;
    popOverAnimatingView.layer.masksToBounds = YES;
    [_holderView addSubview:popOverAnimatingView];
    
    
    [UIView animateWithDuration:.3
                          delay:0.03
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         popOverAnimatingView.frame = _popOver.frame;
                         [popOverAnimatingView setBackgroundColor:_popOver.backgroundColor];
                         [popOverAnimatingView setAlpha:.97];
                         
                         
    }
                     completion:^(BOOL finished) {
                         _popOver.hidden = NO;
                         [popOverAnimatingView removeFromSuperview];
                     }];
}

-(void) answerButtonHandler:(id) sender {
    UIButton *senderButton = (UIButton *) sender;
    _popOver.hidden = YES;
    _popOverIsActive = NO;
    [self unMarkTiles:_tilesTouched];
    
    switch (senderButton.tag) {
        case 1001: {
            NSLog(@"Rätt svar 1, antal swipes: %lu", (unsigned long)[_tilesTouched count]);
            _animating = YES;
            if ([_tilesTouched count] >= 3) {
                NSNumber *tileToChangeToBooster = [_playingFieldModel changeHeadOfSnakeToBoosterAndReturnItForMove:[_suctionMoveArray lastObject]];
                [self changeTileToBooster:tileToChangeToBooster];
            }
            [self performAndAnimateSuctionMoves:_suctionMoveArray];
            [_playingFieldModel updateModelWithSuctionMoves:_suctionMoveArray];

            break;
        }
        case 2002: {
            NSLog(@"Rätt svar X");
            _animating = YES;
            if ([_tilesTouched count] >= 3) {
                NSNumber *tileToChangeToBooster = [_playingFieldModel changeHeadOfSnakeToBoosterAndReturnItForMove:[_suctionMoveArray lastObject]];
                [self changeTileToBooster:tileToChangeToBooster];
            }            [self performAndAnimateSuctionMoves:_suctionMoveArray];
            [_playingFieldModel updateModelWithSuctionMoves:_suctionMoveArray];
            break;
        }
        case 3003: {
            NSLog(@"Fel svar 2");
            [self abortSuctionSwipeWithMoves:_suctionMoveArray];
            break;
        }
    }
}

-(void) changeTileToBooster:(NSNumber *) ID {
    UIView *tile = _viewDictionary[ID];
    tile.backgroundColor = [UIColor blackColor];
}

@end
