//
//  ViewController.h
//  Selfie War
//
//  Created by Jonathan Cobian on 9/26/14.
//  Copyright (c) 2014 com.jcobian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "ConfirmUploadSelfieViewController.h"
#import "ViewSelfiesTableViewController.h"
#import "MyAVFoundationViewController.h"
#import "LeaderboardViewController.h"
@interface ViewController : UIViewController<PFLogInViewControllerDelegate,PFSignUpViewControllerDelegate,UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UIActionSheetDelegate,CLLocationManagerDelegate,UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) IBOutlet UIButton *postButton;
@property(strong,nonatomic) NSArray *categoriesArray;
@property (nonatomic, retain) CLLocationManager *locationManager;
//@property (strong,nonatomic) UIImagePickerController *imagePicker;
@property(strong,nonatomic) CLLocation *locationCoordinate;
@property(strong,nonatomic) NSData *imageData;
@property(strong,nonatomic) NSString *selectedCategory;

@property(strong,nonatomic) PFQuery *selfiesQuery;
@property(strong,nonatomic) NSArray *selfieObjectsToSend;
@property (strong,nonatomic) NSMutableArray *alreadyVotedArray;
@property (strong,nonatomic) NSMutableArray *leaderboardUserArray;
@property (strong,nonatomic) NSMutableArray *leaderboardPointsArray;
@property (strong,nonatomic) NSString *currentUsername;
@property (strong,nonatomic) NSString *currenUsernamePoints;
@end

