//
//  UIView+Extension.h
//  iOSTemplate
//
//  Created by ArthurWang on 17/1/12.
//  Copyright (c) 2017年 wang. All rights reserved.
//

#import <UIKit/UIKit.h>

//==============================================================================
CG_INLINE CGRect CGRectSetHeight (CGRect rect, CGFloat height)
{
    rect.size.height = height;
    return rect;
}

CG_INLINE CGRect CGRectSetWidth (CGRect rect, CGFloat width)
{
    rect.size.width = width;
    return rect;
}

UIKIT_STATIC_INLINE CGRect CGRectSetSize (CGRect rect, CGSize newSize)
{
    return CGRectMake (rect.origin.x, rect.origin.y, newSize.width, newSize.height);
}

UIKIT_STATIC_INLINE CGRect CGRectSetPosition (CGRect rect, CGPoint newPosition)
{
    return CGRectMake (newPosition.x, newPosition.y, rect.size.width, rect.size.height);
}

CG_INLINE CGRect CGRectSetX (CGRect rect, CGFloat x)
{
    rect.origin.x = x;
    return rect;
}

CG_INLINE CGRect CGRectSetY (CGRect rect, CGFloat y)
{
    rect.origin.y = y;
    return rect;
}

UIKIT_STATIC_INLINE CGRect CGRectRoundF (CGRect rect)
{
    return CGRectMake (roundf (rect.origin.x), roundf (rect.origin.y), roundf (rect.size.width), roundf (rect.size.height));
}

UIKIT_STATIC_INLINE CGRect CGRectRound (CGRect rect)
{
    return CGRectRoundF (rect);
}

UIKIT_STATIC_INLINE CGPoint CGPointRound (CGPoint point)
{
    return CGPointMake (roundf (point.x), roundf (point.y));
}

//==============================================================================
UIKIT_STATIC_INLINE CGPoint CGPointInvalid()
{
    return CGPointMake (FLT_MIN, FLT_MIN);
}

UIKIT_STATIC_INLINE BOOL CGPointIsValid(CGPoint point)
{
    return !CGPointEqualToPoint(point, CGPointInvalid());
}

//==============================================================================
@interface UIView (Extension)

@property (nonatomic, assign) float x;
@property (nonatomic, assign) float y;
@property (nonatomic, assign) float width;
@property (nonatomic, assign) float height;
@property (nonatomic, readonly) float right;
@property (nonatomic, readonly) float left;
@property (nonatomic, readonly) float bottom;
@property (nonatomic, assign) BOOL visible;
@property (nonatomic, retain) NSMutableDictionary* propertyList;

//==============================================================================
- (void) centerSubview: (UIView*) subView;
- (void) centerWithSize: (CGSize) newSize;
- (void) centerWithSize: (CGSize) newSize roundPosition: (BOOL) roundPosition;

//==============================================================================
/** Searches the view's subviews for a UIView of a specified class. */
- (UIView*) subviewOfClassType: (Class) classType;

/** Searches the view's subviews for a UIView of a specified class. */
- (UIView*) subviewOfClassType: (Class) classType searchRecursively: (BOOL) searchRecursively;

/** Searches the view's superviews for a UIView of a specified class. */
- (UIView*) superviewOfClassType: (Class) classType;

/** Returns the superview whose tag matches the specified value. */
- (UIView*) superviewWithTag: (NSInteger) tag;

//==============================================================================
- (UIImage*) snapshotImage;
- (UIImage*) snapshotImageClipped: (CGRect) rect;

@end


@interface UIView (Constraints)

/**
 @note - This methods return only the first constraint for the given attribute
 */

-(NSLayoutConstraint*) constraintWidth;
-(NSLayoutConstraint*) constraintHeight;

@end
