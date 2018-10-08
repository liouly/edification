//
//  UIView+BackgroundColor.m
//  UIView+BackgroundColor
//
//  Copyright (c) 2015 Draveness. All rights reserved.
//
//  These files are generated by ruby script, if you want to modify code
//  in this file, you are supposed to update the ruby code, run it and
//  test it. And finally open a pull request.

#import "UIView+BackgroundColor.h"
#import "DKNightVersionManager.h"
#import "objc/runtime.h"

@interface UIView ()

@property (nonatomic, strong) UIColor *normalBackgroundColor;

@end

@implementation UIView (BackgroundColor)

+ (void)load {
    static dispatch_once_t onceToken;                                              
    dispatch_once(&onceToken, ^{                                                   
        Class class = [self class];                                                
        SEL originalSelector = @selector(setBackgroundColor:);                                  
        SEL swizzledSelector = @selector(hook_setBackgroundColor:);                                 
        Method originalMethod = class_getInstanceMethod(class, originalSelector);  
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);  
        BOOL didAddMethod =                                                        
        class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));                   
        if (didAddMethod){
            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));           
        } else {                                                                   
            method_exchangeImplementations(originalMethod, swizzledMethod);        
        }
    });
    [DKNightVersionManager addClassToSet:self.class];
}

- (void)hook_setBackgroundColor:(UIColor*)backgroundColor {
    if ([DKNightVersionManager currentThemeVersion] == DKThemeVersionNormal) [self setNormalBackgroundColor:backgroundColor];
    [self hook_setBackgroundColor:backgroundColor];
}

- (void)saveNormalColor {
    self.normalBackgroundColor = self.backgroundColor;
}

- (UIColor *)nightBackgroundColor {
    UIColor *nightColor = objc_getAssociatedObject(self, @selector(nightBackgroundColor));
    if (nightColor) {
        return nightColor;
    } else {
        UIColor *resultColor = self.normalBackgroundColor ?: [UIColor clearColor];
        return resultColor;
    }
}

- (void)setNightBackgroundColor:(UIColor *)nightBackgroundColor {
    if ([DKNightVersionManager currentThemeVersion] == DKThemeVersionNight) [self setBackgroundColor:nightBackgroundColor];
    objc_setAssociatedObject(self, @selector(nightBackgroundColor), nightBackgroundColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)normalBackgroundColor {
    return objc_getAssociatedObject(self, @selector(normalBackgroundColor));
}

- (void)setNormalBackgroundColor:(UIColor *)normalBackgroundColor {
    objc_setAssociatedObject(self, @selector(normalBackgroundColor), normalBackgroundColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
