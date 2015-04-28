#import <UIKit/UIKit.h>
@class SWTableViewCell;

#define kUtilityButtonWidthDefault 90

@interface SWUtilityButtonView : UIView

- (id) initWithUtilityButtons:(NSArray *)utilityButtons parentCell:(SWTableViewCell *)parentCell utilityButtonSelector:(SEL)utilityButtonSelector;
- (id) initWithFrame:(CGRect)frame utilityButtons:(NSArray *)utilityButtons parentCell:(SWTableViewCell *)parentCell utilityButtonSelector:(SEL)utilityButtonSelector;

@property (weak,readonly,nonatomic) SWTableViewCell *parentCell;
@property (copy,nonatomic) NSArray *utilityButtons;
@property (assign,nonatomic) SEL utilityButtonSelector;

- (void) setUtilityButtons:(NSArray *)utilityButtons WithButtonWidth:(CGFloat)width;
- (void) pushBackgroundColors;
- (void) popBackgroundColors;

@end