//
//  QCSelectCategoryPopup.h
//  TestCategoryPopup
//
//  Created by Arvid on 2014-04-11.
//  Copyright (c) 2014 Planeto. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QCSelectCategoryDelegate

-(void) selectCategoryButtonHandler:(NSNumber *) category;

@end

@interface QCSelectCategoryPopup : UIView

@property (weak) id <QCSelectCategoryDelegate> delegate;

@end
