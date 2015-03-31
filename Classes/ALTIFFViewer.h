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

#define ALTiff_TopBarHeight 65.0f
#define ALTiff_BottomBarHeight 120.0f

typedef enum {
    ToolbarTheme_Dark    = 0,
    ToolbarTheme_Light   = 1
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

- (id)initWithFileData:(NSData*)fileData documentTitle:(NSString*)documentTitle andLayoutTheme:(int)theme;

@end

//-------------------------------------------------------------------
//  ScrollTap
//-------------------------------------------------------------------

@interface ScrollViewTap : UITapGestureRecognizer
@property (nonatomic, strong) UIScrollView* scroll;
@end
