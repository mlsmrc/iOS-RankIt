#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"

@interface UMTableViewCell : SWTableViewCell

@property (weak, readwrite) IBOutlet UILabel *Nome;
@property (weak, readwrite) IBOutlet UILabel *Scadenza;

@end