//
//  ConfirmUploadSelfieViewController.m
//  Selfie War
//
//  Created by Jonathan Cobian on 9/27/14.
//  Copyright (c) 2014 com.jcobian. All rights reserved.
//

#import "ConfirmUploadSelfieViewController.h"

@interface ConfirmUploadSelfieViewController ()

@end

@implementation ConfirmUploadSelfieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"congruent_pentagon.png"]];

    
    [self.myImageView setImage:self.imageReceived];

    self.selectedCategory = [[NSString alloc] init];
    [self.myPickerView selectRow:0 inComponent:0 animated:NO];
    //self.spinningWheel = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    //self.spinningWheel.center = self.view.center;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)uploadImage:(NSData *)imageData {
    
    PFFile *imageFile = [PFFile fileWithData:imageData];
    
    
    // Save PFFile
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            
            // Create a PFObject around a PFFile and associate it with the current user
            PFObject *selfie = [PFObject objectWithClassName:@"Selfie"];
            [selfie setObject:imageFile forKey:@"image"];
            NSString *userString = [[PFUser currentUser] username];
            [selfie setObject:userString forKey:@"userID"];
            NSNumber *zero = [[NSNumber alloc] initWithInt:0];
            [selfie setObject:zero forKey:@"points"];
            PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLocation:self.locationCoordinate];
            [selfie setObject:geoPoint forKey:@"location"];
            //if near me or most pop on then update accordinly
            NSNumber *nearMe = [[NSNumber alloc] initWithBool:[self.nearMeSwitch isOn]];
            NSNumber *mostPop = [[NSNumber alloc] initWithBool:[self.mostPopularSwitch isOn]];
            [selfie setObject:nearMe forKey:@"nearMeOn"];
            [selfie setObject:mostPop forKey:@"mostPopularOn"];
            //update categoryID
            PFQuery *categorySearchQuery = [PFQuery queryWithClassName:@"Category"];
            NSLog(@"Selected category is %@",self.selectedCategory);
            [categorySearchQuery whereKey:@"name" equalTo:self.selectedCategory];
            [categorySearchQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                NSString *categoryIDString = object[@"name"];
                [selfie setObject:categoryIDString forKey:@"categoryID"];
                [selfie saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (!error) {
                        NSLog(@"Seflie uploaded");
                        //[self.spinningWheel stopAnimating];
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Your selfie has been posted" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                        [alertView show];
                        
                    }
                    else{
                        // Log details of the failure
                        NSLog(@"Error with category search: %@ %@", error, [error userInfo]);
                    }
                }];
            }];
            
            
           
        }
        else{
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    //[self dismissViewControllerAnimated:YES completion:nil];
    [[[self presentingViewController] presentingViewController] dismissViewControllerAnimated:NO completion:nil];
    
}
- (IBAction)cancelButtonPressed:(id)sender {
    //[self dismissViewControllerAnimated:YES completion:nil];
     [[[self presentingViewController] presentingViewController] dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)postButtonPressed:(id)sender {
    //[self.spinningWheel startAnimating];
    NSData *imageData = UIImageJPEGRepresentation(self.imageReceived, .5);
    [self uploadImage:imageData];
}
#pragma mark - UIPicker
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
    
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component
{

    return [self.categoriesArray count];
    
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row   forComponent:(NSInteger)component
{
    return [self.categoriesArray objectAtIndex:row];
    
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row   inComponent:(NSInteger)component{

    self.selectedCategory = [self.categoriesArray objectAtIndex:row];
    
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* tView = (UILabel*)view;
    if (!tView){
        tView = [[UILabel alloc] init];
        // Setup label properties - frame, font, colors etc
    }
    // Fill the label text here
    [tView setText:[self.categoriesArray objectAtIndex:row]];
    [tView resizeIfTooBig];

    return tView;
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
