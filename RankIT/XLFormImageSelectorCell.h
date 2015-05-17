#import "XLFormBaseCell.h"

@interface XLFormImageSelectorCell : XLFormBaseCell

@property (readonly,nonatomic) UIImageView *imageView;
@property (readonly,nonatomic) UILabel *textLabel;

/* Tag identificativo classe custom cell */
extern NSString *const XLFormImageSelectorCellCustom;

@end