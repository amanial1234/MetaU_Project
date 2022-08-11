#import "ChatViewController.h"
#import "UIColor+HTColor.h"

@interface ChatViewController ()

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIColor *topColor = [UIColor ht_bitterSweetDarkColor];
    UIColor *bottomColor = [UIColor blackColor];
        
    CAGradientLayer *theViewGradient = [CAGradientLayer layer];
    theViewGradient.colors = [NSArray arrayWithObjects: (id)topColor.CGColor, (id)bottomColor.CGColor, nil];
    theViewGradient.frame = self.view.bounds;
    theViewGradient.startPoint = CGPointZero;
    theViewGradient.endPoint = CGPointMake(0, .1);
    theViewGradient.colors = [NSArray arrayWithObjects: (id)topColor.CGColor, (id)bottomColor.CGColor, nil];
    [self.view.layer insertSublayer:theViewGradient atIndex:0];
}

@end
