//
//  LeaderboardViewController.m
//  Selfie War
//
//  Created by Jonathan Cobian on 9/28/14.
//  Copyright (c) 2014 com.jcobian. All rights reserved.
//

#import "LeaderboardViewController.h"

@interface LeaderboardViewController ()

@end

@implementation LeaderboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"congruent_pentagon.png"]];

    NSString *labelText = [NSString stringWithFormat:@"You: %@",self.currentUsername];
    [self.myUsernameLabel setText:labelText];
    //NSLog(@"HERE2:%@",self.currenUsernamePoints);
    [self.myPointsLabel setText:self.currenUsernamePoints];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backBarButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.leaderboardUserArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LeaderboardTableViewCell *cell = (LeaderboardTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"leaderboardCell" forIndexPath:indexPath];
    // Configure the cell...
    NSString *username = [self.leaderboardUserArray objectAtIndex:indexPath.row];
    NSNumber *careerPts = [self.leaderboardPointsArray objectAtIndex:indexPath.row];
    /*PFUser *obj = [self.usersArray objectAtIndex:indexPath.row];
    NSString *username = [obj username];
    NSNumber *careerPts = [obj objectForKey:@"careerPoints"];
     */
    
    NSString *pts = [[NSString alloc] initWithFormat:@"%@",careerPts];
    [cell.pointsLabel setText:pts];
    [cell.userNameLabel setText:username];
    
    return cell;
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
