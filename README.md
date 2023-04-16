![cover](https://raw.githubusercontent.com/AlbertoLourenco/ALTIFFViewer/master/github-assets/cover.png)

A TIFF files viewer (with multi-pages) for iOS developed with `Objective-C`.

ALTIFFViewer was created for simplify our life when we need show a TIFF collection pages/images.. using NSTiffSpliter like auxiliar library.

Visit https://github.com/Sharrp/NSTiffSplitter to see NSTiffSpliter library. Thanks, Anton Sharrp Furin! :)

## How to use

So.. follow these steps:

- Copy files from Classes directory at sample project to yours;
- Import the ALTIFFViewer.h to your ViewController.h;

First you'll need to set a theme, using `ToolbarTheme`:

```objective-c

ToolbarTheme theme = ToolbarTheme_Light;

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
```

After that, mount the ALTIFFViewer object and call the function `config` passing the required params.

```objective-c
ALTIFFViewer* tiffViewer = [[ALTIFFViewer alloc] init];
[tiffViewer configWithFileData: fileData
                     documentTitle: @"This is about lions"
                    andLayoutTheme: theme];
[self presentViewController: tiffViewer animated: YES completion: nil];
```

## In action
![cover](https://raw.githubusercontent.com/AlbertoLourenco/ALTIFFViewer/master/github-assets/preview-1.gif)
