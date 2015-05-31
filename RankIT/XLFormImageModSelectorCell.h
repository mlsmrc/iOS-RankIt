//
//  XLFormImageModSelectorCell.h
//  RankIT
//
//  Created by Giulio  Salierno on 01/06/15.
//  Copyright (c) 2015 Giulio Salierno. All rights reserved.
//

#import "XLFormBaseCell.h"

@interface XLFormImageModSelectorCell : XLFormBaseCell

@property (readonly,nonatomic) UIImageView *imageView;
@property (readonly,nonatomic) UILabel *textLabel;

/* Tag identificativo classe custom cell */
extern NSString *const XLFormImageModSelectorCellCustom;

@end
