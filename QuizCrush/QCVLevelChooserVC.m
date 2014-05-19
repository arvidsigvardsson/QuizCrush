//
//  QCVLevelChooserVC.m
//  QuizCrush
//
//  Created by Arvid on 2014-05-16.
//  Copyright (c) 2014 Planeto. All rights reserved.
//

#import "QCVLevelChooserVC.h"

@interface QCVLevelChooserVC ()

@property (weak, nonatomic) IBOutlet UIButton *scoreLevelButton;
@property (weak, nonatomic) IBOutlet UIButton *slimeLevelButton;

typedef enum {
    SCORE_LEVEL_BUTTON,
    SLIME_LEVEL_BUTTON
} LevelButtonType;

@end

@implementation QCVLevelChooserVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    _scoreLevelButton.tag = SCORE_LEVEL_BUTTON;
    _slimeLevelButton.tag = SLIME_LEVEL_BUTTON;
    
    _scoreLevelButton.backgroundColor = [UIColor whiteColor];
    _scoreLevelButton.layer.masksToBounds = YES;
    _scoreLevelButton.layer.cornerRadius = 15;
    _scoreLevelButton.alpha = .7;
    
    _slimeLevelButton.backgroundColor = [UIColor whiteColor];
    _slimeLevelButton.layer.masksToBounds = YES;
    _slimeLevelButton.layer.cornerRadius = 15;
    _slimeLevelButton.alpha = .7;

    
    UIImage *background = [UIImage imageNamed:@"QC_background"];
    UIImageView *bgView = [[UIImageView alloc] initWithImage:background];
    [self.view addSubview:bgView];
    [self.view sendSubviewToBack:bgView];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UIButton *)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    QCLevelViewController *vc = [segue destinationViewController];
    NSInteger tag = sender.tag;
    NSString *document;
    switch (tag) {
        case SLIME_LEVEL_BUTTON: {
            document = @"Slime Level 1";
            break;
        }
        case SCORE_LEVEL_BUTTON: {
            document = @"Score Level 1";
            break;
        }
    }
    [vc setLevelDocument:document];
}


@end
