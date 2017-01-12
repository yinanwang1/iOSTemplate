//
//  YNPageControl.m
//  iOSTemplate
//
//  Created by ArthurWang on 17/1/12.
//  Copyright (c) 2017年 wang. All rights reserved.
//

#import "YNPageControl.h"

@interface YNPageControl ()

@property (nonatomic, strong) UIImage * activeImage;
@property (nonatomic, strong) UIImage * inactiveImage;

@end

@implementation YNPageControl

-(id) initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder]) {
        [self initImages];
    }
    
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self initImages];
}

#pragma mark - Public Methods

- (void)updateImages:(NSArray<UIImage *> *)imagesArr;
{
    if (2 > [imagesArr count]) { // must have 2 images
        return;
    }
    
    self.activeImage = [imagesArr objectAtIndex:0];
    self.inactiveImage = [imagesArr objectAtIndex:1];
}

- (void)initImages {
    self.activeImage = [UIImage imageNamed:@"ic_circel_solid_white"];
    self.inactiveImage = [UIImage imageNamed:@"ic_circle_hollow_white"];
}

- (NSArray *)subviews {
    NSMutableArray * array = [NSMutableArray arrayWithArray:[super subviews]];
    for(id obj in array) {
        if([obj isKindOfClass:[UIView class]]) {
            UIView * view = obj;
            if(view.tag == 100) {
                [array removeObject:view];
                
                break;
            }
        }
    }
    
    return array;
}

-(void) updateDots
{
    for (int i = 0; i < [self.subviews count]; i++)
    {
        UIImageView * dot = [self imageViewForSubview:  [self.subviews objectAtIndex: i]];
        if ([dot isKindOfClass:[UIImageView class]]
            && [dot respondsToSelector:@selector(setImage:)]) {
            if (i == self.currentPage) {
                dot.image = self.activeImage;
            }
            else {
                dot.image = self.inactiveImage;
            }
        }
    }
}

- (UIImageView *) imageViewForSubview: (UIView *) view
{
    UIImageView * dot = nil;
    if ([view isKindOfClass: [UIView class]])
    {
        for (UIView* subview in view.subviews)
        {
            if ([subview isKindOfClass:[UIImageView class]])
            {
                dot = (UIImageView *)subview;
                break;
            }
        }
        if (dot == nil)
        {
            dot = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, view.frame.size.width, view.frame.size.height)];
            [view addSubview:dot];
        }
    }
    else if ([view isKindOfClass:[UIImageView class]])
    {
        dot = (UIImageView *) view;
    } else {
        // DO nothing
    }
    
    return dot;
}

-(void) setCurrentPage:(NSInteger)page
{
    [super setCurrentPage:page];
    
    [self updateDots];
}

@end
