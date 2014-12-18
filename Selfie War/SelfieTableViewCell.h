//
//  SelfieTableViewCell.h
//  Selfie War
//
//  Created by Jonathan Cobian on 9/27/14.
//  Copyright (c) 2014 com.jcobian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@protocol UpDownButtonPressedDelegate <NSObject>

-(void)upDownButtonPressedWithButton:(UIButton *)button;

@end

@interface SelfieTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *upButton;
@property (strong, nonatomic) IBOutlet UIButton *downButton;
@property (strong, nonatomic) IBOutlet PFImageView *myImageView;
@property (strong, nonatomic) IBOutlet UILabel *pointsLabel;
@property (strong,nonatomic) id<UpDownButtonPressedDelegate> delegate;
@end