#import <UIKit/UIKit.h>
#import "Poll.h"

@interface ViewController : UIViewController

@property (nonatomic,strong) Poll *p;
@property (nonatomic,strong) IBOutlet UITextView *description;
@property (nonatomic,strong) IBOutlet UILabel *deadline;

@end