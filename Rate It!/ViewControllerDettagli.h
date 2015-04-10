#import <UIKit/UIKit.h>
#import "Poll.h"

@interface ViewControllerDettagli : UIViewController

@property (nonatomic,strong) Poll *p;
@property (nonatomic,weak) IBOutlet UILabel *name;
@property (nonatomic,weak) IBOutlet UITextView *description;
@property (nonatomic,weak) IBOutlet UIImageView *image;
@property (nonatomic,weak) IBOutlet UILabel *deadline;
@property (nonatomic,weak) IBOutlet UILabel *lastUpdate;
@property (nonatomic,weak) IBOutlet UIScrollView *scrollView;

@end