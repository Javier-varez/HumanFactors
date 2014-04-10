//
//  HFPPhraseMeasureTableViewCell.h
//  HumanFactors
//
//  Created by Francisco Javier Álvarez García on 09/04/14.
//  Copyright (c) 2014 Francisco Javier Álvarez García. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HFPPhraseMeasureTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *charactersPerMinuteLabel;
@property (nonatomic, weak) IBOutlet UILabel *efficiencyLabel;
@property (nonatomic, weak) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *keyboardLabel;

@end
