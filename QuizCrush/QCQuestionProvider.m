//
//  QCQuestionProvider.m
//  QuizCrush
//
//  Created by Arvid on 2014-04-03.
//  Copyright (c) 2014 Planeto. All rights reserved.
//

#import "QCQuestionProvider.h"

@implementation QCQuestionProvider

-(QCQuestion *) provideQuestionOfCategory:(NSNumber *) category{
    // TODO placeholder implementation
    
    QCQuestion *q = [[QCQuestion alloc] initWithCategory:@4
                                                    topic:@"Fysik"
                                           questionString:@"Vad f\u00f6rs\u00f6ker man hitta i LIGO-experimentet?"
                                                  answers:@[@"Tyngdv\u00e5gor", @"Higgs-bosoner", @"Liv i rymden", @"Gammastr\u00e5lning"]
                                       correctAnswerIndex:@0];

    
    
    return q;
}

@end
