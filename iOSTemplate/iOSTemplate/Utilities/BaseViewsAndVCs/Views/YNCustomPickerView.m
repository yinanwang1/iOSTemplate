//
//  YNCustomPickerView.m
//  iOSTemplate
//
//  Created by ArthurWang on 17/1/12.
//  Copyright (c) 2017年 wang. All rights reserved.
//

#import "YNCustomPickerView.h"

#import "YNMacrosUtils.h"
#import "YNAppDeviceHelper.h"
#import "Color+Image.h"

@interface YNCustomPickerView()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIToolbar *picketToolbar;
@property (nonatomic, strong) NSArray * dataArray;
@property (nonatomic, strong) YNCustomPickerViewBlock block;

@end

@implementation YNCustomPickerView

- (id)initWithDataArray:(NSArray *)array block:(YNCustomPickerViewBlock)block
{
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    if (self)
    {
        _block = [block copy];
        
        self.dataArray = array;
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor colorWithWhite:.0f alpha:0.3];
        
        if (SYSTEM_VERSION_GREATER_THAN(@"8.0")) {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(btnCancelClick)];
            [self addGestureRecognizer:tap];
        } else {
            UIView *view = [[UIView alloc] initWithFrame:self.frame];
            
            view.backgroundColor = [UIColor clearColor];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(btnCancelClick)];
            [view addGestureRecognizer:tap];
            
            [self addSubview:view];
        }
        
        self.picketToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 44)];
        self.picketToolbar.barStyle = UIBarStyleDefault;
        self.picketToolbar.translucent = NO;
        self.picketToolbar.backgroundColor = MAIN_COLOR;
        [self.picketToolbar setBackgroundImage:[UIImage imageWithColor:MAIN_COLOR] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
        [self.picketToolbar sizeToFit];
        
        self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT+44, SCREEN_WIDTH, 216)];
        self.pickerView.backgroundColor = [UIColor whiteColor];
        self.pickerView.showsSelectionIndicator = YES;
        self.pickerView.delegate = self;
        self.pickerView.dataSource = self;
        
        UIBarButtonItem* fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        fixedSpace.width = 10;
        
        UIBarButtonItem *btnCancel = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(btnCancelClick)];
        [btnCancel setTintColor:[UIColor grayColor]];
        
        UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(btnDoneClick)];
        [btnDone setTintColor:[UIColor grayColor]];
        
        UIBarButtonItem* fixedSpace2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        fixedSpace2.width = 10;
        
        NSArray *arrBarButtoniTems = [[NSArray alloc] initWithObjects:fixedSpace,btnCancel,flexible,btnDone,fixedSpace2, nil];
        [self.picketToolbar setItems:arrBarButtoniTems];
        
        [self addSubview:self.pickerView];
        [self addSubview:self.picketToolbar];
    }
    return self;
}

- (void)showInView:(UIView *)view defaultValue:(NSString *)defaultValue
{
    [view addSubview:self];
    int index = 0;
    if(defaultValue != nil)
    {
        for(int i=0; i<self.dataArray.count; i++)
        {
            NSString * str = [self.dataArray objectAtIndex:i];
            if([defaultValue isEqualToString:str])
            {
                index = i;
                break;
            }
        }
    }
    [self.pickerView selectRow:index inComponent:0 animated:NO];
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.pickerView setFrame:CGRectMake(0, SCREEN_HEIGHT - 216, SCREEN_WIDTH, 216)];
        [self.picketToolbar setFrame:CGRectMake(0, SCREEN_HEIGHT - 44 - 216, SCREEN_WIDTH, 44)];
    }];
}

- (void)hide
{
    [UIView animateWithDuration:0.5 animations:^{
        [self.pickerView setFrame:CGRectMake(0, SCREEN_HEIGHT+44, SCREEN_WIDTH, 216)];
        [self.picketToolbar setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 44)];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

+ (void)showWithStringArray:(NSArray *)array defaultValue:(NSString *)defaultValue toolBarColor:(UIColor *)color completeBlock:(YNCustomPickerViewBlock)block
{
    UIView * parentView = nil;
    UIWindow* keyWindow = [UIApplication sharedApplication].keyWindow;
    if (parentView == nil) parentView = keyWindow;
    if (parentView == nil) parentView = [UIApplication sharedApplication].windows[0];
    
    YNCustomPickerView * customView = [[YNCustomPickerView alloc]initWithDataArray:array block:block];
    if(color) {
        customView.picketToolbar.backgroundColor = color;
        [customView.picketToolbar setBackgroundImage:[UIImage imageWithColor:color] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    }
    [customView showInView:parentView defaultValue:defaultValue];
}

-(void)btnDoneClick
{
    if(self.dataArray != nil && self.dataArray.count > 0)
    {
        NSString * strSelectedValue = [self.dataArray objectAtIndex:[self.pickerView selectedRowInComponent:0]];
        NSInteger selectedIndex = [self.dataArray indexOfObject:strSelectedValue];
        
        _block((int)selectedIndex, YES);
    }
    
    [self hide];
}

- (void)btnCancelClick
{
    [self hide];
}

#pragma mark pickviewdelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.dataArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.dataArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    _block((int)row, NO);
}

@end
