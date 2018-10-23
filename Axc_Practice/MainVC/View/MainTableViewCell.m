//
//  MainTableViewCell.m
//  Axc_Practice
//
//  Created by AxcLogo on 2018/10/22.
//  Copyright © 2018 AxcLogo. All rights reserved.
//

#import "MainTableViewCell.h"

@implementation MainTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(MianModel *)model{
    _model = model;
    self.textLabel.text = _model.title;
}

@end
