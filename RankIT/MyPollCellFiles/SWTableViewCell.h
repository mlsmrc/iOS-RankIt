#import <UIKit/UIKit.h>
#import <UIKit/UIGestureRecognizerSubclass.h>
#import "SWCellScrollView.h"
#import "SWLongPressGestureRecognizer.h"
#import "SWUtilityButtonTapGestureRecognizer.h"
#import "NSMutableArray+SWUtilityButtons.h"

@class SWTableViewCell;

typedef NS_ENUM(NSInteger, SWCellState)
{
    kCellStateCenter,
    kCellStateLeft,
    kCellStateRight,
};

@protocol SWTableViewCellDelegate <NSObject>

@optional
- (void) swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index;
- (void) swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index;
- (void) swipeableTableViewCell:(SWTableViewCell *)cell scrollingToState:(SWCellState)state;
- (BOOL) swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell;
- (BOOL) swipeableTableViewCell:(SWTableViewCell *)cell canSwipeToState:(SWCellState)state;
- (void) swipeableTableViewCellDidEndScrolling:(SWTableViewCell *)cell;
- (void) swipeableTableViewCell:(SWTableViewCell *)cell didScroll:(UIScrollView *)scrollView;

@end

@interface SWTableViewCell : UITableViewCell

@property (weak,nonatomic) IBOutlet UILabel *Nome;
@property (weak,nonatomic) IBOutlet UILabel *Scadenza;
@property (weak,nonatomic) IBOutlet UIView *cell;
@property (copy,nonatomic) NSArray *leftUtilityButtons;
@property (copy,nonatomic) NSArray *rightUtilityButtons;
@property (weak,nonatomic) id <SWTableViewCellDelegate> delegate;

- (void) setRightUtilityButtons:(NSArray *)rightUtilityButtons WithButtonWidth:(CGFloat) width;
- (void) setLeftUtilityButtons:(NSArray *)leftUtilityButtons WithButtonWidth:(CGFloat) width;
- (void) hideUtilityButtonsAnimated:(BOOL)animated;
- (void) showLeftUtilityButtonsAnimated:(BOOL)animated;
- (void) showRightUtilityButtonsAnimated:(BOOL)animated;
- (BOOL) isUtilityButtonsHidden;

@end