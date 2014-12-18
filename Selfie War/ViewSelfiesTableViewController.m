//
//  ViewSelfiesTableViewController.m
//  Selfie War
//
//  Created by Jonathan Cobian on 9/27/14.
//  Copyright (c) 2014 com.jcobian. All rights reserved.
//

#import "ViewSelfiesTableViewController.h"

@interface ViewSelfiesTableViewController ()

@end

@implementation ViewSelfiesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"congruent_pentagon.png"]];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.selfiesToAddOne = [[NSMutableArray alloc] init];
    self.selfiesToSubOne = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)updatePointsOnObject:(PFObject *)obj andDirection:(NSString *)direction {
    //update points on the seflie
    NSNumber *points = obj[@"points"];
    if([direction isEqualToString:@"Up"]) {
        points = [NSNumber numberWithInt:[points intValue]+1];

    }
    else {
        if(points > 0) {
            points = [NSNumber numberWithInt:[points intValue]-1];

        }
        else {
            return;
        }

    }
    [obj setObject:points forKey:@"points"];
    [obj saveInBackground];
}
-(void)updateCareerPointsOnUsername:(NSString *)username andDirection:(NSString *)direction {
    //update careeer points for user
    PFQuery *userQuery = [PFUser query];
    [userQuery whereKey:@"username" equalTo:username];
    [userQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        NSNumber *careerPoints = object[@"careerPoints"];
        if([direction isEqualToString:@"Up"]) {
            careerPoints = [NSNumber numberWithInt:[careerPoints intValue]+1];

        }
        else {
            if(careerPoints > 0) {
                careerPoints = [NSNumber numberWithInt:[careerPoints intValue]-1];
            }
            else {
                return;
            }

        }
        [object setObject:careerPoints forKey:@"careerPoints"];
        [object saveInBackground];
        
    }];
}
-(void)viewWillDisappear:(BOOL)animated {
    for (PFObject *obj in self.selfiesToAddOne) {
        NSLog(@"Actually adding to %@", obj);
        [self updatePointsOnObject:obj andDirection:@"Up"];
        [self updateCareerPointsOnUsername:obj[@"userID"] andDirection:@"Up"];
        
    }
    for (PFObject *obj in self.selfiesToSubOne) {
        NSLog(@"Actually subbing to %@", obj);
        [self updatePointsOnObject:obj andDirection:@"Down"];
        [self updateCareerPointsOnUsername:obj[@"userID"] andDirection:@"Down"];

        
    }
    [self.selfiesToAddOne removeAllObjects];
    [self.selfiesToSubOne removeAllObjects];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.selfiesObjects count];
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SelfieTableViewCell *cell = (SelfieTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"selfieCell" forIndexPath:indexPath];
    // Configure the cell...
    PFObject *selfieObject = [self.selfiesObjects objectAtIndex:indexPath.row];
    [cell.myImageView setFile:selfieObject[@"image"]];
    [cell.myImageView loadInBackground];
    NSString *label = [NSString stringWithFormat:@"Points: %@",selfieObject[@"points"]];
    [cell.pointsLabel setText:label];
    
    //so we know what object to act on
    cell.upButton.tag = indexPath.row;
    cell.downButton.tag = indexPath.row;

    [cell.upButton addTarget:self action:@selector(upButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.downButton addTarget:self action:@selector(downButtonClicked:) forControlEvents:UIControlEventTouchUpInside];

    //if user has already voted on this
    if([self.alreadyVotedArray containsObject:[selfieObject objectId]]) {
        //NSLog(@"YOU HAVE ALREADY VOTED ON %@",[selfieObject objectId]);
        [cell.upButton setUserInteractionEnabled:NO];
        [cell.downButton setUserInteractionEnabled:NO];
        [cell.upButton setEnabled:NO];
        [cell.downButton setEnabled:NO];
        [cell.upButton setAlpha:0.5f];
        [cell.downButton setAlpha:0.5f];


    }
    else {
        [cell.upButton setBackgroundImage:[self imageWithColor:[UIColor greenColor]] forState:UIControlStateHighlighted];
        [cell.downButton setBackgroundImage:[self imageWithColor:[UIColor redColor]] forState:UIControlStateHighlighted];
    }
    [cell setDelegate:self];
    [cell setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"congruent_pentagon.png"]]];
    return cell;
}
-(void)registerVoteWithSelfieID:(NSString *)selfieID andDirection:(NSString *)direction {

    PFObject *newVote = [PFObject objectWithClassName:@"Votes"];
    newVote[@"userID"] = [[PFUser currentUser] username];
    newVote[@"selfieID"] = selfieID;
    newVote[@"direction"] = direction;
    [newVote saveInBackground];
    NSLog(@"saving vote in background");
}
-(void)upButtonClicked:(UIButton*)sender
{
    NSLog(@"tag button up clicked with tag %ld",(long)sender.tag);
    PFObject *obj = [self.selfiesObjects objectAtIndex:sender.tag];
    NSLog(@"Object adding to add array is %@",obj);
    [self.selfiesToAddOne addObject:obj];
    [sender setUserInteractionEnabled:NO];
    [sender setEnabled:NO];
    [self registerVoteWithSelfieID:[obj objectId] andDirection:[[sender titleLabel] text]];
}
-(void)downButtonClicked:(UIButton*)sender
{
    NSLog(@"tag button down clicked with tag %ld",(long)sender.tag);
    PFObject *obj = [self.selfiesObjects objectAtIndex:sender.tag];
    NSLog(@"Object adding to sub array is %@",obj);
    [self.selfiesToSubOne addObject:obj];
    [sender setUserInteractionEnabled:NO];
    [sender setEnabled:NO];
    [self registerVoteWithSelfieID:[obj objectId] andDirection:[[sender titleLabel] text]];

}
-(void)upDownButtonPressedWithButton:(UIButton *)button {
    NSLog(@"updown called");
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(SelfieTableViewCell *)button.superview];
    /*SelfieTableViewCell *cell = (SelfieTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    [cell.upButton setUserInteractionEnabled:NO];
    [cell.downButton setUserInteractionEnabled:NO];
    [cell.upButton setEnabled:NO];
    [cell.downButton setEnabled:NO];
    [cell.upButton setAlpha:0.5f];
    [cell.downButton setAlpha:0.5f];
    [self.tableView reloadData];*/
    PFObject *obj = [self.selfiesObjects objectAtIndex:indexPath.row];
    NSLog(@"index path row is %ld",(long)indexPath.row);
    if ([[[button titleLabel] text] isEqualToString:@"Up"]) {
        [self.selfiesToAddOne addObject:obj];
        NSLog(@"Will Adding %@",obj);
    }
    else {
        [self.selfiesToSubOne addObject:obj];
        NSLog(@"Will Subbing %@",obj);

    }
    [button setUserInteractionEnabled:NO];
    [button setEnabled:NO];
    PFObject *newVote = [PFObject objectWithClassName:@"Votes"];
    newVote[@"userID"] = [[PFUser currentUser] username];
    newVote[@"selfieID"] = [obj objectId];
    newVote[@"direction"] = [[button titleLabel] text];
    [newVote saveInBackground];
    NSLog(@"saving vote in background");

}

- (IBAction)backButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    //[self.navigationController popViewControllerAnimated:YES];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
