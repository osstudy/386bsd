/*
 * This file was generated by the mkbuiltins program.
 */

#include <sys/cdefs.h>
#define BLTINCMD 0
#define BGCMD 1
#define BREAKCMD 2
#define CDCMD 3
#define DOTCMD 4
#define ECHOCMD 5
#define EVALCMD 6
#define EXECCMD 7
#define EXITCMD 8
#define EXPORTCMD 9
#define FGCMD 10
#define GETOPTSCMD 11
#define HASHCMD 12
#define JOBIDCMD 13
#define JOBSCMD 14
#define LCCMD 15
#define LOCALCMD 16
#define PWDCMD 17
#define READCMD 18
#define RETURNCMD 19
#define SETCMD 20
#define SETVARCMD 21
#define SHIFTCMD 22
#define TRAPCMD 23
#define TRUECMD 24
#define UMASKCMD 25
#define UNSETCMD 26
#define WAITCMD 27

struct builtincmd {
      char *name;
      int code;
};

extern int (*const builtinfunc[])();
extern const struct builtincmd builtincmd[];