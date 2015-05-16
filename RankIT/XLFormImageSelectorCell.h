
#import "XLFormBaseCell.h"



@interface XLFormImageSelectorCell : XLFormBaseCell

@property (nonatomic, readonly) UIImageView * imageView;
@property (nonatomic, readonly) UILabel * textLabel;

extern NSString * const XLFormImageSelectorCellCustom; //tag identificativo classe custom cell
@end
