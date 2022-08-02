#import "DetailsViewController.h"
#import "MatchCell.h"
#import <Parse/Parse.h>
#import "UIImageView+AFNetworking.h"
#import "MatchmakingViewController.h"

#define DRAG_AREA_PADDING 5

@interface DetailsViewController ()

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //Set Username, Image, and Bio
    self.screenName.text = [self.author valueForKey:@"username"];
    self.bio.text = [self.author valueForKey:@"bio"];
    NSString *URLString = [self.author valueForKey:@"userimage"];
    NSString *stringWithoutNormal = [URLString stringByReplacingOccurrencesOfString:@"_normal" withString:@""];
    NSURL *urlNew = [NSURL URLWithString:stringWithoutNormal];
    [self.profileView setImageWithURL: urlNew];
    self.profileView.layer.cornerRadius = self.profileView.frame.size.height/2;
    //Sets intial constraints on views
    self.lastBounds = self.view.bounds;
    
    self.dragView.layer.cornerRadius = self.dragView.bounds.size.height / 2;
    
    self.acceptView.layer.cornerRadius = self.acceptView.bounds.size.height / 2;
    self.acceptView.layer.borderWidth = 5;
    
    self.rejectView.layer.cornerRadius = self.rejectView.bounds.size.height / 2;
    self.rejectView.layer.borderWidth = 5;
    
    self.initialDragViewY = self.dragViewY.constant;
    
    [self updateAcceptView];
    [self updateRejectView];
    
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (!CGRectEqualToRect(self.view.bounds, self.lastBounds)) {
        [self boundsChanged];
        self.lastBounds = self.view.bounds;
    }
}

- (void)boundsChanged {
    [self returnToStartLocationAnimated:NO];
    //makes sure the Views are above the DragAreaView
    [self.dragAreaView bringSubviewToFront:self.dragView];
    [self.dragAreaView bringSubviewToFront:self.acceptView];
    [self.dragAreaView bringSubviewToFront:self.rejectView];
    [self.view layoutIfNeeded];
}
#pragma mark - Actions

- (IBAction)panAction:(id)sender {
    if (self.panGesture.state == UIGestureRecognizerStateChanged) {
        [self moveObject];
    }
    else if (self.panGesture.state == UIGestureRecognizerStateEnded) {
        if (self.isAcceptReached) {
            //Removes user from matches array and segues to MatchmakingViewController
            [self performSegueWithIdentifier:@"backSegue" sender:nil];
            [self.matches removeObject:self.author];
            if (self.completion) {
                self.completion();
            }
        }
        if (self.isRejectReached) {
            //Removes user from matches array and segues to MatchmakingViewController
            [self performSegueWithIdentifier:@"backSegue" sender:nil];
            [self.matches removeObject:self.author];
            if (self.completion) {
                self.completion();
            }
        }
        else {
            //If neither views are reached send the view back to its intial location
            [self returnToStartLocationAnimated:YES];
        }
    }
}

- (void)moveObject {
    // Algorithm to move view using constraints
    CGFloat minX = DRAG_AREA_PADDING;
    CGFloat maxX = self.dragAreaView.bounds.size.width - self.dragView.bounds.size.width - DRAG_AREA_PADDING;
    
    CGFloat minY = DRAG_AREA_PADDING;
    CGFloat maxY = self.dragAreaView.bounds.size.height - self.dragView.bounds.size.height - DRAG_AREA_PADDING;
    
    CGPoint translation = [self.panGesture translationInView:self.dragAreaView];
    
    CGFloat dragViewX = self.dragViewX.constant + translation.x;
    CGFloat dragViewY = self.dragViewY.constant + translation.y;
    
    if (dragViewX < minX) {
        dragViewX = minX;
        translation.x += self.dragViewX.constant - minX;
    }
    else if (dragViewX > maxX) {
        dragViewX = maxX;
        translation.x += self.dragViewX.constant - maxX;
    }
    else {
        translation.x = 0;
    }
    
    if (dragViewY < minY) {
        dragViewY = minY;
        translation.y += self.dragViewY.constant - minY;
    }
    else if (dragViewY > maxY) {
        dragViewY = maxY;
        translation.y += self.dragViewY.constant - maxY;
    }
    else {
        translation.y = 0;
    }
    self.dragViewX.constant = dragViewX;
    self.dragViewY.constant = dragViewY;
    
    [self.panGesture setTranslation:translation inView:self.dragAreaView];
    
    [UIView animateWithDuration:0.05 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        [self.view layoutIfNeeded];
    } completion:nil];
    
    [self updateAcceptView];
    [self updateRejectView];
}

- (void)updateAcceptView {
    //Updates the Accept view to a green if it is reached and changes text
    UIColor *goalColor = self.isAcceptReached ? [UIColor greenColor] : [UIColor colorWithRed:174/255.0 green:0 blue:0 alpha:1];
    self.acceptView.layer.borderColor = goalColor.CGColor;
    self.acceptLabel.textColor = goalColor;
    self.acceptLabel.text = self.isAcceptReached ? @"Accepted!" : @"Accept!";
}
- (void)updateRejectView {
    //Updates the Reject view to a brighter red if it is reached and changes text
    UIColor *goalColor = self.isRejectReached ? [UIColor redColor] : [UIColor colorWithRed:174/255.0 green:0 blue:0 alpha:1];
    self.rejectView.layer.borderColor = goalColor.CGColor;
    self.rejectLabel.textColor = goalColor;
    self.rejectLabel.text = self.isRejectReached ? @"Rejected!" : @"Reject!";
}

- (void)returnToStartLocationAnimated:(BOOL)animated {
    //Returns to start location if you let go and it is not in either accept or reject view
    self.dragViewX.constant = (self.dragAreaView.bounds.size.width - self.dragView.bounds.size.width) / 2;
    self.dragViewY.constant = self.initialDragViewY;
    
    if (animated) {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            [self.view layoutIfNeeded];
        } completion:nil];
    }
}
#pragma mark - Getters

- (BOOL)isAcceptReached {
    //Checks if Accept is reached
    CGFloat distanceFromGoal = sqrt(pow(self.dragView.center.x - self.acceptView.center.x, 2) + pow(self.dragView.center.y - self.acceptView.center.y, 2));
    return distanceFromGoal < self.dragView.bounds.size.width / 2;
}
- (BOOL)isRejectReached {
    //Checks if Reject is reached
    CGFloat distanceFromGoal = sqrt(pow(self.dragView.center.x - self.rejectView.center.x, 2) + pow(self.dragView.center.y - self.rejectView.center.y, 2));
    return distanceFromGoal < self.dragView.bounds.size.width / 2;
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"backSegue"]) {
        UINavigationController *navigationController = [segue destinationViewController];
        MatchmakingViewController *matchmakingController = (MatchmakingViewController*)navigationController.topViewController;
        //Passes the matches for the matchmakingViewController
        matchmakingController.matches = self.matches;
    }
}

#pragma mark -


@end
