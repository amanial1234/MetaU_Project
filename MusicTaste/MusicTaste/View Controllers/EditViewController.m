#import "EditViewController.h"

@interface EditViewController () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *composeBio;
@property (weak, nonatomic) IBOutlet UILabel *characterCount;
@property (weak, nonatomic) IBOutlet UITextField *ageField;

@end

@implementation EditViewController

- (IBAction)closeButton:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)editButton:(id)sender {
    PFUser *current = [PFUser currentUser];
    PFQuery *music = [PFQuery queryWithClassName:@"Music"];
    NSArray *musicUsers = [music findObjects];
    //Saves User's Bio and Age once the Done Button is pressed
    self.author[@"bio"] = self.composeBio.text;
    self.author[@"age"] = self.ageField.text;
    [self.author saveEventually];
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.composeBio becomeFirstResponder];
}

- (void)textViewDidChange:(UITextView *)textView {
    //character Limit
    NSString *substring = [NSString stringWithString:self.composeBio.text];
    if (substring.length > 0) {
        self.characterCount.hidden = NO;
        self.characterCount.text = [NSString stringWithFormat:@"%d characters used", substring.length];
    }
    if (substring.length == 0) {
        self.characterCount.hidden = YES;
    }
    if (substring.length == 100) {
        //Make sure character limit is less than 100
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"You have used too many characters in your Bio!" message:@"Character limit is 100 Bio." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        self.characterCount.textColor = [UIColor redColor];
    }
    if (substring.length < 15) {
        self.characterCount.textColor = [UIColor greenColor];
    }
}
@end
