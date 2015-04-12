#import <UIKit/UIKit.h>
#import "Poll.h"

@interface ViewControllerCandidates : UIViewController

@property (strong,nonatomic) Poll *poll;
@property (weak,nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak,nonatomic) IBOutlet UILabel *LabelForPrimo;
@property (weak,nonatomic) IBOutlet UITextField *VotoForPrimo;
@property (weak,nonatomic) IBOutlet UITextView *DescriptionForPrimo;

@property (weak,nonatomic) IBOutlet UILabel *LabelForSecondo;
@property (weak,nonatomic) IBOutlet UITextField *VotoForSecondo;
@property (weak,nonatomic) IBOutlet UITextView *DescriptionForSecondo;

@property (weak,nonatomic) IBOutlet UILabel *LabelForTerzo;
@property (weak,nonatomic) IBOutlet UITextField *VotoForTerzo;
@property (weak,nonatomic) IBOutlet UITextView *DescriptionForTerzo;

@property (weak,nonatomic) IBOutlet UILabel *LabelForQuarto;
@property (weak,nonatomic) IBOutlet UITextField *VotoForQuarto;
@property (weak,nonatomic) IBOutlet UITextView *DescriptionForQuarto;

@property (weak,nonatomic) IBOutlet UILabel *LabelForQuinto;
@property (weak,nonatomic) IBOutlet UITextField *VotoForQuinto;
@property (weak,nonatomic) IBOutlet UITextView *DescriptionForQuinto;

@property (weak,nonatomic) IBOutlet UIButton *Submit;

@end