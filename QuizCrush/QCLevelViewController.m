//
//  QCLevelViewController.m
//  QuizCrush
//
//  Created by Arvid on 2014-03-17.
//  Copyright (c) 2014 Planeto. All rights reserved.
//

#import "QCLevelViewController.h"

@interface QCLevelViewController ()

@property (weak, nonatomic) IBOutlet UIView *containerView;
//@property NSMutableArray *viewArray;

@property NSMutableDictionary *viewDictionary;
@property NSDictionary *uiSettingsDictionary;
@property QCPlayingFieldModel *playingFieldModel;
@property float lengthOfTile;
@property NSNumber *noRowsAndCols;
@property NSArray *colorArray;
@property NSNumber *tilesRequiredToMatch;
@property BOOL animating;
@property BOOL vaildSwipe;
@property NSMutableSet *tilesTouched;
@property NSSet *matchingTiles;
@property NSNumber *currentTileTouched;
@property NSMutableArray *moveArray;
@property NSString *moveDirection;

@end

@implementation QCLevelViewController



- (UIView *)tileViewCreatorXIndex:(int)xIndex yIndex:(int)yIndex iD:(NSNumber *)iD
{
    UIView *tile = [[UIView alloc] initWithFrame:CGRectMake(xIndex * _lengthOfTile, yIndex * _lengthOfTile, _lengthOfTile, _lengthOfTile)];
    tile.layer.cornerRadius = 17.0;
    tile.layer.masksToBounds = YES;
    //        NSNumber *category = [_playingFieldModel categoryOfTileAtPosition:[NSNumber numberWithInt:i]];
    NSNumber *category = [_playingFieldModel categoryOfTileWithID:iD];
    
    UIColor *color = _colorArray[[category intValue]];
    
    [tile setBackgroundColor:color];
    return tile;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [_containerView setBackgroundColor:[UIColor blueColor]];
    
    NSString *plistCatPath = [[NSBundle mainBundle] pathForResource:@"UISettings" ofType:@"plist"];
    _uiSettingsDictionary = [[NSDictionary alloc] initWithContentsOfFile:plistCatPath];
    
    _colorArray = @[[UIColor orangeColor], [UIColor yellowColor], [UIColor purpleColor], [UIColor greenColor], [UIColor brownColor], [UIColor blueColor]];

//    NSInteger noCategories = [_uiSettingsDictionary[@"Number of categories"] integerValue];
    _noRowsAndCols = _uiSettingsDictionary[@"Number of rows and columns"];
    _lengthOfTile = _containerView.frame.size.height / (float)[_noRowsAndCols intValue];
    _tilesRequiredToMatch = _uiSettingsDictionary[@"Number of tiles required to match"];

    _playingFieldModel = [[QCPlayingFieldModel alloc] initWithNumberOfRowsAndColumns:_noRowsAndCols];
//    _viewArray = [[NSMutableArray alloc] init];
    _viewDictionary = [[NSMutableDictionary alloc] init];
    
    // swipe handling properties
    _animating = NO;
    _tilesTouched = [[NSMutableSet alloc] init];
    _moveArray = [[NSMutableArray alloc] init];
    _moveDirection = [[NSString alloc] init];
    
//    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onViewClickedHandler:)];
//    [_containerView addGestureRecognizer:recognizer];
    
    // pan action
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panHandler:)];
    panRecognizer.maximumNumberOfTouches = 1;
    [_containerView addGestureRecognizer:panRecognizer];
    
    // tap gesture for testing
//    UITapGestureRecognizer *tapRec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTestingHandler:)];
//    [_containerView addGestureRecognizer:tapRec];
    
    
    int xIndex, yIndex;
    NSNumber *iD;
    
    for (int i = 0; i < [_noRowsAndCols intValue] * [_noRowsAndCols intValue]; i++) {
        xIndex = i % [_noRowsAndCols intValue];
        yIndex = i / [_noRowsAndCols intValue];
        
        iD = [NSNumber numberWithInt:i];
        
        UIView *tile;
//        tile = [self tileViewCreator:yIndex xIndex:xIndex iD:iD];
        tile = [self tileViewCreatorXIndex:xIndex yIndex:yIndex iD:iD];
//        [_viewArray addObject:tile];
        [_viewDictionary setObject:tile
                            forKey:iD];
        [_containerView addSubview:tile];
    }
}




- (void)deleteTiles:(NSNumber *)IDTileClicked {
    NSSet *selectionSet = [_playingFieldModel matchingAdjacentTilesToTileWithID:IDTileClicked];
    if ([selectionSet count] < [_tilesRequiredToMatch intValue]) {
        return;
    }
    
    // identify if new tiles have been created and give them a view etc
    NSSet *newTiles = [_playingFieldModel getNewTilesReplacing:selectionSet];
    
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
        [_containerView addSubview:newView];
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

-(void)onViewClickedHandler:(UITapGestureRecognizer *)recognizer {
    
    if (_animating) {
        return;
    }
    
    CGPoint point = [recognizer locationInView:_containerView];
    NSDictionary *posDict = [self gridPositionOfPoint:point numberOfRows:_noRowsAndCols lengthOfSides:_lengthOfTile];
    NSNumber *IDTileClicked = [_playingFieldModel iDOfTileAtX:posDict[@"x"] Y:posDict[@"y"]];
    
    [self deleteTiles:IDTileClicked];
    
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

-(NSDictionary *) gridPositionOfPoint: (CGPoint)point numberOfRows:(NSNumber *)numberOfRows lengthOfSides:(float)lengthOfSide {
    int row, column;
    
    row = (int) floorf(point.x / lengthOfSide);
    column = (int) floorf(point.y / lengthOfSide);
    
    if (row >= [numberOfRows intValue] || column >= [numberOfRows intValue]) {
        return nil;
    }

    NSDictionary *dict = @{@"x" : [NSNumber numberWithInt:row], @"y" : [NSNumber numberWithInt:column]};
    
    return dict;
}

-(void) panHandler:(UIPanGestureRecognizer *)recognizer {
//    NSLog(@"Pan handler");
    CGPoint point = [recognizer locationInView:_containerView];
    NSDictionary *touchPoint = [self gridPositionOfPoint:point numberOfRows:_noRowsAndCols lengthOfSides:_lengthOfTile];
    NSNumber *x = touchPoint[@"x"];
    NSNumber *y = touchPoint[@"y"];
//    NSMutableSet *tilesTouched = [[NSMutableSet alloc] init];
//    NSLog(@"Touchpoint: %@", touchPoint);
    
    
    
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        [self unMarkTiles:_tilesTouched];
        [_tilesTouched removeAllObjects];
        [_moveArray removeAllObjects];
        
        _vaildSwipe = YES;
//        NSNumber *firstTile = [_playingFieldModel iDOfTileAtX:x Y:y];
        _currentTileTouched = [_playingFieldModel iDOfTileAtX:x Y:y];
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
        
        
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded) {
        if (!_vaildSwipe) {
//            NSLog(@"Invalid swipe");
            [_tilesTouched removeAllObjects];
            [_moveArray removeAllObjects];
            return;
        }
        if ([_tilesTouched count] < [_uiSettingsDictionary[@"Number of tiles swiped required"] intValue]) {
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
    [_playingFieldModel swipeWasAbortedWithMoves:arrayOfMoves];
}


-(void) markTiles:(NSSet *) set  {
    if (!set) {
        return;
    }
    for (NSNumber *key in set) {
        [_viewDictionary[key] setBackgroundColor:[UIColor blackColor]];
    }
}

-(void) unMarkTiles:(NSSet *) set {
    if (!set) {
        return;
    }
    for (NSNumber *key in set) {
        int color = [[_playingFieldModel categoryOfTileWithID:key] intValue];
        [_viewDictionary[key] setBackgroundColor:_colorArray[color]];
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
        [_containerView addSubview:newTileView];
        [_viewDictionary setObject:newTileView forKey:newTile.iD];
    }
    
    [self recursionAnimation:moves index:0];
    
//    // animation, one move at a time
//    for (QCMoveDescription *move in moves) {
//        // first create new view
//        QCTile *newTile = [_playingFieldModel tileWithID:move.createdTileID];
//        UIView *newTileView = [self tileViewCreatorXIndex:[newTile.x intValue] yIndex:[newTile.y intValue] iD:newTile.iD];
//        [_containerView addSubview:newTileView];
//        [_viewDictionary setObject:newTileView forKey:newTile.iD];
//        
//        float xCenterDisplacement;
//        float yCenterDisplacement;
//        if ([move.direction isEqualToString:@"up"]) {
//            xCenterDisplacement = 0;
//            yCenterDisplacement = -_lengthOfTile;
//        } else if ([move.direction isEqualToString:@"right"]) {
//            xCenterDisplacement = _lengthOfTile;
//            yCenterDisplacement = 0;
//        } else if ([move.direction isEqualToString:@"down"]) {
//            xCenterDisplacement = 0;
//            yCenterDisplacement = _lengthOfTile;
//        } else if ([move.direction isEqualToString:@"left"]) {
//            xCenterDisplacement = -_lengthOfTile;
//            yCenterDisplacement = 0;
//        }
//
//        
//        [UIView animateWithDuration:[_uiSettingsDictionary[@"Tile animation duration"] floatValue]
//                         animations:^{
//                             for (NSNumber *moveKey in move.moveDict) {
//                                 UIView *aniView = _viewDictionary[moveKey];
//                                 CGPoint newCenter = CGPointMake(aniView.center.x + xCenterDisplacement, aniView.center.y + yCenterDisplacement);
//                                 [aniView setCenter:newCenter];                             }
//
//        }
//                         completion:^(BOOL finished) {
//            
//        }];
////        for (NSNumber *moveKey in move.moveDict) {
////            
////        }
//        
//    }
    
//    NSLog(@"Antal subviews: %lu", (unsigned long)[[_containerView subviews] count]);
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


//-(void) tapTestingHandler:(UITapGestureRecognizer *) recognizer {
//    CGPoint point = [recognizer locationInView:_containerView];
//    NSDictionary *touchPoint = [self gridPositionOfPoint:point numberOfRows:_noRowsAndCols lengthOfSides:_lengthOfTile];
//    NSNumber *x = touchPoint[@"x"];
//    NSNumber *y = touchPoint[@"y"];
//    
//    NSNumber *testID = [_playingFieldModel iDOfTileAtX:x Y:y];
//    NSArray *testArray = @[@"up", @"right", @"down", @"left"];
//    NSLog(@"Point is %@, %@", x, y);
//    for (NSString *testString in testArray) {
//        NSDictionary *testPoint = [_playingFieldModel positionOneStepFromID:testID inDirection:testString];
//        NSLog(@"Position %@ is %@", testString, testPoint);
//    }
//
//}
@end
