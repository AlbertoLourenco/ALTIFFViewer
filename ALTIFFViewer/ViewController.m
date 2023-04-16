//
//  ViewController.m
//  ALTIFFViewer
//
//  Created by Alberto Lourenco on 31/03/15.
//  Copyright (c) 2015 Alberto Lourenço. All rights reserved.
//

#import "ViewController.h"

#import "ALTIFFViewer.h"

@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad{
    [super viewDidLoad];
}

- (IBAction)showTiffFile:(id)sender{
    
    NSString* filePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"example.tiff"];
    NSData* fileData = [NSData dataWithContentsOfFile:filePath];
    
    //-----------------------------------------------------
    //  Toolbar themes
    //-----------------------------------------------------
    //
    //  ToolbarTheme_Hidden
    //
    //  ToolbarTheme_Light
    //  ToolbarTheme_LightWithoutSlider
    //  ToolbarTheme_LightWithoutRotateOption
    //  ToolbarTheme_LightWithoutSliderAndRotateOption
    //
    //  ToolbarTheme_Dark
    //  ToolbarTheme_DarkWithoutSlider
    //  ToolbarTheme_DarkWithoutRotateOption
    //  ToolbarTheme_DarkWithoutSliderAndRotateOption
    //
    //-----------------------------------------------------
    
    ToolbarTheme theme = ToolbarTheme_Light;
    UIButton* button = (UIButton*)sender;
    theme = (int)button.tag;
    
    ALTIFFViewer* tiffViewer = [[ALTIFFViewer alloc] init];
    [tiffViewer configWithFileData: fileData documentTitle: @"This is about lions" andLayoutTheme: theme];
    [self presentViewController: tiffViewer animated: YES completion: nil];
}

@end
