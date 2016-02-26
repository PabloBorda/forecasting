/**
   Author: Pablo Tomas Borda Di Berardino
**/


struct Hashtable {
  char **value;
  long size;
  int collision;
  long inserted;
};

void init(struct Hashtable *h, long size);
void insert(struct Hashtable *h,char *str);
char* valueAt(struct Hashtable *h,int pos);
