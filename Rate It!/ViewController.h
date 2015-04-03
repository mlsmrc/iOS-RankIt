#import <UIKit/UIKit.h>
#import "Poll.h"

@interface ViewController : UIViewController

@property (nonatomic,strong) Poll *p;
@property (nonatomic,weak) IBOutlet UILabel *name;
@property (nonatomic,weak) IBOutlet UITextView *description;
@property (nonatomic,weak) IBOutlet UIImageView *image;
@property (nonatomic,weak) IBOutlet UILabel *deadline;
@property (nonatomic,weak) IBOutlet UILabel *lastUpdate;
@property (nonatomic,weak) IBOutlet UIButton *vota;

@end