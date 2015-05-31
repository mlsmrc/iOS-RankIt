/* Permette di fare il segue con il flip da sinistra */

#import "Flip.h"

@implementation Flip

- (void) perform {
    
    UIViewController *src = (UIViewController *) self.sourceViewController;
    UIViewController *dst = (UIViewController *) self.destinationViewController;
    
    [UIView transitionWithView:src.navigationController.view duration:.4 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
        
        [src.navigationController pushViewController:dst animated:NO];
        
    }completion:NULL];
    
}

@end