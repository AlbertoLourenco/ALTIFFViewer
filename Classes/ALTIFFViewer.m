//
//  ALTIFFViewer.m
//  ALTIFFViewer
//
//  Created by Alberto Lourenco on 31/03/15.
//  Copyright (c) 2015 Alberto Lourenço. All rights reserved.
//

#import "ALTIFFViewer.h"

@interface ALTIFFViewer ()
@end

@implementation ALTIFFViewer

@synthesize splitter;

//----------------------------------------------------------------------------------------------------------------------------------------------
//  UIViewController methods
//----------------------------------------------------------------------------------------------------------------------------------------------

- (id)initWithFileData:(NSData*)fileData documentTitle:(NSString*)documentTitle andLayoutTheme:(int)theme{
    
    self.splitter = [[NSTiffSplitter alloc] initWithData:fileData usingMapping:NO];
    
    viewTheme = theme;
    if (theme == ToolbarTheme_Light) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        
        vwBGColor                   = [UIColor colorWithWhite:0.914 alpha:0.85];
        vwPageIndicatorBGColor      = [UIColor colorWithWhite:0.090 alpha:0.900];
        
        lblPageIndicatorTextColor   = [UIColor whiteColor];
        lblTextColor                = [UIColor darkGrayColor];
        lblTitleColor               = [UIColor colorWithWhite:0.164 alpha:1.000];
        btnTextColor                = [UIColor colorWithRed:0.000 green:0.491 blue:1.000 alpha:1.000];
        
        sliderMaximumColor          = [UIColor colorWithRed:0.678 green:0.675 blue:0.682 alpha:1.000];
        sliderMinimumColor          = [UIColor colorWithRed:0.002 green:0.227 blue:1.000 alpha:1.000];
    }else
        if (theme == ToolbarTheme_Dark) {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
            
            vwBGColor                   = [UIColor colorWithWhite:0.120 alpha:0.95];
            vwPageIndicatorBGColor      = [UIColor colorWithWhite:0.865 alpha:0.900];
            
            lblPageIndicatorTextColor   = [UIColor colorWithWhite:0.221 alpha:1.000];
            lblTextColor                = [UIColor colorWithWhite:0.873 alpha:1.000];
            lblTitleColor               = [UIColor whiteColor];
            btnTextColor                = [UIColor colorWithRed:0.000 green:0.584 blue:1.000 alpha:1.000];
            
            sliderMaximumColor          = [UIColor colorWithRed:0.497 green:0.495 blue:0.500 alpha:1.000];
            sliderMinimumColor          = [UIColor colorWithRed:0.000 green:0.584 blue:1.000 alpha:1.000];
        }
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    //-----------------------------------------
    //  MainScroll - scroll to slide
    //-----------------------------------------
    self.mainScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
    [self.mainScroll setDelegate:self];
    [self.mainScroll setPagingEnabled:YES];
    [self.mainScroll setShowsVerticalScrollIndicator:NO];
    [self.mainScroll setShowsHorizontalScrollIndicator:NO];
    [self.view addSubview:self.mainScroll];
    
    //-----------------------------------------
    //  TopBar - create / config
    //-----------------------------------------
    self.vwTopBar = [[UIView alloc] initWithFrame:CGRectMake(0.0f, -ALTiff_TopBarHeight, [[UIScreen mainScreen] bounds].size.width, ALTiff_TopBarHeight)];
    [self.vwTopBar setBackgroundColor:vwBGColor];
    [self.vwTopBar setAlpha:0.0];
    [self.view addSubview:self.vwTopBar];
    
    //-----------------------------------------
    //  UIButton - close viewer
    //-----------------------------------------
    self.btnCloseViewer = [[UIButton alloc] init];
    [self.btnCloseViewer setFrame:CGRectMake(self.vwTopBar.frame.size.width - 60.0f, self.vwTopBar.frame.size.height - 40.0f, 50.0f, 30.0f)];
    [self.btnCloseViewer setTitle:@"Close" forState:UIControlStateNormal];
    [self.btnCloseViewer setTitleColor:btnTextColor forState:UIControlStateNormal];
    [self.btnCloseViewer addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    
    [self.vwTopBar addSubview:self.btnCloseViewer];
    
    //-----------------------------------------
    //  BottomBar - create / config
    //-----------------------------------------
    self.vwBottomBar = [[UIView alloc] initWithFrame:CGRectMake(0.0f, [[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width, ALTiff_BottomBarHeight)];
    [self.vwBottomBar setBackgroundColor:vwBGColor];
    [self.vwBottomBar setAlpha:0.0];
    [self.view addSubview:self.vwBottomBar];
    
    //-----------------------------------------
    //  UISlider - to change page
    //-----------------------------------------
    CGRect sliderFrame = self.vwBottomBar.frame;
    sliderFrame.size.width = sliderFrame.size.width - 40.0f;
    sliderFrame.origin.x = 20.0f;
    sliderFrame.origin.y = self.vwBottomBar.frame.size.height - 107.5f;
    
    self.pageSlider = [[UISlider alloc] init];
    [self.pageSlider setFrame:sliderFrame];
    [self.pageSlider setTranslatesAutoresizingMaskIntoConstraints:YES];
    self.pageSlider.minimumValue = 1;
    self.pageSlider.maximumValue = 1;
    self.pageSlider.continuous = YES;
    [self.pageSlider setMinimumTrackTintColor:sliderMinimumColor];
    [self.pageSlider setMaximumTrackTintColor:sliderMaximumColor];
    [self.vwBottomBar addSubview:self.pageSlider];
    
    [self.pageSlider addTarget:self action:@selector(sliderValue:) forControlEvents:UIControlEventValueChanged];
    [self.pageSlider addTarget:self action:@selector(showPageIndicator:) forControlEvents:UIControlEventTouchDown];
    [self.pageSlider addTarget:self action:@selector(hidePageIndicator:) forControlEvents:(UIControlEventTouchUpInside | UIControlEventTouchUpOutside)];
    
    //-----------------------------------------
    //  UILabel - page indicator
    //-----------------------------------------
    self.pageLabel = [[UILabel alloc] init];
    [self.pageLabel setFrame:CGRectMake(sliderFrame.origin.x + 50, self.vwBottomBar.frame.size.height - 35, sliderFrame.size.width - 100, 30.0f)];
    [self.pageLabel setText:[NSString stringWithFormat:@"Page %i of %i", page+1, totalPages]];
    [self.pageLabel setTextAlignment:NSTextAlignmentCenter];
    [self.pageLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [self.pageLabel setTextColor:lblTextColor];
    [self.vwBottomBar addSubview:self.pageLabel];
    
    //-----------------------------------------
    //  UILabel - document title
    //-----------------------------------------
    self.documentTitle = [[UILabel alloc] init];
    [self.documentTitle setFrame:CGRectMake(sliderFrame.origin.x + 50, self.vwBottomBar.frame.size.height - 100.0f, sliderFrame.size.width - 100, 30.0f)];
    [self.documentTitle setText:documentTitle];
    [self.documentTitle setTextAlignment:NSTextAlignmentCenter];
    [self.documentTitle setFont:[UIFont systemFontOfSize:20.0f]];
    [self.documentTitle setTextColor:lblTitleColor];
    [self.vwBottomBar addSubview:self.documentTitle];
    
    //-----------------------------------------
    //  UIButton - rotate image left
    //-----------------------------------------
    UIImage* img = [self ipMaskedImageNamed:@"rotate" color:btnTextColor];
    UIImage* flippedImage = [UIImage imageWithCGImage:img.CGImage
                                                scale:img.scale
                                          orientation:UIImageOrientationUpMirrored];
    
    self.btnRotateLeft = [[UIButton alloc] init];
    [self.btnRotateLeft setFrame:CGRectMake(10.0f, self.vwBottomBar.frame.size.height - 110.0f, 50.0f, 50.0f)];
    [self.btnRotateLeft setImage:flippedImage forState:UIControlStateNormal];
    [self.btnRotateLeft setImage:flippedImage forState:UIControlStateHighlighted];
    [self.btnRotateLeft addTarget:self action:@selector(rotateLeft) forControlEvents:UIControlEventTouchUpInside];
    
    [self.vwBottomBar addSubview:self.btnRotateLeft];
    
    //-----------------------------------------
    //  UIButton - rotate image left
    //-----------------------------------------
    self.btnRotateRight = [[UIButton alloc] init];
    [self.btnRotateRight setFrame:CGRectMake(self.vwBottomBar.frame.size.width - 60.0f, self.vwBottomBar.frame.size.height - 110.0f, 50.0f, 50.0f)];
    [self.btnRotateRight setImage:img forState:UIControlStateNormal];
    [self.btnRotateRight setImage:img forState:UIControlStateHighlighted];
    [self.btnRotateRight addTarget:self action:@selector(rotateRight) forControlEvents:UIControlEventTouchUpInside];
    
    [self.vwBottomBar addSubview:self.btnRotateRight];
    
    //-----------------------------------------
    //  UILabel - slider indicator
    //-----------------------------------------
    self.pageNumberIndicator = [[UIView alloc] init];
    [self.pageNumberIndicator setFrame:CGRectMake(0.0f, self.vwBottomBar.frame.size.height - 95.0f, 100.0f, 30.0f)];
    [self.pageNumberIndicator setTranslatesAutoresizingMaskIntoConstraints:YES];
    [self.pageNumberIndicator setBackgroundColor:vwPageIndicatorBGColor];
    [self.pageNumberIndicator.layer setMasksToBounds:YES];
    [self.pageNumberIndicator.layer setCornerRadius:3.0f];
    [self.pageNumberIndicator setAlpha:0.0f];
    
    self.pageNumberLabel = [[UILabel alloc] init];
    [self.pageNumberLabel setFrame:CGRectMake(0.0f, 0.0f, 90.0f, 30.0f)];
    [self.pageNumberLabel setCenter:CGPointMake(45.0f, 15.0f)];
    [self.pageNumberLabel setTranslatesAutoresizingMaskIntoConstraints:YES];
    [self.pageNumberLabel setTextAlignment:NSTextAlignmentCenter];
    [self.pageNumberLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [self.pageNumberLabel setTextColor:lblPageIndicatorTextColor];
    [self.pageNumberLabel setText:[NSString stringWithFormat:@"%i / %i", page+1, totalPages]];
    
    [self.pageNumberIndicator addSubview:self.pageNumberLabel];
    [self.vwBottomBar addSubview:self.pageNumberIndicator];
    
    //-----------------------------------------
    //  UILabel - page indicator
    //-----------------------------------------
    self.vwPageNumber = [[UIView alloc] init];
    [self.vwPageNumber setFrame:CGRectMake((self.view.frame.size.width / 2) - 50.0f, self.view.frame.size.height, 100.0f, 30.0f)];
    [self.vwPageNumber setTranslatesAutoresizingMaskIntoConstraints:YES];
    [self.vwPageNumber setBackgroundColor:vwBGColor];
    [self.vwPageNumber.layer setMasksToBounds:YES];
    [self.vwPageNumber.layer setCornerRadius:3.0f];
    [self.vwPageNumber setAlpha:0.0f];
    
    self.lblPageNumber = [[UILabel alloc] init];
    [self.lblPageNumber setFrame:CGRectMake(0.0f, 0.0f, 100.0f, 30.0f)];
    [self.lblPageNumber setCenter:CGPointMake(50.0f, 15.0f)];
    [self.lblPageNumber setTranslatesAutoresizingMaskIntoConstraints:YES];
    [self.lblPageNumber setTextAlignment:NSTextAlignmentCenter];
    [self.lblPageNumber setFont:[UIFont systemFontOfSize:14.0f]];
    [self.lblPageNumber setTextColor:lblTextColor];
    [self.lblPageNumber setText:[NSString stringWithFormat:@"%i / %i", page+1, totalPages]];
    
    [self.vwPageNumber addSubview:self.lblPageNumber];
    [self.view addSubview:self.vwPageNumber];
    
    return [self init];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width / 2.0f, [[UIScreen mainScreen] bounds].size.height / 2.0f, 20.0f, 20.0f)];
    [self.indicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [self.indicator startAnimating];
    [self.view addSubview:self.indicator];
}

- (void)viewDidAppear:(BOOL)animated{
    
    totalPages = [self.splitter countOfImages];
    
    if (totalPages == 0) {
        [self close];
    }
    
    [self.pageLabel setText:[NSString stringWithFormat:@"Page %i of %i", page+1, totalPages]];
    [self.lblPageNumber setText:[NSString stringWithFormat:@"%i / %i", page+1, totalPages]];
    self.pageSlider.maximumValue = totalPages;
    
    for (int i = 0; i < [self.splitter countOfImages]; i++){
        
        UIImage *image = [[UIImage alloc] initWithData:[splitter dataForImage:i]];
        self.imageView = [[UIImageView alloc] initWithImage:image];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.imageView.clipsToBounds = YES;
        self.imageView.tag = i;
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(
                                                                                  [[UIScreen mainScreen] bounds].size.width * i,
                                                                                  0,
                                                                                  [[UIScreen mainScreen] bounds].size.width,
                                                                                  [[UIScreen mainScreen] bounds].size.height)];
        scrollView.delegate = self;
        scrollView.maximumZoomScale = 3.0f;
        
        self.imageView.frame = scrollView.bounds;
        
        [scrollView addSubview:self.imageView];
        
        ScrollViewTap* doubleTapGesture = [[ScrollViewTap alloc] initWithTarget:self action:@selector(resizeScrollView:)];
        doubleTapGesture.scroll = scrollView;
        [doubleTapGesture setNumberOfTapsRequired:2];
        [scrollView addGestureRecognizer:doubleTapGesture];
        
        if (i == 0) {
            scrollActual = scrollView;
        }
        
        [self.mainScroll addSubview:scrollView];
    }
    
    [self.mainScroll setContentSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width * [self.splitter countOfImages], [[UIScreen mainScreen] bounds].size.height)];
    
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(animateBars)];
    [tapGesture setNumberOfTapsRequired:1];
    [tapGesture setDelaysTouchesEnded:YES];
    [self.mainScroll addGestureRecognizer:tapGesture];
    
    [self.indicator stopAnimating];
    [self.indicator setHidden:YES];
    
    [self showBars];
}

- (void)viewDidDisappear:(BOOL)animated{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
}

//----------------------------------------------------------------------------------------------------------------------------------------------
//  UIScrollViewDelegate methods
//----------------------------------------------------------------------------------------------------------------------------------------------

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    UIImageView* img = [[scrollView subviews] objectAtIndex:0];
    
    CGFloat radians = atan2f(img.transform.b, img.transform.a);
    
    if (radians < 0) {
        img.transform = CGAffineTransformMakeRotation(M_PI * 2);
    }
    
    return img;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    [scrollActual setZoomScale:1.0f animated:YES];
    
    scrollActual = [self.mainScroll.subviews objectAtIndex:page];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.pageSlider setValue:page+1 animated:YES];
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = self.mainScroll.frame.size.width;
    int pageNumber = floor((self.mainScroll.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    page = pageNumber;
    
    [self.pageLabel setText:[NSString stringWithFormat:@"Page %i of %i", page+1, totalPages]];
    [self.lblPageNumber setText:[NSString stringWithFormat:@"%i / %i", page+1, totalPages]];
}

//----------------------------------------------------------------------------------------------------------------------------------------------
//  Custom methods
//----------------------------------------------------------------------------------------------------------------------------------------------

//------------------------------
//  Pagination
//------------------------------

- (void)sliderValue:(id)sender{
    
    self.pageSlider = (UISlider*)sender;
    float x = [self xPositionFromSliderValue:self.pageSlider];
    
    float positionX = 0.0f;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        positionX = (int)x * 0.72f;
    }else{
        positionX = (int)x * 0.88;
    }
    
    [self.pageNumberIndicator setFrame:CGRectMake(positionX,
                                                  self.vwBottomBar.frame.size.height - 100.0f,
                                                  90.0f,
                                                  30.0f)];
    
    [self.pageNumberLabel setText:[NSString stringWithFormat:@"%i / %i", (int)self.pageSlider.value, totalPages]];
    [self.lblPageNumber setText:[NSString stringWithFormat:@"%i / %i", (int)self.pageSlider.value, totalPages]];
}

- (void)showPageIndicator:(id)sender{
    
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^(void){
                         [self.pageNumberIndicator setAlpha:1.0];
                     }
                     completion:nil];
}

- (void)hidePageIndicator:(id)sender{
    [UIView animateWithDuration:0.3 animations:^{
        [self.pageSlider setValue:(int)self.pageSlider.value animated:YES];
    }];
    
    [UIView animateWithDuration:0.3f
                          delay:0.8f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^(void){
                         [self.pageNumberIndicator setAlpha:0.0];
                     }
                     completion:nil];
    
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.origin.x = frame.size.width * ((int)self.pageSlider.value - 1);
    frame.origin.y = 0;
    [self.mainScroll scrollRectToVisible:frame animated:YES];
    
    scrollActual = [self.mainScroll.subviews objectAtIndex:(int)self.pageSlider.value - 1];
}

- (float)xPositionFromSliderValue:(UISlider *)aSlider;{
    float sliderRange = aSlider.frame.size.width - aSlider.currentThumbImage.size.width;
    float sliderOrigin = aSlider.frame.origin.x + (aSlider.currentThumbImage.size.width / 2.0);
    
    float sliderValueToPixels = (((aSlider.value-aSlider.minimumValue)/(aSlider.maximumValue - aSlider.minimumValue) * sliderRange) + sliderOrigin);
    return sliderValueToPixels;
}

//------------------------------
//  Rotate image
//------------------------------

- (UIImage *)ipMaskedImageNamed:(NSString *)name color:(UIColor *)color{
    UIImage *image = [UIImage imageNamed:name];
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, image.scale);
    CGContextRef c = UIGraphicsGetCurrentContext();
    [image drawInRect:rect];
    CGContextSetFillColorWithColor(c, [color CGColor]);
    CGContextSetBlendMode(c, kCGBlendModeSourceAtop);
    CGContextFillRect(c, rect);
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}

- (void)rotateRight{
    
    [scrollActual setZoomScale:1.0 animated:YES];
    
    UIImageView* img = [[scrollActual subviews] objectAtIndex:0];
    if (img.tag == page) {
        
        [UIView animateWithDuration:0.3
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^(void){
                             img.alpha = 0.0;
                         }
                         completion:^(BOOL finished){
                             
                             UIView* rotatedViewBox = [[UIView alloc] initWithFrame: CGRectMake(0, 0, img.image.size.width, img.image.size.height)];
                             float angleRadians = 90 * ((float)M_PI / 180.0f);
                             CGAffineTransform t = CGAffineTransformMakeRotation(angleRadians);
                             rotatedViewBox.transform = t;
                             CGSize rotatedSize = rotatedViewBox.frame.size;
                             
                             UIGraphicsBeginImageContext(rotatedSize);
                             CGContextRef bitmap = UIGraphicsGetCurrentContext();
                             CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
                             CGContextRotateCTM(bitmap, angleRadians);
                             
                             CGContextScaleCTM(bitmap, 1.0, -1.0);
                             CGContextDrawImage(bitmap, CGRectMake(-img.image.size.width / 2, -img.image.size.height / 2, img.image.size.width, img.image.size.height), [img.image CGImage]);
                             
                             UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
                             UIGraphicsEndImageContext();
                             
                             img.image = newImage;
                             
                             [UIView animateWithDuration:0.3
                                                   delay:0.0
                                                 options:UIViewAnimationOptionCurveEaseIn
                                              animations:^(void){
                                                  img.alpha = 1.0;
                                              }
                                              completion:nil];
                         }];
    }
}

- (void)rotateLeft{
    [scrollActual setZoomScale:1.0 animated:YES];
    
    UIImageView* img = [[scrollActual subviews] objectAtIndex:0];
    if (img.tag == page) {
        
        [UIView animateWithDuration:0.3
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^(void){
                             img.alpha = 0.0;
                         }
                         completion:^(BOOL finished){
                             
                             UIView* rotatedViewBox = [[UIView alloc] initWithFrame: CGRectMake(0, 0, img.image.size.width, img.image.size.height)];
                             float angleRadians = -90 * ((float)M_PI / 180.0f);
                             CGAffineTransform t = CGAffineTransformMakeRotation(angleRadians);
                             rotatedViewBox.transform = t;
                             CGSize rotatedSize = rotatedViewBox.frame.size;
                             
                             UIGraphicsBeginImageContext(rotatedSize);
                             CGContextRef bitmap = UIGraphicsGetCurrentContext();
                             CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
                             CGContextRotateCTM(bitmap, angleRadians);
                             
                             CGContextScaleCTM(bitmap, 1.0, -1.0);
                             CGContextDrawImage(bitmap, CGRectMake(-img.image.size.width / 2, -img.image.size.height / 2, img.image.size.width, img.image.size.height), [img.image CGImage]);
                             
                             UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
                             UIGraphicsEndImageContext();
                             
                             img.image = newImage;
                             
                             [UIView animateWithDuration:0.3
                                                   delay:0.0
                                                 options:UIViewAnimationOptionCurveEaseIn
                                              animations:^(void){
                                                  img.alpha = 1.0;
                                              }
                                              completion:nil];
                         }];
    }
}

//------------------------------
//  Others
//------------------------------

- (void)close{
    [self hideBars];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)resizeScrollView:(UITapGestureRecognizer *)tapRecognizer{
    
    ScrollViewTap *tap = (ScrollViewTap *)tapRecognizer;
    
    if(tap.scroll.zoomScale > 1.0f){
        [tap.scroll setZoomScale:1.0f animated:YES];
    }else{
        [tap.scroll setZoomScale:2.5f animated:YES];
    }
}

- (void)animateBars{
    if (toolBarsIsHidden) {
        [self showBars];
    }else{
        [self hideBars];
    }
}

- (void)hideBars{
    if (!toolBarsIsHidden) {
        
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        
        [UIView animateWithDuration:0.3
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^(void){
                             [self.vwTopBar setAlpha:0.0];
                             [self.vwBottomBar setAlpha:0.0];
                             
                             [self.vwTopBar setFrame:CGRectMake(0.0f, -ALTiff_TopBarHeight, [[UIScreen mainScreen] bounds].size.width, ALTiff_TopBarHeight)];
                             [self.vwBottomBar setFrame:CGRectMake(0.0f, [[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width, ALTiff_BottomBarHeight)];
                         }
                         completion:^(BOOL finished){
                             toolBarsIsHidden = TRUE;
                             [self showPageIndicator];
                         }];
    }
}

- (void)showBars{
    
    [self hidePageIndicator];
    [UIView animateWithDuration:0.3f
                          delay:0.5f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^(void){
                         [self.vwTopBar setAlpha:1.0f];
                         [self.vwBottomBar setAlpha:1.0f];
                         
                         [self.vwTopBar setFrame:CGRectMake(0.0f, 0.0f, [[UIScreen mainScreen] bounds].size.width, ALTiff_TopBarHeight)];
                         [self.vwBottomBar setFrame:CGRectMake(0.0f, [[UIScreen mainScreen] bounds].size.height - ALTiff_BottomBarHeight, [[UIScreen mainScreen] bounds].size.width, ALTiff_BottomBarHeight)];
                     }
                     completion:^(BOOL finished){
                         toolBarsIsHidden = FALSE;
                         
                         if (viewTheme == ToolbarTheme_Dark) {
                             [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
                         }
                         
                     }];
}

- (void)showPageIndicator{
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^(void){
                         [self.vwPageNumber setAlpha:1.0];
                         [self.vwPageNumber setFrame:CGRectMake((self.view.frame.size.width / 2) - 50.0f, self.view.frame.size.height - 55.0f, 100.0f, 30.0f)];
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:0.3f
                                               delay:0.0f
                                             options:UIViewAnimationOptionCurveEaseOut
                                          animations:^(void){
                                              [self.vwPageNumber setFrame:CGRectMake((self.view.frame.size.width / 2) - 50.0f, self.view.frame.size.height - 40.0f, 100.0f, 30.0f)];
                                          }
                                          completion:^(BOOL finished){
                                              [UIView animateWithDuration:0.3f
                                                                    delay:0.0f
                                                                  options:UIViewAnimationOptionCurveEaseOut
                                                               animations:^(void){
                                                                   [self.vwPageNumber setFrame:CGRectMake((self.view.frame.size.width / 2) - 50.0f, self.view.frame.size.height - 45.0f, 100.0f, 30.0f)];
                                                               }
                                                               completion:nil];
                                          }];
                     }];
}

- (void)hidePageIndicator{
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^(void){
                         [self.vwPageNumber setFrame:CGRectMake((self.view.frame.size.width / 2) - 50.0f, self.view.frame.size.height - 55.0f, 100.0f, 30.0f)];
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:0.2f
                                               delay:0.0f
                                             options:UIViewAnimationOptionCurveEaseIn
                                          animations:^(void){
                                              [self.vwPageNumber setAlpha:0.0];
                                              [self.vwPageNumber setFrame:CGRectMake((self.view.frame.size.width / 2) - 50.0f, self.view.frame.size.height, 100.0f, 30.0f)];
                                          }
                                          completion:nil];
                     }];
}

@end

//----------------------------------------------------------------------------------------------------------------------------------------------
//  ScrollTap
//----------------------------------------------------------------------------------------------------------------------------------------------

@implementation ScrollViewTap
@synthesize scroll;
@end
