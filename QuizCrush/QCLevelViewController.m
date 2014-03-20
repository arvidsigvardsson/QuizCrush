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


@end

@implementation QCLevelViewController



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
    
    _animating = NO;
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onViewClickedHandler:)];
    [_containerView addGestureRecognizer:recognizer];
    
    int xIndex, yIndex;
    
    for (int i = 0; i < [_noRowsAndCols intValue] * [_noRowsAndCols intValue]; i++) {
        xIndex = i % [_noRowsAndCols intValue];
        yIndex = i / [_noRowsAndCols intValue];
        
        NSNumber *iD = [NSNumber numberWithInt:i];
        
        UIView *tile = [[UIView alloc] initWithFrame:CGRectMake(xIndex * _lengthOfTile, yIndex * _lengthOfTile, _lengthOfTile, _lengthOfTile)];
        tile.layer.cornerRadius = 10.0;
        tile.layer.masksToBounds = YES;
//        NSNumber *category = [_playingFieldModel categoryOfTileAtPosition:[NSNumber numberWithInt:i]];
        NSNumber *category = [_playingFieldModel categoryOfTileWithID:iD];
        
        UIColor *color = _colorArray[[category intValue]];
        
        [tile setBackgroundColor:color];
//        [_viewArray addObject:tile];
        [_viewDictionary setObject:tile
                            forKey:iD];
        [_containerView addSubview:tile];
    }
}




-(void)onViewClickedHandler:(UITapGestureRecognizer *)recognizer {
    NSLog(@"Click detected");
    
    if (_animating) {
        return;
    }
    
    CGPoint point = [recognizer locationInView:_containerView];
//    NSNumber *index = [self arrayIndexForX:point.x y:point.y numberOfRows:_noRowsAndCols lengthOfSides:_lengthOfTile];
//    if ([index intValue] == -1) {
//        return;
//    }
  
    NSDictionary *posDict = [self gridPositionOfPoint:point numberOfRows:_noRowsAndCols lengthOfSides:_lengthOfTile];
    NSNumber *IDTileClicked = [_playingFieldModel iDOfTileAtX:posDict[@"x"] Y:posDict[@"y"]];
    
    NSSet *selectionSet = [_playingFieldModel matchingAdjacentTilesToTileWithID:IDTileClicked];
    if ([selectionSet count] < [_tilesRequiredToMatch intValue]) {
        return;
    }
    
    NSLog(@"Selection set: %@", selectionSet);
    
    // identify if new tiles have been created and give them a view etc
    NSSet *newTiles = [_playingFieldModel getNewTilesReplacing:selectionSet];
    
        
    
    for (NSNumber *addNewKey in newTiles) {
        QCTile *newTile = [_playingFieldModel tileWithID:addNewKey];
                    int x = [newTile.x intValue];
                    int y = [newTile.y intValue];
        //
                    UIView *newView = [[UIView alloc] initWithFrame:CGRectMake(x * _lengthOfTile, y * _lengthOfTile, _lengthOfTile, _lengthOfTile)];
                    newView.layer.cornerRadius = 10.0;
                    newView.layer.masksToBounds = YES;
                    NSNumber *category = [_playingFieldModel categoryOfTileWithID:addNewKey];
        
                    UIColor *color = _colorArray[[category intValue]];
        
                    [newView setBackgroundColor:color];
                    [_viewDictionary setObject:newView
                                        forKey:addNewKey];
                    [_containerView addSubview:newView];
        
//                    NSLog(@"Ny vy skapad");

    }

    
    // dict with ids of tiles to move, with their corresponding moves
    NSDictionary *animateDict = [_playingFieldModel removeAndReturnVerticalTranslations:selectionSet];
    
//    NSLog(@"AnimateDict: %@", animateDict);
//    return;
    
    
    // test
//    for (NSNumber *nyckel in animateDict) {
//        QCTile *ruta = [_playingFieldModel tileWithID:nyckel];
//        NSLog(@"Id för ruta: %@, x: %@, y: %@, shift: %@", ruta.iD, ruta.x, ruta.y, animateDict[nyckel]);
//    }
//    return;
    
    
    // identify if new tiles have been created and give them a view etc
//    for (NSNumber *newKey in animateDict) {
//        if (!_viewDictionary[newKey]) {
//            QCTile *newTile = [_playingFieldModel tileWithID:newKey];
//            int x = [newTile.x intValue];
//            int y = [newTile.y intValue] - 1; // tile has been moved in the model
//            
//            UIView *newView = [[UIView alloc] initWithFrame:CGRectMake(x * _lengthOfTile, y * _lengthOfTile, _lengthOfTile, _lengthOfTile)];
//            newView.layer.cornerRadius = 10.0;
//            newView.layer.masksToBounds = YES;
//            NSNumber *category = [_playingFieldModel categoryOfTileWithID:newKey];
//            
//            UIColor *color = _colorArray[[category intValue]];
//            
//            [newView setBackgroundColor:color];
//            [_viewDictionary setObject:newView
//                                forKey:newKey];
//            [_containerView addSubview:newView];
//
////            NSLog(@"Ny vy skapad");
//        }
//    }
   
    for (NSNumber *key in selectionSet) {
        UIView * view = _viewDictionary[key];
//        [view setBackgroundColor:[UIColor blackColor]];
        [view removeFromSuperview];
        [_viewDictionary removeObjectForKey:key];
    }
   
    _animating = YES;
    [UIView animateWithDuration:1.0 animations:^{
        for (NSNumber *aniKey in animateDict) {
            UIView *aniView = _viewDictionary[aniKey];
            CGPoint newCenter = CGPointMake(aniView.center.x, aniView.center.y + [animateDict[aniKey] intValue] * _lengthOfTile);
            [aniView setCenter:newCenter];
        }
    }completion:^(BOOL finished) {
        _animating = NO;
    }];
    
    
    // test
//    NSLog(<#NSString *format, ...#>)
    
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

@end
