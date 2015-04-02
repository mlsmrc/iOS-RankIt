#import <UIKit/UIKit.h>
#import "Poll.h"

@interface ViewController : UIViewController

@property (nonatomic,strong) Poll *p;
@property (nonatomic,weak) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UITextView *description;
@property (weak, nonatomic) IBOutlet UILabel *deadline;
@property (weak, nonatomic) IBOutlet UILabel *lastUpdate;
@property (weak, nonatomic) IBOutlet UIButton *vota;

@end