//
//  ConfirmUploadSelfieViewController.h
//  Selfie War
//
//  Created by Jonathan Cobian on 9/27/14.
//  Copyright (c) 2014 com.jcobian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "UILabel+ResizeUILabel.h"
@interface ConfirmUploadSelfieViewController : UIViewController<UIImagePickerControllerDelegate,UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *myImageView;
@property (strong, nonatomic) IBOutlet UIPickerView *myPickerView;

//must receive
@property (strong,nonatomic) NSArray *categoriesArray;
@property(strong,nonatomic) UIImage *imageReceived;

@property(strong,nonatomic) CLLocation *locationCoordinate;


@property (strong, nonatomic) IBOutlet UISwitch *nearMeSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *mostPopularSwitch;
@property(strong,nonatomic) NSString *selectedCategory;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *postBarButton;
@property (strong,nonatomic) UIActivityIndicatorView *spinningWheel;
@end
