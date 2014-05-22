//
//  QCSettingsVC.m
//  QuizCrush
//
//  Created by Arvid on 2014-05-22.
//  Copyright (c) 2014 Planeto. All rights reserved.
//

#import "QCSettingsVC.h"

@interface QCSettingsVC ()
@property (weak, nonatomic) IBOutlet UIButton *resetButton;
- (IBAction)settingsButtonHandler:(id)sender;

@end

@implementation QCSettingsVC

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
    UIImage *background = [UIImage imageNamed:@"QC_background"];
    UIImageView *bgView = [[UIImageView alloc] initWithImage:background];
    [self.view addSubview:bgView];
    [self.view sendSubviewToBack:bgView];

    _resetButton.layer.masksToBounds = YES;
    _resetButton.layer.cornerRadius = 15;
    _resetButton.backgroundColor = [UIColor colorWithWhite:1 alpha:.5];
    
    UIScreenEdgePanGestureRecognizer *rec = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleEdgeSwipe:)];
    rec.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:rec];
}

-(void) handleEdgeSwipe:(id) sender {
    [self dismissViewControllerAnimated:NO completion:^{
        
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)settingsButtonHandler:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@0 forKey:@"Highest level completed"];
    [self dismissViewControllerAnimated:NO completion:^{
    }];


}
@end
