/* Permette di fare il segue con dissolvenza */
#import "Dissolvenza.h"

@implementation Dissolvenza

- (void) perform {
    
    UIViewController *src = (UIViewController *) self.sourceViewController;
    UIViewController *dst = (UIViewController *) self.destinationViewController;
    
    [UIView transitionWithView:src.navigationController.view duration:.4 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        
        [src.navigationController pushViewController:dst animated:NO];
        
    }completion:NULL];
    
}

@end