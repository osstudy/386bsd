#!/bin/sh

# $XFree86: mit/server/ddx/x386/LinkKit/x386config.sh,v 2.4 1993/09/12 11:21:51 dawes Exp $
#
# Generate X386Conf.tmpl Imake template
#
# Link Kit version
#
# Usage: x386config.sh MODULETYPE1 module ... MODULETYPE2 module ...
#

Iconfig=X386Conf.tmpl

ModuleHeader=
ModuleList=
BuildVga2=NO
BuildHga2=NO
BuildBdm2=NO
BuildVga16=NO
BuildVga256=NO
ExtraRenderers=NO

cat > $Iconfig <<EOF
XCOMM  --------------------------------------------------------------------
XCOMM  X386Conf.tmpl  -- configuration parameters for X386
XCOMM  This file is automatically generated -- DO NOT EDIT
XCOMM  --------------------------------------------------------------------

         X386SRC = drivers
    VGADRIVERSRC = \$(X386SRC)/vga256
  VGA16DRIVERSRC = \$(X386SRC)/vga16
   VGA2DRIVERSRC = \$(X386SRC)/vga2
   HGA2DRIVERSRC = \$(X386SRC)/hga2
   BDM2DRIVERSRC = \$(X386SRC)/bdm2
     S3DRIVERSRC = \$(X386SRC)/s3
     RENDERERSRC = renderers
 RENDERERCONFOBJ = rendererConf.o
RENDERERCONFSUBDIR = .
EOF

Done=NO
while [ $Done = NO ]; do
    Args="$*"
    case $1 in
        ''|VGADRIVER|VGA16DRIVER|VGA2DRIVER|HGA2DRIVER|BDM2DRIVER|S3DRIVER|RENDERER)
            if [ X"$ObjsHeader" != X ]; then
		if [ X"$ModuleObjs" = X ]; then
		    echo "$ObjsHeader" >> $Iconfig
		else
		    echo "$ObjsHeader \\" >> $Iconfig
		    set - $ModuleObjs
		    while [ $# -gt 1 ]; do
                        echo "                   $1 \\" >> $Iconfig
                        shift
                    done
                    echo "                   $1" >> $Iconfig
                    shift
		fi
	    fi
            if [ X"$SubdirsHeader" != X ]; then
		if [ X"$ModuleSubdirs" = X ]; then
		    echo "$SubdirsHeader" >> $Iconfig
		else
		    echo "$SubdirsHeader \\" >> $Iconfig
		    set - $ModuleSubdirs
		    while [ $# -gt 1 ]; do
                        echo "                   $1 \\" >> $Iconfig
                        shift
                    done
                    echo "                   $1" >> $Iconfig
                    shift
		fi
	    fi
            set - $Args
            ModuleType=$1
            ModuleObjs=
            ModuleSubdirs=
	    case $ModuleType in
                VGADRIVER)
                    ObjsHeader='         VGAOBJS ='
                    SubdirsHeader='      VGASUBDIRS ='
                    ;;
                VGA16DRIVER)
                    ObjsHeader='         VGA16OBJS ='
                    SubdirsHeader='      VGA16SUBDIRS ='
                    ;;
                VGA2DRIVER)
                    ObjsHeader='        VGA2OBJS ='
                    SubdirsHeader='     VGA2SUBDIRS ='
                    ;;
                HGA2DRIVER)
                    ObjsHeader='        HGA2OBJS ='
                    SubdirsHeader='     HGA2SUBDIRS ='
                    ;;
                BDM2DRIVER)
                    ObjsHeader='        BDM2OBJS ='
                    SubdirsHeader='     BDM2SUBDIRS ='
                    ;;
                S3DRIVER)
                    ObjsHeader='        S3OBJS ='
                    SubdirsHeader='     S3SUBDIRS ='
                    ;;
                RENDERER)
                    ObjsHeader='    RENDERERLIBS ='
                    SubdirsHeader=' RENDERERSUBDIRS ='
                    ;;
	    esac
	    ;;
        *)
            case $ModuleType in
                VGADRIVER)
                    BuildVga256=YES
                    ModuleObjs="$ModuleObjs "'$(VGADRIVERSRC)'/$1/$1.o
                    ModuleSubdirs="$ModuleSubdirs $1"
                    ;;
                VGA16DRIVER)
                    BuildVga16=YES
                    ModuleObjs="$ModuleObjs "'$(VGA16DRIVERSRC)'/$1/$1.o
                    ModuleSubdirs="$ModuleSubdirs $1"
                    ;;
                VGA2DRIVER)
                    BuildVga2=YES
                    ModuleObjs="$ModuleObjs "'$(VGA2DRIVERSRC)'/$1/$1.o
                    ModuleSubdirs="$ModuleSubdirs $1"
                    ;;
                HGA2DRIVER)
                    BuildHga2=YES
                    ModuleObjs="$ModuleObjs "'$(HGA2DRIVERSRC)'/$1/$1.o
                    ModuleSubdirs="$ModuleSubdirs $1"
                    ;;
                BDM2DRIVER)
                    BuildBdm2=YES
                    ModuleObjs="$ModuleObjs "'$(BDM2DRIVERSRC)'/$1/$1.o
                    ModuleSubdirs="$ModuleSubdirs $1"
                    ;;
                S3DRIVER)
                    ModuleObjs="$ModuleObjs "'$(S3DRIVERSRC)'/$1/$1.o
                    ModuleSubdirs="$ModuleSubdirs $1"
                    ;;
                RENDERER)
                    ExtraRenderers=YES
                    ModuleObjs="$ModuleObjs "'$(RENDERERSRC)'/lib$1.a
                    ModuleSubdirs="$ModuleSubdirs "$1
                    ;;
            esac
            ;;
    esac
    if [ $# -eq 0 ]; then
        Done=YES
    else
        shift
    fi
done

echo >> $Iconfig
echo "#define BuildVga2 $BuildVga2" >> $Iconfig
echo "#define BuildHga2 $BuildHga2" >> $Iconfig
echo "#define BuildBdm2 $BuildBdm2" >> $Iconfig
echo "#define BuildVga16 $BuildVga16" >> $Iconfig
echo "#define BuildVga256 $BuildVga256" >> $Iconfig
echo "#define ExtraRenderers $ExtraRenderers" >> $Iconfig
echo >> $Iconfig

cat >> $Iconfig <<EOF
#if XF86MonoServer
#if BuildVga2
     VGA2CONFOBJ = vga2Conf.o
  VGA2CONFSUBDIR = .
       VGA2BUILD = -DBUILD_VGA2
#endif
#if BuildHga2
     HGA2CONFOBJ = hga2Conf.o
  HGA2CONFSUBDIR = .
       HGA2BUILD = -DBUILD_HGA2
#endif
#if BuildBdm2
     BDM2CONFOBJ = bdm2Conf.o
  BDM2CONFSUBDIR = .
       BDM2BUILD = -DBUILD_BDM2
#endif
   X386MCONFOBJS = \$(VGA2CONFOBJ) \$(HGA2CONFOBJ) \$(BDM2CONFOBJ)
X386MCONFSUBDIRS = \$(VGA2CONFSUBDIR) \$(HGA2CONFSUBDIR) \$(BDM2CONFSUBDIR)
#endif
#if XF86VGA16Server
#if BuildVga16
    VGA16CONFOBJ = vga16Conf.o
 VGA16CONFSUBDIR = .
      VGA16BUILD = -DBUILD_VGA16
#endif
   VGA16CONFOBJS = \$(VGA16CONFOBJ)
VGA16CONFSUBDIRS = \$(VGA16CONFSUBDIR)
#endif
#if XF86SVGAServer
#if BuildVga256
      VGACONFOBJ = vga256Conf.o
   VGACONFSUBDIR = .
        VGABUILD = -DBUILD_VGA256
#endif
    X386CONFOBJS = \$(VGACONFOBJ)
 X386CONFSUBDIRS = \$(VGACONFSUBDIR)
#endif
#if XF86S3Server
       S3CONFOBJ = s3Conf.o
    S3CONFSUBDIR = .
#endif
 X386SCREENFLAGS = \$(VGA2BUILD) \$(HGA2BUILD) \$(BDM2BUILD) \$(VGA16BUILD) \$(VGABUILD)
EOF
