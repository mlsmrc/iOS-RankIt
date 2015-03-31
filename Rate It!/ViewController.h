#import <UIKit/UIKit.h>
#import "Poll.h"

@interface ViewController : UIViewController

@property (nonatomic,strong) Poll *p;
@property (nonatomic,strong) UILabel *name;
@property (nonatomic,strong) UILabel *description;
@property (nonatomic,strong) UILabel *deadline;

@end