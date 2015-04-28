#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSMutableArray (SWUtilityButtons)

- (void) sw_addUtilityButtonWithColor:(UIColor *)color title:(NSString *)title;
- (void) sw_addUtilityButtonWithColor:(UIColor *)color attributedTitle:(NSAttributedString *)title;
- (void) sw_addUtilityButtonWithColor:(UIColor *)color icon:(UIImage *)icon;
- (void) sw_addUtilityButtonWithColor:(UIColor *)color normalIcon:(UIImage *)normalIcon selectedIcon:(UIImage *)selectedIcon;
- (void) sw_addUtilityButtonWithGradientHexColor:(int) HexStringUp DownToHexColor: (int)HexStringDown title:(NSString *)title;

@end

@interface NSArray (SWUtilityButtons)

- (BOOL)sw_isEqualToButtons:(NSArray *)buttons;

@end