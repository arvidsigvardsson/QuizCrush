//
//  QCGridView.h
//  NewTestViews
//
//  Created by Arvid on 2014-04-04.
//  Copyright (c) 2014 Planeto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QCQuestion.h"

@protocol PopupViewDelegate

-(NSArray *) questionStrings:(QCQuestion *) question; //:(id) qObject;
-(void) answerButtonHandler:(NSNumber *) index;

@end

@interface QCPopupView : UIView

@property (weak) id <PopupViewDelegate> delegate;

-(void) loadQuestionStrings:(QCQuestion *)question;

@end
