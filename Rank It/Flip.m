#import "Flip.h"

@implementation Flip

- (void) perform {
    
    UIViewController *src = (UIViewController *) self.sourceViewController;
    UIViewController *dst = (UIViewController *) self.destinationViewController;
    [UIView transitionWithView:src.navigationController.view duration:.5
     
                       options:UIViewAnimationOptionTransitionFlipFromLeft
     
                    animations:^{
                        
                        [src.navigationController pushViewController:dst animated:NO];
                        
                    }
     
                    completion:NULL];
    
}

@end