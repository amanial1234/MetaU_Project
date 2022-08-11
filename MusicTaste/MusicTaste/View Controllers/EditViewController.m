#import "EditViewController.h"
#import "Parse/Parse.h"

@interface EditViewController () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *composeBio;
@property (weak, nonatomic) IBOutlet UILabel *characterCount;
@property (weak, nonatomic) IBOutlet UITextField *ageField;
@property (weak, nonatomic) IBOutlet UITextField *stateField;
@property (weak, nonatomic) IBOutlet UIImageView *composeview;
@property (weak, nonatomic) IBOutlet UIButton *editButton;

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
    self.author[@"location"] = self.stateField.text;
    [self.author saveEventually];
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.composeBio becomeFirstResponder];
    
    self.editButton.layer.cornerRadius = 12;
    self.editButton.layer.borderWidth = 1;
    self.editButton.layer.borderColor = [UIColor whiteColor].CGColor;
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    PFQuery *music = [PFQuery queryWithClassName:@"Music"];
    //gets image
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    self.author[@"usercustomimage"] = [self getPFFileFromImage: editedImage];
    [self.author saveInBackground];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)selectImageFromLibrary:(id)sender {
    //gets photo from library
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePickerVC animated:YES completion:nil];
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
- (PFFileObject *)getPFFileFromImage: (UIImage *_Nullable) image{
    if (!image){
        return nil;
    }
    NSData *imageData = UIImagePNGRepresentation(image) ;
    if (!imageData) {
        return nil;
    }
    return [PFFileObject fileObjectWithName:@"image.png" data: imageData];
}
@end
