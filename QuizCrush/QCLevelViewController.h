//
//  QCLevelViewController.h
//  QuizCrush
//
//  Created by Arvid on 2014-03-17.
//  Copyright (c) 2014 Planeto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QCPlayingFieldModel.h"
#import "QCQuestionProvider.h"
#import "QCPopupView.h"
#import "QCTileImageProvider.h"
#import "QCSelectCategoryPopup.h"
#import "QCSelectCategoryPopup.h"
#import "QCTileHolderView.h"

@interface QCLevelViewController : UIViewController <PopupViewDelegate, QCSelectCategoryDelegate, UIAlertViewDelegate>

typedef struct gridPosition {
    int x, y;
} gridPosition;

@end
