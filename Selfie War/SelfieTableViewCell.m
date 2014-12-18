//
//  SelfieTableViewCell.m
//  Selfie War
//
//  Created by Jonathan Cobian on 9/27/14.
//  Copyright (c) 2014 com.jcobian. All rights reserved.
//

#import "SelfieTableViewCell.h"

@implementation SelfieTableViewCell

- (void)awakeFromNib {
    // Initialization code


}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)downButtonPressed:(UIButton *)sender {
    NSLog(@"Button pressed LOOK COMMENTED OUT DELEGATE JUST SO YOU KNOW");
    //[self.delegate upDownButtonPressedWithButton:sender];
}

@end
