//
//  QCVLevelChooserVC.m
//  QuizCrush
//
//  Created by Arvid on 2014-05-16.
//  Copyright (c) 2014 Planeto. All rights reserved.
//

#import "QCVLevelChooserVC.h"

@interface QCVLevelChooserVC ()

@property (weak, nonatomic) IBOutlet UITableView *levelsTableview;
@property (nonatomic) NSArray *levelsArray;

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
 
    UIImage *background = [UIImage imageNamed:@"QC_background"];
    UIImageView *bgView = [[UIImageView alloc] initWithImage:background];
    [self.view addSubview:bgView];
    [self.view sendSubviewToBack:bgView];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Levels"
                                                     ofType:@"plist"];
    _levelsArray = [NSArray arrayWithContentsOfFile:path];
    
    _levelsTableview.delegate = self;
    _levelsTableview.dataSource = self;
    _levelsTableview.backgroundColor =[UIColor clearColor];
    
    [_levelsTableview registerNib:[UINib nibWithNibName:@"QCLevelTVCell" bundle:nil]
           forCellReuseIdentifier:@"Level cell from nib"];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UIButton *)sender
//{
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//    
//    QCLevelViewController *vc = [segue destinationViewController];
//    NSInteger tag = sender.tag;
//    NSString *document;
//    switch (tag) {
//        case SLIME_LEVEL_BUTTON: {
//            document = @"Level 2 Slime";
//            break;
//        }
//        case SCORE_LEVEL_BUTTON: {
//            document = @"Level 1 Score";
//            break;
//        }
//    }
//    [vc setLevelDocument:document];
//}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(QCLevelTVCell *) sender {
    QCLevelViewController *vc = [segue destinationViewController];
    [vc setLevelDocument:sender.levelLabel.text];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_levelsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Level cell" forIndexPath:indexPath];
    QCLevelTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Level cell" forIndexPath:indexPath];
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 50, 50, 50)];
//    label.text = _levelsArray[indexPath.row];
//    cell.textLabel.text = _levelsArray[indexPath.row];
//    cell.textLabel.textAlignment = NSTextAlignmentCenter;
//    cell.selectionStyle = UITableViewCellSelectionStyleBlue;

    cell.levelLabel.text = _levelsArray[indexPath.row];
    
    return cell;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_levelsTableview deselectRowAtIndexPath:[_levelsTableview indexPathForSelectedRow] animated:YES];
}

//-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
////    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
////    cell.backgroundColor = [UIColor blackColor];
////    NSLog(@"Index: %d", indexPath.row);
//    
//    [self performSegueWithIdentifier:@"tableview segue" sender:@(indexPath.row)];
//}
@end







