/* COBOL buffer/ownership interoperability. Licensing behavior stays in C core. */
#define _POSIX_C_SOURCE 200809L
#include <licensebox_json.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
extern int lbc_owner_create(const char*,const lb_callbacks*,void**,char**);
extern int lbc_owner_call(void*,const char*,const char*,char**,char**);
extern int lbc_owner_close(void*);
extern int lbc_owner_heartbeat(void*,const char*,char**,char**);
extern void lbc_owner_release(void*);
static char *input(const char *s,size_t n) {
 while(n && s[n-1]==' ')n--;
 if(memchr(s,0,n))return NULL;
 char *p=malloc(n+1);if(p){memcpy(p,s,n);p[n]=0;}return p;
}
static int copy(char *out,size_t n,const char *value) {
 memset(out,' ',n);if(!value)return 0;
 size_t len=strlen(value);if(len>n)return LB_IO_ERROR;
 memcpy(out,value,len);return 0;
}
int lbc_create(const char *options,size_t n,const lb_callbacks *callbacks,void **handle,char *error,size_t error_n) {
 *handle=NULL;char *s=input(options,n),*e=NULL;int r=LB_INVALID_ARGUMENT;
 if(s)r=lbc_owner_create(s,callbacks,handle,&e);
 copy(error,error_n,r?(e?e:lb_result_code(r)):"");free(s);lb_free(e);return r;
}
int lbc_call(void *h,const char *op,size_t op_n,const char *args,size_t args_n,char *out,size_t out_n,char *error,size_t error_n) {
 char *o=input(op,op_n),*a=input(args,args_n),*p=NULL,*e=NULL;int r=LB_INVALID_ARGUMENT;
 if(o&&a)r=lbc_owner_call(h,o,a,&p,&e);
 if(!r)r=copy(out,out_n,p);else memset(out,' ',out_n);
 copy(error,error_n,r?(e?e:lb_result_code(r)):"");free(o);free(a);lb_free(p);lb_free(e);return r;
}
int lbc_close(void **h) {
 if(!*h)return 0;int r=lbc_owner_close(*h);if(!r){lbc_owner_release(*h);*h=NULL;}return r;
}
int lbc_derive(const char *product,size_t pn,const char *source,size_t sn,const char *raw,size_t rn,char *out,size_t on,char *error,size_t en) {
 while(rn&&(raw[rn-1]==' '||raw[rn-1]==0))rn--;
 char *p=input(product,pn),*s=input(source,sn),*v=input(raw,rn);char b[128];int r=LB_INVALID_ARGUMENT;
 if(p&&s)r=v?lb_derive_binding(p,s,v,b,sizeof(b)):LB_IDENTITY_UNAVAILABLE;
 if(!r)r=copy(out,on,b);else memset(out,' ',on);
 copy(error,en,r?lb_result_code(r):"");free(p);free(s);free(v);return r;
}
int lbc_native(const char *product,size_t pn,char *out,size_t on,char *error,size_t en) {
 char *p=input(product,pn);char b[128];int r=p?lb_native_binding(p,b,sizeof(b)):LB_INVALID_ARGUMENT;
 if(!r)r=copy(out,on,b);else memset(out,' ',on);
 copy(error,en,r?lb_result_code(r):"");free(p);return r;
}
int lbc_verify(const char *token,size_t tn,const char *product,size_t pn,const char *keys,size_t kn,double now,char *out,size_t on,char *error,size_t en) {
 char *t=input(token,tn),*p=input(product,pn),*k=input(keys,kn),*value=NULL;int r=LB_INVALID_ARGUMENT;
 if(t&&p&&k)r=lb_verify_lease_json(t,p,k,now,&value);
 if(!r)r=copy(out,on,value);else memset(out,' ',on);
 copy(error,en,r?lb_result_code(r):"");free(t);free(p);free(k);lb_free(value);return r;
}

int lbc_heartbeat(void *h,const char *module,size_t n,char *out,size_t out_n,char *error,size_t error_n) {
 char *m=input(module,n),*p=NULL,*e=NULL;int r=LB_INVALID_ARGUMENT;
 if(m)r=lbc_owner_heartbeat(h,m,&p,&e);
 if(!r)r=copy(out,out_n,p);else memset(out,' ',out_n);
 copy(error,error_n,r?(e?e:lb_result_code(r)):"");free(m);lb_free(p);lb_free(e);return r;
}
