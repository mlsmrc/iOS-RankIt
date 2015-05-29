#import "ConnectionToServer.h"
#import "Poll.h"
#import "Candidate.h"
#import "File.h"

#define TIMEOUT_INTERVAL 10

/* Stringhe che appariranno a video per feedback di connessione */
NSString *SERVER_UNREACHABLE = @"Server non raggiungibile!\nAggiorna per riprovare.";
NSString *SERVER_UNREACHABLE_2 = @"Server non raggiungibile!";
NSString *TIMEOUT = @"Server non raggiungibile o sondaggio non trovato.";

NSMutableDictionary *dizionarioPolls;

@implementation ConnectionToServer {
    
    /* Dizionario che conterrà i poll scaricati per una determinata connessione */
    NSMutableDictionary *dizionarioPolls;
    
    /* Array di flag che permette il corretto ricaricamento delle view principali */
    NSMutableArray *FLAGS;
    
}

- (NSData *) sendPostRequestWithPostURL: (NSString*) postURL AndParametersString:(NSString *)parameters {
    
    NSData *postData = [parameters dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    /* Preparazione richiesta post */
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
    [request setURL:[NSURL URLWithString:postURL]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    request.timeoutInterval=TIMEOUT_INTERVAL;
    
    /* Invio richiesta e ritorno la risposta del server*/
    return [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
}

/*  La funzione inizialmente sostituisce alle sottostringhe del tipo _PARAMETRO_   *
 *  (all'interno della stringa url) i parametri propri della funzione.             *
 *  Crea successivamente una richiesta asincrona verso l'API, il cui risultato     *
 *  verrà inserito all'interno di un dizionario.                                   *
 *  Se non si vuole inserire un parametro si inserisce una stringa vuota ""        *
 *  (il php delle API lo avvertirà come se il parametro non fosse stato inserito). */
- (void) scaricaPollsWithPollId:(NSString*)pollId andUserId:(NSString*) userId andStart:(NSString*)start {
    
    /* Sostituzione dei parametri */
    NSString *url=[URL_GET_POLLS  stringByReplacingOccurrencesOfString:@"_POLL_ID_" withString:[NSString stringWithFormat:@"%@",pollId]];
    url=[url  stringByReplacingOccurrencesOfString:@"_USER_ID_" withString:userId];
    url=[url stringByReplacingOccurrencesOfString:@"_START_" withString:[NSString stringWithFormat:@"%@",start]];
    
    /* Creazione della richiesta ed invio */
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    /* Timeout connessione */
    request.timeoutInterval = TIMEOUT_INTERVAL;
    
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    /* Allocazione del dizionario che conterrà i poll scaricati per una determinata connessione */
    dizionarioPolls = [[NSMutableDictionary alloc]init];
    
    /* Viene controllato se la risposta del server è diversa da nil (connessione assente) */
    if(response!=nil) {
        
        /* Esito positivo: parsing del JSON nel dizionario polls (una entry per ogni poll) */
        NSMutableDictionary *polls = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        
        /* Controlliamo se la richiesta ha prodotto dei poll (se non ci fossero poll non succede nulla, il dizionario rimane vuoto) */
        if(polls!=nil) {
            
            /* Funzione che prende i pollid per ogni poll presente nel dizionario */
            NSArray *pollid = [polls valueForKey:@"pollid"];
            
            int i = 0;
            NSString *str;
            
            /* Controlla se pollid è un array, se lo è allora vuol dire che c'erano almeno due poll nel JSON altrimenti solo uno */
            if([pollid isKindOfClass:[NSArray class]]) {
                
                /* Iterazione che permette di costruire il dizionario nel seguente modo: <pollid1,poll1>,<pollid2,poll2>,...,<pollidN,pollN> */
                for(id key in polls) {
                    
                    /* Se userId="" allora è la richiesta di Home             *
                     * Se userId!="" e mine=1 allora è la richiesta di MyPoll */
                    if(([[key valueForKey:@"mine"] isEqual:@"1"] && ![userId isEqual:@""]) || [userId isEqual:@""]) {
                        
                        str = pollid[i];
                        [dizionarioPolls setObject:key forKey:[NSString stringWithString:str]];
                        i = i + 1;
                        
                    }
                    
                }
                
            }
            
            else {
                
                /* Se c'è solo un poll scaricato non serve iterare, OBJ-C vede questa come una variabile e non come array da un elemento */
                [dizionarioPolls setObject:polls forKey:pollid];
                
            }
            
        }
        
    }
    
    /* Non c'è connessione */
    else dizionarioPolls = nil;
    
}

/* Funzione che ritorna le scelte per il voto di un determinato poll specificato tramite pollId */
- (NSMutableArray*) getCandidatesWithPollId:(NSString*)pollId {
    
    /* Sostituzione dei parametri */
    NSString * url=[URL_GET_CANDIDATES stringByReplacingOccurrencesOfString:@"_POLL_ID_" withString:[NSString stringWithFormat:@"%@",pollId]];
    
    /* Creazione della richiesta ed invio */
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    /* Timeout connessione */
    request.timeoutInterval=TIMEOUT_INTERVAL;
    
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSDictionary *dict;
    
    NSMutableArray * arrayCandidates= [[NSMutableArray alloc]init];
    
    /* Esito positivo: parsing del JSON nel dizionario (una entry per ogni candidate) */
    if(response!=nil) {
        
        dict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        response=nil;
        
        /*Creazione dell'array contenente i candidates */
        for(NSString *key in dict) {
            
            Candidate * candidate=[[Candidate alloc]initCandicateWithChar:[key valueForKey:@"candchar"] andName:[key valueForKey:@"candname"] andDescription:[key valueForKey:@"canddescription"]];
            [arrayCandidates addObject:candidate];
            candidate=nil;
            
        }
        
    }
    
    /* Timeout di connessione */
    else
        arrayCandidates=nil;
    
    return arrayCandidates;
    
}

/*  Funzione che dato il pollid, lo userid e la stringa che corrisponde alla votazione  *
 *  inserisce la votazione relativa al poll al server                                   */
- (BOOL) submitRankingWithPollId:(NSString*)pollId andUserId:(NSString*)userId andRanking:(NSString*) ranking {
    
    /* Preparazione dati richiesta POST */
    NSString *ParPost = [NSString stringWithFormat:@"pollid=%@&userid=%@&ranking=%@",pollId,userId,ranking];
    
    /* Invio della richiesta POST */
    NSData *response = [self sendPostRequestWithPostURL:URL_SUBMIT_RANKING AndParametersString:ParPost];
    
    if(response!=nil) {
        
        [self scaricaPollsWithPollId:pollId andUserId:@"" andStart:@""];
        
        if([dizionarioPolls count]==0)
            return false;

        /* Aggiungi votazione in Voti.plist */
        [File writeOnPListRanking:ranking OfPoll:pollId];
        
        FLAGS = [[NSMutableArray alloc]init];
        [FLAGS addObject:@"HOME"];
        [FLAGS addObject:@"VOTATI"];
        [File writeOnReload:@"0" ofFlags:FLAGS];
        
        return true;
    }
    
    return false;
    
}

/*  Funzione che dato un oggetto di tipo Poll, aggiunge un poll e   *
 *  ritorna l'id del poll appena inserito come stringa              */
- (NSString *) addPollWithPoll:(Poll*)newpoll {
    
    /* Preparazione dati richiesta POST */
    NSString *post = [NSString stringWithFormat:@"newpoll=%@",[newpoll toJSON]];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    /* Preparazione richiesta post */
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
    [request setURL:[NSURL URLWithString:URL_ADD_POLL]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    /* Invio richiesta che tornerà un json con il pollid */
    NSData *requestHandler = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *requestReply = [[NSString alloc] initWithBytes:[requestHandler bytes]length:[requestHandler length]encoding:NSASCIIStringEncoding];
    
    /* Creazione dizionario per estrapolare il pollid */
    NSDictionary *d = [NSJSONSerialization JSONObjectWithData:[requestReply dataUsingEncoding:NSUTF8StringEncoding]options:NSJSONReadingMutableContainers error:nil];
    
    /* Ritorna il pollid associato */
    return ([d valueForKey:@"pollid"]);
    
}

/* Ritorna il dizionario contenente i poll nel formato <pollid,poll> */
- (NSMutableDictionary*) getDizionarioPolls {
    
    return dizionarioPolls;
    
}

/* Ritorna il dizionario nel formato <pollid,poll> contenente solo i poll votati, leggendo dal file Votes.plist */
- (NSMutableDictionary*) getDizionarioPollsVotati {
    
    /* Dizionario di tutti i poll votati */
    NSMutableDictionary *PollVotati = [[NSMutableDictionary alloc]init];
    
    /* Contiene i pollid di tutti i poll votati dall'utente */
    NSArray *VotesPListKeys = [File getAllKeysinPList:VOTES_PLIST];
    
    if([VotesPListKeys count]==0)
        return PollVotati;
    
    /* Aggiungi i poll votati nel dizionario */
    for(NSString *pollid in VotesPListKeys) {
        
        [self scaricaPollsWithPollId:pollid andUserId:@"" andStart:@""];
        
        if(dizionarioPolls==nil)
            return nil;
        
        else {
            
            NSString *p = [dizionarioPolls objectForKey:pollid];
            
            if(![[p valueForKey:@"votes"]isEqualToString:@"0"])
                [PollVotati addEntriesFromDictionary:dizionarioPolls];
        
        }
    
    }
    
    return PollVotati;
    
}

/* Resetta le votazioni del poll */
- (BOOL) resetPollWithPollId:(NSString *)pollId AndUserID:(NSString*)userId {
    
    /* Preparazione dati richiesta POST */
    NSString *ParPost = [NSString stringWithFormat:@"pollid=%@&userid=%@",pollId,userId];
    
    /* Invio della richiesta POST */
    NSData *response = [self sendPostRequestWithPostURL:URL_RESET_POLL AndParametersString:ParPost];
    
    if(response!=nil) {
        
        NSString *dictResponse = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        return ([[dictResponse valueForKey:@"reset"] isEqual:@"1"] ? true:false);
        
    }
    
    else
        return false;
    
}

/* Elimina il poll */
- (BOOL) deletePollWithPollId:(NSString *)pollId AndUserID:(NSString*)userId {
    
    /* Preparazione dati richiesta POST */
    NSString *ParPost = [NSString stringWithFormat:@"pollid=%@&userid=%@",pollId,userId];
    
    /* Invio della richiesta POST */
    NSData *response = [self sendPostRequestWithPostURL:URL_DELETE_POLL AndParametersString:ParPost];
    
    if(response!=nil) {
        
        NSString *dictResponse = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        return ([[dictResponse valueForKey:@"delete"] isEqual:@"1"] ? true:false);
        
    }
    
    else
        return false;
    
}

- (NSMutableDictionary*) getResultsOfPoll:(Poll*)poll {
    
    NSString* url = [URL_GET_RESULTS stringByReplacingOccurrencesOfString:@"_POLL_ID_" withString:[NSString stringWithFormat: @"%d", poll.pollId]];
    
    url=[url stringByReplacingOccurrencesOfString:@"_FORCE_" withString:@""];
    
    /* Creazione della richiesta ed invio */
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    /* Timeout connessione */
    request.timeoutInterval=TIMEOUT_INTERVAL;
    
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    /* Viene controllato se la risposta del server è diversa da nil */
    if(response!=nil) {
        
        /* Esito positivo: parsing del JSON nel dizionario polls (una entry per ogni poll) */
        NSMutableDictionary *results = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        
        return results;
        
    }
    
    return nil;
    
}

- (NSMutableArray *) getOptimalResultsOfPoll:(Poll*)poll {
    
    NSString* url = [URL_GET_RESULTS stringByReplacingOccurrencesOfString:@"_POLL_ID_" withString:[NSString stringWithFormat: @"%d", poll.pollId]];
    
    url=[url stringByReplacingOccurrencesOfString:@"_FORCE_" withString:@""];
    
    /* Creazione della richiesta ed invio */
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    /* Timeout connessione */
    request.timeoutInterval=TIMEOUT_INTERVAL;
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    /* Viene controllato se la risposta del server è diversa da nil (connessione assente) */
    if(response!=nil) {
        
        /* Esito positivo: parsing del JSON nel dizionario polls (una entry per ogni poll) */
        NSMutableDictionary *results = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        
        NSMutableArray *candidates=[self getCandidatesWithPollId:[NSString stringWithFormat:@"%d",poll.pollId]];
        
        if(candidates!=nil)
            [poll setCandidates:candidates];
        else
            return nil;
        
        NSMutableArray * classifiche=[[results valueForKey:@"optimalnotiesdata"]valueForKey:@"pattern"];
        
        if([classifiche count]==0)
            classifiche = [[results valueForKey:@"optimaldata"]valueForKey:@"pattern"];
        
        /* Se la classifica è null i voti sono 0 e ritorno un oggetto vuoto */
        if(classifiche==nil)
            return [[NSMutableArray alloc]init];
        
        NSMutableArray * classificaOttimale=[[NSMutableArray alloc]init];
        NSString* classificaFinale=classifiche[0];
        unichar buffer[classificaFinale.length+1];
        [classificaFinale getCharacters:buffer range:NSMakeRange(0, classificaFinale.length)];
        
        int j=0;
        
        for(int i = 0; i < classificaFinale.length; i++) {
            
            if(buffer[i]=='A'||buffer[i]=='B'||buffer[i]=='C'||buffer[i]=='D'||buffer[i]=='E') {
                
                NSString *risp=[NSString stringWithFormat:@"%c",buffer[i]];
                classificaOttimale[j]=risp;
                j++;
                
            }
            
        }
        
        classificaOttimale[j]=classificaFinale;
        
        /* Array del tipo [C,A,B,A>B=C] con l'ultima stringa per disambiguare la classifica */
        return classificaOttimale;
        
    }
    
    return nil;
    
}

@end