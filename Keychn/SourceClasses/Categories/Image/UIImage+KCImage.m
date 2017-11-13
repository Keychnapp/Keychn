//
//  UIImage+KCImage.m
//  Keychn
//
//  Created by Keychn Experience SL on 06/01/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import "UIImage+KCImage.h"

@implementation UIImage (KCImage)

+ (UIImage *)resizeImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //Resize image with a new size only if new size is smaller than previous one
    
    if(image.size.width <= newSize.width) {
        newSize.width   = image.size.width;
    }
    float oldWidth    = image.size.width;
    float scaleFactor = image.size.height / oldWidth;
    newSize.height    = newSize.width * scaleFactor;
    
    UIGraphicsBeginImageContextWithOptions(newSize, YES, 1.0);
    
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (UIImage *)takeSnapshotOfView:(UIView *)view {
    //Take spanshot of the view
    UIGraphicsBeginImageContext(CGSizeMake(view.frame.size.width, view.frame.size.height));
    [view drawViewHierarchyInRect:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height) afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)blurWithCoreImage:(UIImage *)sourceImage withView:(UIView*)view {
   //Get blurred image view
    CIImage *inputImage = [CIImage imageWithCGImage:sourceImage.CGImage];
    
    // Apply Affine-Clamp filter to stretch the image so that it does not
    // look shrunken when gaussian blur is applied
    CGAffineTransform transform = CGAffineTransformIdentity;
    CIFilter *clampFilter = [CIFilter filterWithName:@"CIAffineClamp"];
    [clampFilter setValue:inputImage forKey:@"inputImage"];
    [clampFilter setValue:[NSValue valueWithBytes:&transform objCType:@encode(CGAffineTransform)] forKey:@"inputTransform"];
    
    // Apply gaussian blur filter with radius of 30
    CIFilter *gaussianBlurFilter = [CIFilter filterWithName: @"CIGaussianBlur"];
    [gaussianBlurFilter setValue:clampFilter.outputImage forKey: @"inputImage"];
    [gaussianBlurFilter setValue:@2 forKey:@"inputRadius"];
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgImage = [context createCGImage:gaussianBlurFilter.outputImage fromRect:[inputImage extent]];
    
    // Set up output context.
    UIGraphicsBeginImageContext(view.frame.size);
    CGContextRef outputContext = UIGraphicsGetCurrentContext();
    
    // Invert image coordinates
    CGContextScaleCTM(outputContext, 1.0, -1.0);
    CGContextTranslateCTM(outputContext, 0, -view.frame.size.height);
    
    // Draw base image.
    CGContextDrawImage(outputContext, view.frame, cgImage);
    
    // Apply white tint
    CGContextSaveGState(outputContext);
    CGContextSetFillColorWithColor(outputContext, [UIColor colorWithWhite:1 alpha:0.2].CGColor);
    CGContextFillRect(outputContext, view.frame);
    CGContextRestoreGState(outputContext);
    
    // Output image is ready.
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return outputImage;
}

+(UIImage*)compressImage:(UIImage*)originalImage {
    // Compress the image for upto 250 KB
    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.1f;
    int maxFileSize = 256000; // in bytes
    
    NSData *imageData = UIImageJPEGRepresentation(originalImage, compression);
    UIImage *compressedImage;
    if(DEBUGGING) NSLog(@"Image data length in KB%@", [NSNumber numberWithInteger:[imageData length]/1024]);
    while ([imageData length] > maxFileSize && compression > maxCompression) {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(originalImage, compression);
        if(DEBUGGING) NSLog(@"Image data length in KB%@", [NSNumber numberWithInteger:[imageData length]/1024]);
    }
    
    compressedImage = [UIImage imageWithData:imageData];
    return compressedImage;
}

+(NSData*)compressImageInBytes:(UIImage*)originalImage {
    // Compress the image for upto 250 KB
    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.1f;
    int maxFileSize = 256000; // in bytes
    
    NSData *imageData = UIImageJPEGRepresentation(originalImage, compression);
    while ([imageData length] > maxFileSize && compression > maxCompression) {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(originalImage, compression);
        if(DEBUGGING) NSLog(@"Image data length in KB%@", [NSNumber numberWithInteger:[imageData length]/1024]);
    }
    return imageData;
}

@end
