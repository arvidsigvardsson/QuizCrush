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
@property int noRowsAndCols;


@end

@implementation QCLevelViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [_containerView setBackgroundColor:[UIColor blueColor]];
    
    NSString *plistCatPath = [[NSBundle mainBundle] pathForResource:@"UISettings" ofType:@"plist"];
    _uiSettingsDictionary = [[NSDictionary alloc] initWithContentsOfFile:plistCatPath];
    
    NSArray *colorArray = @[[UIColor orangeColor], [UIColor yellowColor], [UIColor purpleColor], [UIColor greenColor], [UIColor brownColor], [UIColor blueColor]];

//    NSInteger noCategories = [_uiSettingsDictionary[@"Number of categories"] integerValue];
    _noRowsAndCols = [_uiSettingsDictionary[@"Number of rows and columns"] intValue];
    _lengthOfTile = _containerView.frame.size.height / (float)_noRowsAndCols;

    _playingFieldModel = [[QCPlayingFieldModel alloc] initWithNumberOfRowsAndColumns:_noRowsAndCols];
//    _viewArray = [[NSMutableArray alloc] init];
    _viewDictionary = [[NSMutableDictionary alloc] init];
   
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onViewClickedHandler:)];
    [_containerView addGestureRecognizer:recognizer];
    
    int xIndex, yIndex;
    
    for (int i = 0; i < _noRowsAndCols * _noRowsAndCols; i++) {
        xIndex = i % _noRowsAndCols;
        yIndex = i / _noRowsAndCols;
        
        UIView *tile = [[UIView alloc] initWithFrame:CGRectMake(xIndex * _lengthOfTile, yIndex * _lengthOfTile, _lengthOfTile, _lengthOfTile)];
        tile.layer.cornerRadius = 10.0;
        tile.layer.masksToBounds = YES;
        int category = [_playingFieldModel categoryOfTileAtPosition:i];

        UIColor *color = colorArray[category];
        
        [tile setBackgroundColor:color];
//        [_viewArray addObject:tile];
        [_viewDictionary setObject:tile
                            forKey:[NSNumber numberWithInt:i]];
        [_containerView addSubview:tile];
    }
    
}




-(void)onViewClickedHandler:(UITapGestureRecognizer *)recognizer {
    CGPoint point = [recognizer locationInView:_containerView];
//    NSLog(@"Click handler");
    
//    NSInteger index = [self arrayIndexForX:point.x y:point.y numberOfRows:_numberOfRows lengthOfSides:_lengthOfTile];
    int index = [self arrayIndexForX:point.x y:point.y numberOfRows:_noRowsAndCols lengthOfSides:_lengthOfTile];
    if (index == -1) {
        return;
    }
    
    NSLog(@"Index klickat: %d", index);
    NSNumber *key = [NSNumber numberWithInt:[_playingFieldModel iDOfTileAtPosition:index]];
    
    UIView *view = _viewDictionary[key];
    NSLog(@"Vyn: %@", view);
    [view setBackgroundColor:[UIColor blackColor]];
}


-(int)arrayIndexForX: (float)x y:(float)y numberOfRows:(int)numberOfRows lengthOfSides:(float)lengthOfSide {
    
    if (x < 0.0f || y < 0.0) {
        return -1;
    }
    
    int row, column;
    
    row = (int) floorf(x / lengthOfSide);
    column = (int) floorf(y / lengthOfSide);
    
    if (row >= numberOfRows || column >= numberOfRows) {
        return -1;
    }
    
    return row + column * numberOfRows;
}




@end
