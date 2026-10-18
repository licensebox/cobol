/* Synthetic conformance transport and callbacks only; no SDK operation calls. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <licensebox_json.h>
static double now;
static char binding[256];
static double clock_fn(void *p){(void)p;return now;}
static int binding_fn(void *p,char *out,size_t size){(void)p;return snprintf(out,size,"%s",binding)>=(int)size;}
static void signin_fn(void *p,const char *u,const char *c){(void)p;(void)u;(void)c;}
static lb_callbacks callbacks={NULL,signin_fn,clock_fn,binding_fn,NULL};
void *synthetic_callbacks(const char *time,const char *host,size_t capacity){
 now=strtod(time,NULL);while(capacity&&host[capacity-1]==' ')capacity--;
 if(capacity>=sizeof(binding))abort();memcpy(binding,host,capacity);binding[capacity]=0;return &callbacks;
}
int read_field(char *out,size_t capacity){
 size_t i=0;int a,b;memset(out,' ',capacity);
 while((a=getchar())!='\n'&&a!=EOF){b=getchar();if(b==EOF||i>=capacity)return 1;
 int hi=a<='9'?a-'0':a-'a'+10,lo=b<='9'?b-'0':b-'a'+10;
 if(hi<0||hi>15||lo<0||lo>15)return 1;out[i++]=(char)(hi*16+lo);}
 return 0;
}
void write_field(const char *out,size_t capacity){
 while(capacity&&out[capacity-1]==' ')capacity--;
 for(size_t i=0;i<capacity;i++)printf("%02x",(unsigned char)out[i]);puts("");
}
