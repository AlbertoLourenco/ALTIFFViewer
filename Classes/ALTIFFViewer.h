//
//  ALTIFFViewer.h
//  ALTIFFViewer
//
//  Created by Alberto Lourenco on 31/03/15.
//  Copyright (c) 2015 Alberto Lourenço. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "NSTiffSplitter.h"

#define ALTiff_TopBarHeight 95.0f
#define ALTiff_BottomBarHeight 140.0f

typedef enum {
    
    ToolbarTheme_Hidden                                 = 0,
    
    ToolbarTheme_Light                                  = 1,
    ToolbarTheme_LightWithoutSlider                     = 2,
    ToolbarTheme_LightWithoutRotateOption               = 3,
    ToolbarTheme_LightWithoutSliderAndRotateOption      = 4,
    
    ToolbarTheme_Dark                                   = 5,
    ToolbarTheme_DarkWithoutSlider                      = 6,
    ToolbarTheme_DarkWithoutRotateOption                = 7,
    ToolbarTheme_DarkWithoutSliderAndRotateOption       = 8
    
}ToolbarTheme;

//-------------------------------------------------------------------
//  ALTiffViewer
//-------------------------------------------------------------------

@interface ALTIFFViewer : UIViewController <UIScrollViewDelegate>{
    
    ToolbarTheme viewTheme;
    
    UIColor* vwBGColor;
    UIColor* vwPageIndicatorBGColor;
    UIColor* lblPageIndicatorTextColor;
    UIColor* lblTitleColor;
    UIColor* lblTextColor;
    UIColor* btnTextColor;
    UIColor* sliderMinimumColor;
    UIColor* sliderMaximumColor;
    
    int page;
    int totalPages;
    BOOL toolBarsIsHidden;
    UIScrollView* scrollActual;
}

@property (nonatomic, strong) NSTiffSplitter *splitter;

@property (nonatomic, strong) UIView *vwTopBar;
@property (nonatomic, strong) UIView *vwBottomBar;

@property (nonatomic, strong) UIScrollView *mainScroll;
@property (nonatomic, strong) UIActivityIndicatorView *indicator;

@property (nonatomic, strong) UILabel* documentTitle;

@property (nonatomic, strong) UIView* vwPageNumber;
@property (nonatomic, strong) UILabel* lblPageNumber;

@property (nonatomic, strong) UIView* pageNumberIndicator;
@property (nonatomic, strong) UILabel* pageNumberLabel;
@property (nonatomic, strong) UILabel* pageLabel;
@property (nonatomic, strong) UISlider* pageSlider;

@property (nonatomic, strong) UIButton* btnCloseViewer;
@property (nonatomic, strong) UIButton* btnRotateLeft;
@property (nonatomic, strong) UIButton* btnRotateRight;

@property (nonatomic, strong) UIImageView *imageView;

- (void)configWithFileData:(NSData*)fileData documentTitle:(NSString*)documentTitle andLayoutTheme:(int)theme;

@end

//-------------------------------------------------------------------
//  ScrollTap
//-------------------------------------------------------------------

@interface ScrollViewTap : UITapGestureRecognizer
@property (nonatomic, strong) UIScrollView* scroll;
@end
