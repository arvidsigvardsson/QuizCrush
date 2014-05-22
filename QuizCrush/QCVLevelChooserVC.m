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
@property (nonatomic) NSNumber *levelsCompleted;

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
    
    // test
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@0 forKey:@"Highest level completed"];
}


#pragma mark - Navigation


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
    if (indexPath.row > [_levelsCompleted intValue]) {
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.levelLabel.textColor = [UIColor grayColor];
        cell.levelLabel.alpha = .3;
        cell.levelLabel.enabled = NO;
    }
    return cell;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_levelsTableview deselectRowAtIndexPath:[_levelsTableview indexPathForSelectedRow] animated:YES];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _levelsCompleted = [defaults objectForKey:@"Highest level completed"];
    if (!_levelsCompleted) {
        _levelsCompleted = @0;
        [defaults setObject:_levelsCompleted forKey:@"Highest level completed"];
    }
    
    [_levelsTableview reloadData];
    
    NSLog(@"Defaults: %@", [defaults dictionaryRepresentation]);
}


-(NSIndexPath *) tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row > [_levelsCompleted intValue]) {
        return nil;
    }
    return indexPath;
}
@end







