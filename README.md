  ALTIFFViewer - iOS
---------------

![ALTIFFViewer v1.0](http://albertolourenco.com.br/altiffviewer.png)

A TIFF files viewer (with multi-pages).

ALTIFFViewer was created for simplify our life when we need show a TIFF collection pages/images using NSTiffSplit like auxiliar library. So.. follow these steps:

- Copy files into Classes directory on sample project;
- Import the ALTIFFViewer.h to your ViewController.h;
- Call ALTIFFViewer when you have file NSData, usgin this code:

ALTIFFViewer* tiffViewer = [[ALTIFFViewer alloc] initWithFileData:fileData documentTitle:@"This is about lions" andLayoutTheme:ToolbarTheme_Light];
    [tiffViewer setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [self presentViewController:tiffViewer animated:YES completion:nil];

Download de sample project and see how it works.

Thanks!
