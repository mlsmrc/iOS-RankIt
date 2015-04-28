#import "NSMutableArray+SWUtilityButtons.h"

/* Utile per convertire un colore da esadecimale a "colore Obj-C" */
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation NSMutableArray (SWUtilityButtons)

- (void) sw_addUtilityButtonWithColor:(UIColor *)color title:(NSString *)title {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = color;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button.titleLabel setAdjustsFontSizeToFitWidth:YES];
    [self addObject:button];
    
}

- (void) sw_addUtilityButtonWithGradientHexColor:(int) HexStringUp DownToHexColor: (int)HexStringDown title:(NSString *)title {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = button.layer.bounds;
    gradientLayer.colors = [NSArray arrayWithObjects:(id)(UIColorFromRGB(HexStringUp)).CGColor,(id)(UIColorFromRGB(HexStringDown)).CGColor,nil];
    gradientLayer.locations = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0f],[NSNumber numberWithFloat:1.0f],nil];
    gradientLayer.cornerRadius = button.layer.cornerRadius;
    [button.layer addSublayer:gradientLayer];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button.titleLabel setAdjustsFontSizeToFitWidth:YES];
    [self addObject:button];
    
}

- (void) sw_addUtilityButtonWithColor:(UIColor *)color attributedTitle:(NSAttributedString *)title {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = color;
    [button setAttributedTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addObject:button];
    
}

- (void) sw_addUtilityButtonWithColor:(UIColor *)color icon:(UIImage *)icon {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = color;
    [button setImage:icon forState:UIControlStateNormal];
    [self addObject:button];
    
}

- (void) sw_addUtilityButtonWithColor:(UIColor *)color normalIcon:(UIImage *)normalIcon selectedIcon:(UIImage *)selectedIcon {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = color;
    [button setImage:normalIcon forState:UIControlStateNormal];
    [button setImage:selectedIcon forState:UIControlStateHighlighted];
    [button setImage:selectedIcon forState:UIControlStateSelected];
    [self addObject:button];
    
}

@end

@implementation NSArray (SWUtilityButtons)

- (BOOL) sw_isEqualToButtons:(NSArray *)buttons {
    
    buttons = [buttons copy];
    if(!buttons || self.count != buttons.count) return NO;
    
    for(NSUInteger idx = 0; idx < self.count; idx++) {
        
        id buttonA = self[idx];
        id buttonB = buttons[idx];
        if (![buttonA isKindOfClass:[UIButton class]] || ![buttonB isKindOfClass:[UIButton class]]) return NO;
        if (![[self class] sw_button:buttonA isEqualToButton:buttonB]) return NO;
        
    }
    
    return YES;
}

+ (BOOL) sw_button:(UIButton *)buttonA isEqualToButton:(UIButton *)buttonB {
    
    if(!buttonA || !buttonB) return NO;
    
    UIColor *backgroundColorA = buttonA.backgroundColor;
    UIColor *backgroundColorB = buttonB.backgroundColor;
    BOOL haveEqualBackgroundColors = (!backgroundColorA && !backgroundColorB) || [backgroundColorA isEqual:backgroundColorB];
    
    NSString *titleA = [buttonA titleForState:UIControlStateNormal];
    NSString *titleB = [buttonB titleForState:UIControlStateNormal];
    BOOL haveEqualTitles = (!titleA && !titleB) || [titleA isEqualToString:titleB];
    
    UIImage *normalIconA = [buttonA imageForState:UIControlStateNormal];
    UIImage *normalIconB = [buttonB imageForState:UIControlStateNormal];
    BOOL haveEqualNormalIcons = (!normalIconA && !normalIconB) || [normalIconA isEqual:normalIconB];
    
    UIImage *selectedIconA = [buttonA imageForState:UIControlStateSelected];
    UIImage *selectedIconB = [buttonB imageForState:UIControlStateSelected];
    BOOL haveEqualSelectedIcons = (!selectedIconA && !selectedIconB) || [selectedIconA isEqual:selectedIconB];
    
    return haveEqualBackgroundColors && haveEqualTitles && haveEqualNormalIcons && haveEqualSelectedIcons;
    
}

@end