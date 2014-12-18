//
//  LeaderboardViewController.h
//  Selfie War
//
//  Created by Jonathan Cobian on 9/28/14.
//  Copyright (c) 2014 com.jcobian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "LeaderboardTableViewCell.h"
@interface LeaderboardViewController : UIViewController<UITableViewDataSource,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) IBOutlet UILabel *myUsernameLabel;
@property (strong, nonatomic) IBOutlet UILabel *myPointsLabel;
@property (strong,nonatomic) NSMutableArray *leaderboardUserArray;
@property (strong,nonatomic) NSMutableArray *leaderboardPointsArray;
@property (strong,nonatomic) NSString *currentUsername;
@property (strong,nonatomic) NSString *currenUsernamePoints;
@end
