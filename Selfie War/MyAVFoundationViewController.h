//
//  MyAVFoundationViewController.h
//  Selfie War
//
//  Created by Jonathan Cobian on 9/27/14.
//  Copyright (c) 2014 com.jcobian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "ConfirmUploadSelfieViewController.h"
@interface MyAVFoundationViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIView *vImagePreview;
@property(nonatomic, retain) AVCaptureStillImageOutput *stillImageOutput;
@property (strong, nonatomic) IBOutlet UIImageView *vImage;
@property (strong, nonatomic) IBOutlet UIButton *captureButton;
@property (nonatomic) BOOL isCapture;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *useBarButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *backBarButton;

//receive from view controller to send to confirm
@property (strong,nonatomic) NSArray *categoriesArray;
@property(strong,nonatomic) CLLocation *locationCoordinate;

@property(strong,nonatomic) NSData *imageData;
@property(strong,nonatomic) UIImage *imageToSend;
@end
