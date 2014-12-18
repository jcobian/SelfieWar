//
//  MyAVFoundationViewController.m
//  Selfie War
//
//  Created by Jonathan Cobian on 9/27/14.
//  Copyright (c) 2014 com.jcobian. All rights reserved.
//

#import "MyAVFoundationViewController.h"

@interface MyAVFoundationViewController ()

@end

@implementation MyAVFoundationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"congruent_pentagon.png"]];
    self.vImagePreview.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"congruent_pentagon.png"]];
    //[self.vImage setHidden:YES];
    self.isCapture = YES;
    self.imageData = [[NSData alloc] init];
    self.imageToSend = [[UIImage alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidAppear:(BOOL)animated {
    //[self.vImage setHidden:YES];

    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    session.sessionPreset = AVCaptureSessionPresetMedium;
    
    CALayer *viewLayer = self.vImagePreview.layer;
    NSLog(@"viewLayer = %@", viewLayer);
    
    AVCaptureVideoPreviewLayer *captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
    
    captureVideoPreviewLayer.frame = self.vImagePreview.bounds;
    [self.vImagePreview.layer addSublayer:captureVideoPreviewLayer];
    
    //AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDevice *device = [self frontCamera];
    
    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (!input) {
        // Handle the error appropriately.
        NSLog(@"ERROR: trying to open camera: %@", error);
    }
    [session addInput:input];
    
    
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys: AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [self.stillImageOutput setOutputSettings:outputSettings];
    
    [session addOutput:self.stillImageOutput];
    
    [session startRunning];
    
    

}
-(void)toggleButton {
    if(self.isCapture) {
        [self.captureButton setTitle:@"Retake" forState:UIControlStateNormal];
        self.isCapture = NO;
    }
    else {
        [self.captureButton setTitle:@"Capture" forState:UIControlStateNormal];
        self.isCapture = YES;
    }
    
}
- (AVCaptureDevice *)frontCamera {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if ([device position] == AVCaptureDevicePositionFront) {
            return device;
        }
    }
    return nil;
}
- (IBAction)captureNow:(id)sender {
    if(self.isCapture) {
        AVCaptureConnection *videoConnection = nil;
        for (AVCaptureConnection *connection in self.stillImageOutput.connections)
        {
            for (AVCaptureInputPort *port in [connection inputPorts])
            {
                if ([[port mediaType] isEqual:AVMediaTypeVideo] )
                {
                    videoConnection = connection;
                    break;
                }
            }
            if (videoConnection) { break; }
        }
        
        NSLog(@"about to request a capture from: %@", self.stillImageOutput);
        [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error)
         {
             /*CFDictionaryRef exifAttachments = CMGetAttachment(imageSampleBuffer, kCGImagePropertyExifDictionary, NULL);
              if (exifAttachments)
              {
              // Do something with the attachments.
              NSLog(@"attachements: %@", exifAttachments);
              }
              else
              NSLog(@"no attachments");*/
             
             NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
    
             UIImage *image = [[UIImage alloc] initWithData:imageData];
             UIImage* flippedImage = [UIImage imageWithCGImage:image.CGImage
                                                         scale:image.scale
                                                   orientation:UIImageOrientationLeftMirrored];
             

             self.imageToSend = flippedImage;
             
             self.vImage.image = flippedImage;
             [self toggleButton];
             //[self.vImage setHidden:NO];
             
         }];
        
    }
    else {
        self.vImage.image = nil;
        [self toggleButton];
    }
    
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"goToConfirmVC"]) {
        ConfirmUploadSelfieViewController *controller = (ConfirmUploadSelfieViewController *)[segue.destinationViewController topViewController];
        [controller setCategoriesArray:self.categoriesArray];
        [controller setLocationCoordinate:self.locationCoordinate];
        [controller setImageReceived:self.imageToSend];
    }
}
- (IBAction)backButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)useButtonPressed:(id)sender {
    if(self.isCapture == NO) {
        [self performSegueWithIdentifier:@"goToConfirmVC" sender:self];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
