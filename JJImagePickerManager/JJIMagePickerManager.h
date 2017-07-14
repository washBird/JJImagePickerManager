//
//  JJIMagePickerManager.h
//  JJImagePickerManager
//
//  Created by zoujie on 2017/7/14.
//  Copyright © 2017年 zoujie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol JJIMagePickerManagerDelegate <NSObject>
@optional
- (void)photoSelectDidSelectSheetIndex:(NSInteger )index;
- (void)photoSelectCompleteWithOriginImage:(UIImage *)originImage editedImage:(UIImage *)editedImage;
- (void)photoSelectCancle;
@end

@interface JJIMagePickerManager : NSObject

@property (nonatomic, weak) id<JJIMagePickerManagerDelegate> delegate;
//源控制器,不能为空
@property (nonatomic, weak) UIViewController *fromViewController;
//是否允许编辑(方形图)
@property (nonatomic, assign) BOOL allowEditing;
//代理的调用是否在返回成功后调用
@property (nonatomic, assign) BOOL needComplete;

+ (instancetype )imagePickerManagerFromController:( UIViewController *)fromController;

//弹出框选择拍照，相册，取消
- (void)alertSelectActionSheet;
//直接进入相机拍照
- (void)enterCamera;
//直接进入相册选择
- (void)enterPhotoLibrary;
@end
