//
//  LeaderboardTableViewCell.h
//  Selfie War
//
//  Created by Jonathan Cobian on 9/28/14.
//  Copyright (c) 2014 com.jcobian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeaderboardTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;

@property (strong, nonatomic) IBOutlet UILabel *pointsLabel;

@end
