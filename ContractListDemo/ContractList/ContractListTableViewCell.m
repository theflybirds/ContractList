//
//  ContractListTableViewCell.m
//  weLiam
//
//  Created by 曹忠岩 on 2019/7/22.
//  Copyright © 2019 XXX. All rights reserved.
//

#import "ContractListTableViewCell.h"

@implementation ContractListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.userImg.layer.cornerRadius = self.userImg.frame.size.height/2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
