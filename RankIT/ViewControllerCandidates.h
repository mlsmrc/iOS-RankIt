#import <UIKit/UIKit.h>
#import "Candidate.h"

@interface ViewControllerCandidates : UIViewController

@property (strong,nonatomic) Candidate *c;
@property (weak,nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak,nonatomic) IBOutlet UILabel *name;
@property (weak,nonatomic) IBOutlet UIImageView *image;
@property (weak,nonatomic) IBOutlet UITextView *description;

@end