  ALTIFFViewer 2.0 - iOS
---------------

![ALTIFFViewer v2.0](http://albertolourenco.com.br/altiffviewer.png)

A TIFF files viewer (with multi-pages).

ALTIFFViewer was created for simplify our life when we need show a TIFF collection pages/images.. using NSTiffSpliter like auxiliar library.

Visit https://github.com/Sharrp/NSTiffSplitter to see NSTiffSpliter library. Thanks, Anton Sharrp Furin! :)

So.. follow these steps:

- Copy files from Classes directory at sample project to yours;
- Import the ALTIFFViewer.h to your ViewController.h;
- Call ALTIFFViewer when you have file NSData, usgin this code:

ALTIFFViewer* tiffViewer = [[ALTIFFViewer alloc] initWithFileData:fileData documentTitle:@"This is about lions" andLayoutTheme:ToolbarTheme_Light];
    [tiffViewer setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [self presentViewController:tiffViewer animated:YES completion:nil];

Download de sample project and see how it works.

Thanks!
