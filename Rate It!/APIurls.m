/* Classe contenente soltanto gli URL relativi alle API di "Rate It!" */

#import "APIurls.h"

NSString *URL_API = @"http://www.sapienzaapps.it/rateitapp";
<<<<<<< HEAD
NSString *URL_GET_POLLS = @"http://www.sapienzaapps.it/rateitapp/getpolls.php?pollid=_POLL_ID_&userid=_USER_ID_&start=_START_";
NSString *URL_GET_CANDIDATES = @"http://www.sapienzaapps.it/rateitapp/getcandidates.php?pollid=_POLL_ID_";
NSString *URL_SUBMIT_RANKING = @"http://www.sapienzaapps.it/rateitapp/submitranking.php?pollid=_POLL_ID_&userid=_USER_ID_&ranking=_RANKING_";
NSString *URL_GET_RESULTS = @"http://www.sapienzaapps.it/rateitapp/getresults.php?pollid=_POLL_ID_&force=_FORCE_";
NSString *URL_DUMP_POLL = @"http://www.sapienzaapps.it/rateitapp/dumppoll.php?pollid=_POLL_ID_";
NSString *URL_RESET_POLL = @"http://www.sapienzaapps.it/rateitapp/resetpoll.php?pollid=_POLL_ID_";
=======
NSString *const URL_GET_POLLS = @"http://www.sapienzaapps.it/rateitapp/getpolls.php?pollid=_POLL_ID_&userid=_USER_ID_&start=_START_";
NSString const *URL_GET_CANDIDATES = @"http://www.sapienzaapps.it/rateitapp/getcandidates.php?pollid=_POLL_ID_";



NSString const *URL_SUBMIT_RANKING = @"http://www.sapienzaapps.it/rateitapp/submitranking.php";

NSString const *URL_GET_RESULTS = @"http://www.sapienzaapps.it/rateitapp/getresults.php?pollid=_POLL_ID_&force=_FORCE_";
NSString const *URL_DUMP_POLL = @"http://www.sapienzaapps.it/rateitapp/dumppoll.php?pollid=_POLL_ID_";
NSString const *URL_RESET_POLL = @"http://www.sapienzaapps.it/rateitapp/resetpoll.php?pollid=_POLL_ID_";
>>>>>>> origin/master
NSString *URL_ADD_POLL = @"http://www.sapienzaapps.it/rateitapp/addpoll.php";

@implementation APIurls

@end