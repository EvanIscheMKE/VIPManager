//
//  HDUserSearchTableViewCell.m
//  StormGolf
//
//  Created by Evan Ische on 5/17/16.
//  Copyright © 2016 Evan William Ische. All rights reserved.
//

#import "UIColor+ColorAdditions.h"
#import "UIFont+FontAdditions.h"
#import "HDUserSearchTableViewCell.h"

@implementation HDUserSearchTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        UIFont *font = [UIFont stormGolfFontOfSize:18.0f];
        
        self.emailLabel = [[UILabel alloc] init];
        self.emailLabel.textColor = [UIColor blackColor];
        self.emailLabel.textAlignment = self.textLabel.textAlignment;
        [self.contentView addSubview:self.emailLabel];
        [self.contentView.subviews makeObjectsPerformSelector:@selector(setFont:) withObject:font];
        
        self.detailTextLabel.font = font;
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.emailLabel.text = nil;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.emailLabel.text) {
        
        [self.emailLabel sizeToFit];
    
        CGRect newFrame = self.emailLabel.frame;
        newFrame.origin.x = CGRectGetWidth(self.contentView.bounds) / 2.5f;
        newFrame.origin.y = CGRectGetMidY(self.contentView.bounds) - CGRectGetMidY(self.emailLabel.bounds);
        self.emailLabel.frame = newFrame;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


@end
