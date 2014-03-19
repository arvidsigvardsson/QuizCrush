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
- (IBAction)resetColorsHandler:(id)sender;

@property NSMutableDictionary *viewDictionary;
@property NSDictionary *uiSettingsDictionary;
@property QCPlayingFieldModel *playingFieldModel;
@property float lengthOfTile;
@property NSNumber *noRowsAndCols;
@property NSArray *colorArray;
@property NSNumber *tilesRequiredToMatch;


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
    CGPoint point = [recognizer locationInView:_containerView];
    NSNumber *index = [self arrayIndexForX:point.x y:point.y numberOfRows:_noRowsAndCols lengthOfSides:_lengthOfTile];
    if ([index intValue] == -1) {
        return;
    }
  
    NSSet *selectionSet = [_playingFieldModel matchingAdjacentTilesToTileWithID:index];
    if ([selectionSet count] < [_tilesRequiredToMatch intValue]) {
        return;
    }
    
    NSDictionary *testDict = [_playingFieldModel removeAndReturnVerticalTranslations:selectionSet];
    
    NSLog(@"Translation dict: %@", testDict);
    
    for (NSNumber *key in selectionSet) {
        UIView * view = _viewDictionary[key];
//        [view setBackgroundColor:[UIColor blackColor]];
        [view removeFromSuperview];
        [_viewDictionary removeObjectForKey:key];
    }
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




- (IBAction)resetColorsHandler:(id)sender {
    for (id key in _viewDictionary) {
        int index = [[_playingFieldModel categoryOfTileWithID:key] intValue];
        UIColor *color = _colorArray[index];
        [[_viewDictionary objectForKey:key] setBackgroundColor:color];
//        int test = [key intValue];
//        NSLog(@"test = %d", test);
    
    }
}
@end
