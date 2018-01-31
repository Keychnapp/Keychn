//
//  UIImage+KCImage.h
//  Keychn
//
//  Created by Keychn Experience SL on 06/01/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (KCImage)

/**
 @abstract This method will resize the image with the new size
 @param image and new size
 @return resized image
*/
+ (UIImage *)resizeImage:(UIImage *)image scaledToSize:(CGSize)newSize;

/**
 @abstract This method will take the spanshot/screenshot of the view and will retun it as an image
 @param View fo Spanshot
 @return Spanshot image
 */
+ (UIImage *)takeSnapshotOfView:(UIView *)view;

/**
 @abstract This method will blur the passed image with Gaussian effect
 @param Image and View
 @return Blurred Image
 */
+ (UIImage *)blurWithCoreImage:(UIImage *)sourceImage withView:(UIView*)view;

/**
 @abstract This method will compress the image upto 250 KB
 @param Original Image
 @return Compressed Image
 */
+(UIImage*)compressImage:(UIImage*)originalImage;

+(NSData*)compressImageInBytes:(UIImage*)originalImage;

@end
