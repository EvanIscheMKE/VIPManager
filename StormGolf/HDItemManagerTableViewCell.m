//
//  HDItemManagerTableViewCell.m
//  StormGolf
//
//  Created by Evan Ische on 5/11/16.
//  Copyright © 2016 Evan William Ische. All rights reserved.
//

#import "HDItemManagerTableViewCell.h"

@implementation HDItemManagerTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier]) {
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
