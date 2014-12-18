//
//  ViewController.m
//  Selfie War
//
//  Created by Jonathan Cobian on 9/26/14.
//  Copyright (c) 2014 com.jcobian. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"congruent_pentagon.png"]];

    
    self.myTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.myTableView.tableFooterView.hidden = YES;
    self.myTableView.sectionFooterHeight = 0.0;
    /*
    self.imagePicker = [[UIImagePickerController alloc]init];
    [self.imagePicker setAllowsEditing:YES];
    [self.imagePicker setDelegate:self];*/
    
    self.selfieObjectsToSend = [[NSArray alloc] init];
    self.alreadyVotedArray  = [[NSMutableArray alloc] init];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [self.locationManager setDistanceFilter:kCLDistanceFilterNone];
    [self.locationManager requestWhenInUseAuthorization];
    
    self.locationCoordinate = [[CLLocation alloc] init];
    self.imageData = [[NSData alloc] init];
    
    self.selectedCategory = [[NSString alloc] init];
    
    self.leaderboardUserArray = [[NSMutableArray alloc] init];
    self.leaderboardPointsArray = [[NSMutableArray alloc] init];
    self.currentUsername = [[NSString alloc] init];
    self.currenUsernamePoints = [[NSString alloc] init];

    PFQuery *categoryQuery = [PFQuery queryWithClassName:@"Category"];
    [categoryQuery orderByDescending:@"sortOrder"];
    [categoryQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error) {
            self.categoriesArray = [[NSArray alloc] initWithArray:objects];
            [self.myTableView reloadData];
            /*for (PFObject *obj in self.categoriesArray) {
                NSLog(@"%@",obj[@"name"]);
            }*/
        }
        else {
            NSLog(@"Error: %@",error);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidAppear:(BOOL)animated {
    if (![PFUser currentUser]) { // No user logged in
        // Create the log in view controller
        PFLogInViewController *logInViewController = [[PFLogInViewController alloc] init];
        [logInViewController setDelegate:self]; // Set ourselves as the delegate
        
        // Create the sign up view controller
        PFSignUpViewController *signUpViewController = [[PFSignUpViewController alloc] init];
        [signUpViewController setDelegate:self]; // Set ourselves as the delegate
        
        // Assign our sign up controller to be displayed from the login controller
        [logInViewController setSignUpController:signUpViewController];
        
        // Present the log in view controller
        [self presentViewController:logInViewController animated:NO completion:NULL];
    }
}
- (IBAction)leaderBoardButtonPressed:(id)sender {
    [[PFUser currentUser] refreshInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        PFQuery *query = [PFUser query];
        [query orderByDescending:@"careerPoints"];
        query.limit = 50;
        //[query includeKey:@"careerPoints"];
        self.currentUsername = [[PFUser currentUser] username];
        self.currenUsernamePoints = [[NSString alloc] initWithFormat:@"%@",[[PFUser currentUser] objectForKey:@"careerPoints"]];
        [self.leaderboardUserArray removeAllObjects];
        [self.leaderboardPointsArray removeAllObjects];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            for (PFUser *user in objects) {
                //NSLog(@"user: %@, pts: %@",[user username],[user objectForKey:@"careerPoints"]);
                [self.leaderboardUserArray addObject:[user username]];
                [self.leaderboardPointsArray addObject:[user objectForKey:@"careerPoints"]];
            }
            [self performSegueWithIdentifier:@"goToLeaderboard" sender:self];
        }];

    }];
    
    
    
}

-(void)doSelfieQuery:(PFQuery *)selfiesQuery {
    [selfiesQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.selfieObjectsToSend = [[NSArray alloc] initWithArray:objects];
        
        PFQuery *voteQuery = [PFQuery queryWithClassName:@"Votes"];
        NSString *username = [[PFUser currentUser] username];
        [voteQuery whereKey:@"userID" equalTo:username];
        [voteQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            for (PFObject *vote in objects) {
                [self.alreadyVotedArray addObject:vote[@"selfieID"]];
            }
            [self performSegueWithIdentifier:@"goToViewSelfies" sender:self];
        }];
    }];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"goToViewSelfies"]) {
        ViewSelfiesTableViewController *controller = (ViewSelfiesTableViewController *)[segue.destinationViewController topViewController];
        [controller setSelfiesObjects:self.selfieObjectsToSend];
        [controller setAlreadyVotedArray:self.alreadyVotedArray];
        [controller setTitle:self.selectedCategory];

        
    
    }
    else if ([segue.identifier isEqualToString:@"goToAVFoundation"]) {
        MyAVFoundationViewController *controller = (MyAVFoundationViewController *)segue.destinationViewController;
        NSMutableArray *categoriesToPick = [[NSMutableArray alloc] init];
        for (PFObject *obj in self.categoriesArray) {
            NSString *name = obj[@"name"];
            if([name isEqualToString:@"Most Popular"] || [name isEqualToString:@"Near Me"]) {
                continue;
            }
            [categoriesToPick addObject:name];
        }
        [controller setCategoriesArray:categoriesToPick];
        [controller setLocationCoordinate:self.locationCoordinate];
    }
    else if ([segue.identifier isEqualToString:@"goToLeaderboard"]) {
        LeaderboardViewController *controller = (LeaderboardViewController *)[segue.destinationViewController topViewController];
        [controller setLeaderboardUserArray:self.leaderboardUserArray];
        [controller setLeaderboardPointsArray:self.leaderboardPointsArray];
        [controller setCurrentUsername:self.currentUsername];
        [controller setCurrenUsernamePoints:self.currenUsernamePoints];
    }
}

- (IBAction)postPictureButtonPressed:(id)sender {
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                 delegate:self
                                                        cancelButtonTitle:@"Cancel"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"Take photo", @"Choose Existing", nil];
        [actionSheet showInView:self.view];
    }
    else {
        /*
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;*/
        [self.locationManager startUpdatingLocation];
        
    }
}

-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"manager did update locations, yay");
    [self.locationManager stopUpdatingLocation];
    self.locationCoordinate = [locations lastObject];
    [self performSegueWithIdentifier:@"goToAVFoundation" sender:self];
    //[self presentViewController:self.imagePicker animated:YES completion:^{}];
    
    
}


-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    // Resize image
    UIGraphicsBeginImageContext(CGSizeMake(640, 960));
    [image drawInRect: CGRectMake(0, 0, 640, 960)];
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //UIImage *flipSmallImage = [self flipImageHorizontally:smallImage];
    
    // Upload image
    self.imageData = UIImageJPEGRepresentation(smallImage, 0.05f);
    
    //self.imageToUpload = [PFFile fileWithData:self.imageData];
    //self.imageToUpload = smallImage;

    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    //now go to confirm selfie vc
    [self performSegueWithIdentifier:@"goToConfirmSelfie" sender:self];
    
    

    
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
            
            
            
            [selfie saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    //[self refresh:nil];
                    NSLog(@"Seflie uploaded");
                    
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Your selfie has been posted" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                    [alertView show];
                    
                }
                else{
                    // Log details of the failure
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
            }];
        }
        else{
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    /*
    if (buttonIndex == 0) {
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        //[self presentViewController:self.imagePicker animated:YES completion:nil];
        
    } else if (buttonIndex == 1) {
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //[self presentViewController:self.imagePicker animated:YES completion:nil];
        
    }
    NSLog(@"got here going to start getting location");
     */
    if(buttonIndex == 0 || buttonIndex == 1) {
        [self.locationManager startUpdatingLocation];

    }

    
}

#pragma mark - UITableView delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    //NSLog(@"Number rows is %lu",(unsigned long)[self.categoriesArray count]);
    return [self.categoriesArray count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"categoryCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    // Configure the cell...
    PFObject *categoryObject = [self.categoriesArray objectAtIndex:indexPath.row];
    NSString *category = categoryObject[@"name"];
    //NSLog(@"Name is %@",category);
    [cell.textLabel setText:category];
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PFObject *obj = [self.categoriesArray objectAtIndex:indexPath.row];
    self.selectedCategory = obj[@"name"];
    //set up the corret query here
    self.selfiesQuery = [PFQuery queryWithClassName:@"Selfie"];
    //always show top by points first
    [self.selfiesQuery orderByDescending:@"points"];
    if ([self.selectedCategory isEqualToString:@"Most Popular"]) {
        //[selfiesQuery setLimit:500];
        //just show sorted by points and make sure most popular on
        NSNumber *one = [[NSNumber alloc] initWithBool:YES];
        [self.selfiesQuery whereKey:@"mostPopularOn" equalTo:one];
        [self doSelfieQuery:self.selfiesQuery];
        
    }
    else if ([self.selectedCategory isEqualToString:@"Near Me"]) {
        //only show within 20 miles of current location
        [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
            [self.selfiesQuery whereKey:@"location" nearGeoPoint:geoPoint withinMiles:20.0];
            NSNumber *one = [[NSNumber alloc] initWithBool:YES];
            [self.selfiesQuery whereKey:@"nearMeOn" equalTo:one];
            [self doSelfieQuery:self.selfiesQuery];
        }];
    }
    else {
        //then only show based on selected category
        [self.selfiesQuery whereKey:@"categoryID" equalTo:self.selectedCategory];
        [self doSelfieQuery:self.selfiesQuery];
        
        
    }


    
}


#pragma mark- PFLoginViewController delegate
// Sent to the delegate to determine whether the log in request should be submitted to the server.
- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password {
    // Check if both fields are completed
    if (username && password && username.length != 0 && password.length != 0) {
        return YES; // Begin login process
    }
    
    [[[UIAlertView alloc] initWithTitle:@"Missing Information"
                                message:@"Make sure you fill out all of the information!"
                               delegate:nil
                      cancelButtonTitle:@"ok"
                      otherButtonTitles:nil] show];
    return NO; // Interrupt login process
}
// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:NULL];
}
// Sent to the delegate when the log in attempt fails.
- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
    NSLog(@"Failed to log in...");
}

// Sent to the delegate when the log in screen is dismissed.
- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark- PFSignupViewController delegate


// Sent to the delegate to determine whether the sign up request should be submitted to the server.
- (BOOL)signUpViewController:(PFSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info {
    BOOL informationComplete = YES;
    
    // loop through all of the submitted data
    for (id key in info) {
        NSString *field = [info objectForKey:key];
        if (!field || field.length == 0) { // check completion
            informationComplete = NO;
            break;
        }
    }
    
    // Display an alert if a field wasn't completed
    if (!informationComplete) {
        [[[UIAlertView alloc] initWithTitle:@"Missing Information"
                                    message:@"Make sure you fill out all of the information!"
                                   delegate:nil
                          cancelButtonTitle:@"ok"
                          otherButtonTitles:nil] show];
    }
    
    return informationComplete;
}

// Sent to the delegate when a PFUser is signed up.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    //[self dismissModalViewControllerAnimated:YES]; // Dismiss the PFSignUpViewController
    [self dismissViewControllerAnimated:YES completion:nil];
}

// Sent to the delegate when the sign up attempt fails.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error {
    NSLog(@"Failed to sign up...");
}

// Sent to the delegate when the sign up screen is dismissed.
- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {
    NSLog(@"User dismissed the signUpViewController");
}


@end
