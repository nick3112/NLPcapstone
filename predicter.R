
load("C:\\Nick\\07 R\\6JohnHopkins\\10 Capstone Project\\4 Shiny App\\Text_Predict\\ng.rda");
#######################################################################
## load the stopwords to remove

    stopWords<-c(c("rt","RT","amp","u.s.","u.s","p.m.","p.m","gt","g.t.","g.t","lt","l.t.","l.t","ny","n.y.","b","c","d","e","f","g","h","j","k","m","n","o","p","q","r","s","u","v","w","x","y","z"))  #add RT,rt to stopwords to clean up twitter

#######################################################################
## clean the user input text to be turned into n-grams

   #this function applies the same cleaning as the training datasets {twitter, news, blogs}
    cleanText<-function(textInput){
      ifelse (textInput == c(NULL,"", " "),
              cleanText<-NULL,    #return null
              #clean the text of non-printables, 
              cleanText<-gsub("'","",removeWords(trimws(gsub("\\s+"," ",gsub("\\s+|[^[:alnum:][:space:]']|[0-9]+", " ",gsub("\\s[#@]\\S+","",tolower(iconv(textInput,"ASCII","UTF-8","")))))),stopWords))
      )
      return(cleanText) #output the final info
    }


#######################################################################
## clear out any emoji or unprintable characters
    
    removeUnprintable<-function(s){iconv(s,"ASCII","UTF-8",sub="")}
    
    
#######################################################################
## turn the user input into ngrams to be analysed
   
    inputNgram<-function(textInput){
    
      #create the   
      ifelse (textInput == c(NULL,"", " "),
              {ng1=NULL;ng2=NULL;ng3=NULL;ng4=NULL},    #return null
              #clean the text of non-printables, 
              cleanText<-gsub("'","",removeWords(trimws(gsub("\\s+"," ",gsub("\\s+|[^[:alnum:][:space:]']|[0-9]+", " ",gsub("\\s[#@]\\S+","",tolower(iconv(textInput,"ASCII","UTF-8","")))))),stopWords))
      )
      
      #and extract the n-gram input
      ng1<-noquote(sapply(strsplit(cleanText,'\\s+'),function(v) paste(collapse=' ',tail(v,1L))));  #iterate through the brackets to test each element
      ng2<-noquote(sapply(strsplit(cleanText,'\\s+'),function(v) paste(collapse=' ',tail(v,2L))));
      ng3<-noquote(sapply(strsplit(cleanText,'\\s+'),function(v) paste(collapse=' ',tail(v,3L))));
      ng4<-noquote(sapply(strsplit(cleanText,'\\s+'),function(v) paste(collapse=' ',tail(v,4L))));
      #count the n-gram length and set to null if problematic
      c1<-sapply(strsplit(ng1, " "), length);if(c1!=1){ng1=NULL}
      c2<-sapply(strsplit(ng2, " "), length);if(c2!=2){ng2=NULL}
      c3<-sapply(strsplit(ng3, " "), length);if(c3!=3){ng3=NULL}
      c4<-sapply(strsplit(ng4, " "), length);if(c4!=4){ng4=NULL}
      nGram<-list(ng1,ng2,ng3,ng4)
      return(nGram) #output the final info
    }
    

#######################################################################
## start the simplified katz backoff model: create a set of all matched ngrams
    
    
    #match the input string against the ngram prediction set, get all possible matches
    #if too few, add the 5 best 1-gram results in to pad out and always return a solution
    getResults<-function(inputNgram){
      
      #alpha assumptions (discount the probabilities of lower order n-grams to favour better matches)
      a5=1;a4=0.9;a3=0.6;a2=0.4;
      #create the ngram input sets from the loaded ng dataset
      five<-ng[ng==5,];four<-ng[ng==4,];three<-ng[ng==3,];two<-ng[ng==2,];p1<-ng[ng==1,];
      
      #now match the ngrams to the tables
      results<-NULL;
      ##filter the n-gram table {one, two, ...} by the input string tn[i]
      p5<-five[five$input==inputNgram[4]];p5$Freq<-(p5$Freq/sum(p5$Freq))*a5;
      if(nrow(p5)!=0){results=p5;}  #create 'results' if there is a value
      p4<-four[four$input==inputNgram[3]];p4$Freq<-(p4$Freq/sum(p4$Freq))*a4;
      if(nrow(p4)!=0){ifelse(is.null(results),results<-p4,results<-rbind(results,p4))}
      p3<-three[three$input==inputNgram[2]];p3$Freq<-(p3$Freq/sum(p3$Freq))*a3;
      if(nrow(p3)!=0){ifelse(is.null(results),results<-p3,results<-rbind(results,p3))}
      p2<-two[two$input==inputNgram[1]];p2$Freq<-(p2$Freq/sum(p2$Freq))*a2;
      if(nrow(p2)!=0){ifelse(is.null(results),results<-p2,results<-rbind(results,p2))}
      if(sum(nrow(p2),nrow(p3),nrow(p4),nrow(p5))<6){ifelse(is.null(results),results<-p1,results<-rbind(results,p1))}
      return(results)
    }

    
#######################################################################
## now reduce the prediction to the best "j" results selected by the user
    
    selectResults<-function(results,j) {   
      
      #remove duplicates with higher n-grams picked first
      results<-results[order(results$result,-results$ng),]
      results<-results[!duplicated(results$result),]
      #now order to the 
      results<-results[order(-results$Freq,-results$ng),]
      #select only "j" results based on the user input
      results<-head(results,j)
      #print(results)   #works to here
      
      #if not enough left or null, add in the 1-gram results
      return(results)
    }
    

##############################
#now run the the prediction....

    predict<-function(input, j){
      #handle the case when input is {"" or " "}  i.e. at the start
        ifelse(is.null(input)|trimws(input)=="",{
          return(NULL)
          print("this has worked")
        },{
          #take the input and remove unprintables/emoji
          input2<-removeUnprintable(input)
          #now clean the data so it looks like the data input into the ngram analysis
          input3<-cleanText(input2)
          #get the ngrams from the input
          nGram<-inputNgram(input3)  #get the 5 ngrams from the input
          #match to the 5 grams and calculate probabilities
          myResult<-getResults(nGram)  
          #select the final "j" predictions
          myResult<-selectResults(myResult,j) 
          myResult<-myResult[,3] #keep only the prediction words
          #        print(myResult)
          #final prediction set
          return(myResult)     
        })
    }