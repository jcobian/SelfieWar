//
//  ViewSelfiesTableViewController.h
//  Selfie War
//
//  Created by Jonathan Cobian on 9/27/14.
//  Copyright (c) 2014 com.jcobian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelfieTableViewCell.h"
@interface ViewSelfiesTableViewController : UITableViewController<UpDownButtonPressedDelegate>
//@property (strong,nonatomic) NSArray *selfieImageDataArray;
//@property (strong,nonatomic) NSArray *selfiePointsArray;
@property(strong,nonatomic) NSArray *selfiesObjects;

@property(strong,nonatomic) NSMutableArray *selfiesToAddOne;
@property(strong,nonatomic) NSMutableArray *selfiesToSubOne;
@property(strong,nonatomic) NSArray *alreadyVotedArray;

@end
