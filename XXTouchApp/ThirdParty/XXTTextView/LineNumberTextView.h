//
//  LineNumberTextView.h
//  TextKit_LineNumbers
//
//  Created by Mark Alldritt on 2013-10-11.
//  Copyright (c) 2013 Late Night Software Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


#define kLineNumberGutterWidth      35.0

@interface LineNumberTextView : UITextView <NSTextStorageDelegate>
@property (nonatomic, strong)UIColor *lineBackgroundColor;
@property NSDictionary *highlightDefinition;
@property NSDictionary *highlightTheme;

- (void)requireGestureRecognizerToFail:(UIGestureRecognizer *)gestureRecognizer;
@end
