//
//  QCLevelTVCell.m
//  QuizCrush
//
//  Created by Arvid on 2014-05-20.
//  Copyright (c) 2014 Planeto. All rights reserved.
//

#import "QCLevelTVCell.h"

@interface QCLevelTVCell ()

@end

@implementation QCLevelTVCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
