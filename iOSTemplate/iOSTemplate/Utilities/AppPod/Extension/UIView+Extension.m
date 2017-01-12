//
//  UIView+Extension.m
//  iOSTemplate
//
//  Created by ArthurWang on 17/1/12.
//  Copyright (c) 2017年 wang. All rights reserved.
//

#import "UIView+Extension.h"

#import <objc/runtime.h>

static char UIViewPropertyListKey;

@implementation UIView (Extension)

- (float) x
{
    return self.frame.origin.x;
}
-(void) setX:(float)x
{
    self.frame = CGRectSetX(self.frame, x);
}
- (float) y
{
    return self.frame.origin.y;
}
-(void) setY:(float)y
{
    self.frame = CGRectSetY(self.frame, y);
}
- (float) width
{
    return self.frame.size.width;
}
-(void) setWidth:(float)width
{
    self.frame = CGRectSetWidth(self.frame, width);
}
- (float) height
{
    return self.frame.size.height;
}
-(void) setHeight:(float)height
{
    self.frame = CGRectSetHeight(self.frame, height);
}
- (float) right
{
    return CGRectGetMaxX (self.frame);
}
- (float) left
{
    return CGRectGetMinX (self.frame);
}
- (float) bottom
{
    return CGRectGetMaxY (self.frame);
}
- (BOOL) visible
{
    return ! self.hidden;
}
- (void) setVisible: (BOOL) shouldBeVisible
{
    self.hidden = ! shouldBeVisible;
}
//==============================================================================
-(void) centerSubview: (UIView*) subView
{
    [subView setFrame: CGRectMake (roundf ((self.width - subView.width) * 0.5f),
                                   roundf ((self.height - subView.height) * 0.5f),
                                   subView.width,
                                   subView.height)];
}
- (void) centerWithSize: (CGSize) newSize
{
    [self centerWithSize: newSize roundPosition: NO];
}

- (void) centerWithSize: (CGSize) newSize roundPosition: (BOOL) roundPosition
{
    CGSize parentSize = self.superview.bounds.size;
    
    const float xpos = (parentSize.width - newSize.width) * 0.5f;
    const float ypos = (parentSize.height - newSize.height) * 0.5f;
    
    self.frame = CGRectMake (roundPosition ? roundf (xpos) : xpos, roundPosition ? roundf (ypos) : ypos, newSize.width, newSize.height);
}

//==============================================================================
- (UIView*) subviewOfClassType: (Class) classType searchRecursively: (BOOL) searchRecursively
{
    if ([self isKindOfClass: classType])
    {
        return self;
    }
    
    for (UIView* view in self.subviews)
    {
        if ([view isKindOfClass: classType])
        {
            return view;
        }
        else
        {
            if (searchRecursively)
            {
                UIView* resultView = [view subviewOfClassType: classType searchRecursively: searchRecursively];
                if(resultView)
                    return resultView;
            }
        }
    }
    
    return nil;
}

- (UIView*) subviewOfClassType: (Class) classType
{
    return [self subviewOfClassType: classType searchRecursively: NO];
}

- (UIView*) superviewOfClassType: (Class) classType
{
    UIView* view = self.superview;
    
    while (view != nil)
    {
        if ([view isKindOfClass: classType])
        {
            return view;
        }
        
        view = view.superview;
    }
    
    return nil;
}

- (UIView*) superviewWithTag: (NSInteger) tag
{
    UIView* view = self.superview;
    
    while (view != nil)
    {
        if (view.tag == tag)
        {
            return view;
        }
        
        view = view.superview;
    }
    
    return nil;
}

//==============================================================================
- (void) setPropertyList: (NSMutableDictionary*) newPropertyList
{
    objc_setAssociatedObject (self, &UIViewPropertyListKey, newPropertyList, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSMutableDictionary*) propertyList
{
    return objc_getAssociatedObject (self, &UIViewPropertyListKey);
}


//==============================================================================
- (UIImage*) snapshotImage
{
    return [self snapshotImageClipped: self.bounds];
}

- (UIImage*) snapshotImageClipped: (CGRect) rect
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, 0.0f);
    [self.layer renderInContext: UIGraphicsGetCurrentContext()];
    UIImage* snapshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if (!CGRectEqualToRect (self.bounds, rect))
    {
        CGImageRef resized = CGImageCreateWithImageInRect (snapshot.CGImage, rect);
        snapshot = [UIImage imageWithCGImage: resized];
        CGImageRelease(resized);
    }
    
    return snapshot;
}

@end


/*
 * Extension for Contraints
 */

@implementation UIView (Constraints)

-(NSLayoutConstraint*) constraintForAttribute:(NSLayoutAttribute) attribute {
    NSLayoutConstraint* result = nil;
    for (NSLayoutConstraint* constraint in self.constraints) {
        if (constraint.firstAttribute == attribute) {
            result = constraint;
            break;
        }
    }
    return result;
}

-(NSLayoutConstraint*) constraintWidth {
    return [self constraintForAttribute:NSLayoutAttributeWidth];
}

-(NSLayoutConstraint*) constraintHeight {
    return [self constraintForAttribute:NSLayoutAttributeHeight];
}

@end
