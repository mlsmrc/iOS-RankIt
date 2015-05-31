#import "XLFormBaseCell.h"

@interface XLFormImageModSelectorCell : XLFormBaseCell

@property (readonly,nonatomic) UIImageView *imageView;
@property (readonly,nonatomic) UILabel *textLabel;

/* Tag identificativo classe custom cell */
extern NSString *const XLFormImageModSelectorCellCustom;

@end