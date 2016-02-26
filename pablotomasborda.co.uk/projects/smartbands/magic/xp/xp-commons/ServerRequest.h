#ifndef UDPREQUEST_H_
#define UDPREQUEST_H_

namespace server {


class ServerRequest
{
	
public:
	ServerRequest();
	ServerRequest(char req_id,char *args,char *email);
	bool exec();  // performs the task for the request	
        virtual ~ServerRequest();
	char *getOutput();
        char getRequestID();
        void setRequestID(char req_id);
        char *getEmail();
        void setEmail(char *mail);
        void setArgs(char *args);
        char *getArgs();
protected:
	virtual bool before();   // do some checking before running the request
	virtual bool after();    // do some checking after running the request
	virtual void setOutput(char *o);
        virtual int execute();
        char *args;
        char req_id;
        char *email;	
        char *output;
        bool email_is_right; //if the email address I got is right this is set to true
	
 
};
};

#endif /*UDPREQUEST_H_*/
