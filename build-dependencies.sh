#! /bin/bash

export PKG_CONFIG_PATH=/${AIPREFIX}/lib64/pkgconfig:/${AIPREFIX}/lib/pkgconfig:/${AIPREFIX}/share/pkgconfig:$PKG_CONFIG_PATH
export ACLOCAL_PATH=/${AIPREFIX}/share/aclocal:$ACLOCAL_PATH
export LD_LIBRARY_PATH=/${AIPREFIX}/lib64:/${AIPREFIX}/lib:$LD_LIBRARY_PATH

(yum update -y && yum install -y epel-release && yum update -y && yum install -y libtool-ltdl-devel autoconf automake libtools which json-c-devel json-glib-devel gtk-doc gperf libuuid-devel libcroco-devel intltool libpng-devel make \
automake fftw-devel libjpeg-turbo-devel \
libwebp-devel libxml2-devel swig ImageMagick-c++-devel \
bc cfitsio-devel gsl-devel matio-devel \
giflib-devel pugixml-devel wget curl git itstool \
bison flex unzip dbus-devel libXtst-devel \
mesa-libGL-devel mesa-libEGL-devel vala \
libxslt-devel docbook-xsl libffi-devel \
libvorbis-devel python-six curl \
openssl-devel readline-devel expat-devel libtool \
pixman-devel libffi-devel gtkmm24-devel gtkmm30-devel libcanberra-devel \
lcms2-devel gtk-doc python-devel python-pip nano OpenEXR-devel) || exit 1

mkdir -p /work/build

if [ ! -e /work/build/lcms2-2.9 ]; then
  (cd /work/build && rm -rf lcms2* && wget https://launchpad.net/ubuntu/+archive/primary/+sourcefiles/lcms2/2.9-2/lcms2_2.9.orig.tar.gz && tar xvf lcms2_2.9.orig.tar.gz && cd lcms2-2.9 && ./configure --prefix=/${AIPREFIX} && make install) || exit 1
fi


if [ ! -e /work/build/libpng-1.6.35 ]; then
  (cd /work/build && rm -rf libpng* && wget https://sourceforge.net/projects/libpng/files/libpng16/1.6.35/libpng-1.6.35.tar.xz && tar xvf libpng-1.6.35.tar.xz && cd libpng-1.6.35 && ./configure --prefix=/${AIPREFIX} && make -j 2 install) || exit 1
fi

if [ ! -e /work/build/freetype-2.9.1 ]; then
(cd /work/build && rm -rf freetype* && wget https://download.savannah.gnu.org/releases/freetype/freetype-2.9.1.tar.bz2 && tar xvf freetype-2.9.1.tar.bz2 && cd freetype-2.9.1 && ./configure --prefix=/${AIPREFIX} && make -j 2 install) || exit 1
fi


if [ ! -e /work/build/fontconfig-2.13.0 ]; then
  (cd /work/build && rm -rf fontconfig* && wget https://www.freedesktop.org/software/fontconfig/release/fontconfig-2.13.0.tar.bz2 && tar xvf fontconfig-2.13.0.tar.bz2 && cd fontconfig-2.13.0 && ./configure --prefix=/${AIPREFIX} --disable-docs && make -j 2 install) || exit 1
fi


#  (cd /work/build && rm -rf glib* && git clone -b glib-2-56 https://gitlab.gnome.org/GNOME/glib.git && cd glib && ./autogen.sh --prefix=/${AIPREFIX} && make -j 2 install) || exit 1
#  exit


if [ ! -e /work/build/exiv2-trunk ]; then
  (cd /work/build && rm -rf exiv2* && wget http://www.exiv2.org/builds/exiv2-0.26-trunk.tar.gz && tar xvf exiv2-0.26-trunk.tar.gz && cd exiv2-trunk && mkdir -p build && cd build && cmake -DCMAKE_INSTALL_PREFIX=/${AIPREFIX} .. && make -j 2 install) || exit 1
  cp -a /${AIPREFIX}/lib64/libexiv2.so* /${AIPREFIX}/lib
fi


if [ ! -e /work/build/cairo-1.15.12 ]; then
  (cd /work/build && rm -rf cairo* && wget https://www.cairographics.org/snapshots/cairo-1.15.12.tar.xz && tar xvf cairo-1.15.12.tar.xz && cd cairo-1.15.12 && ./configure --prefix=/${AIPREFIX} && make -j 2 install) || exit 1
fi

#export PYTHONPATH=/${AIPREFIX}/lib64/python2.7/site-packages/:$PYTHONPATH

pip install pycairo || exit 1
#if [ ! -e /work/build/pycairo-1.17.1 ]; then
#  (cd /work/build && rm -rf pycairo* && wget https://github.com/pygobject/pycairo/releases/download/v1.17.1/pycairo-1.17.1.tar.gz && tar xvf pycairo-1.17.1.tar.gz && cd pycairo-1.17.1) || exit 1
#  exit
#fi


if [ ! -e /work/build/librsvg ]; then
  curl https://sh.rustup.rs -sSf > /r.sh && bash /r.sh -y
  export PATH=$HOME/.cargo/bin:$PATH
  (cd /work/build && rm -rf librsvg* && git clone -b librsvg-2.42 https://gitlab.gnome.org/GNOME/librsvg.git && cd librsvg && ./autogen.sh --prefix=/${AIPREFIX} && make -j 2 install) || exit 1
fi


if [ ! -e /work/build/poppler-0.68.0 ]; then
(cd /work/build && rm -rf poppler-data* && wget https://poppler.freedesktop.org/poppler-data-0.4.9.tar.gz && tar xvf poppler-data-0.4.9.tar.gz && cd poppler-data-0.4.9 && mkdir -p build && cd  build && FREETYPE_DIR=/${AIPREFIX} cmake -DCMAKE_INSTALL_PREFIX=/${AIPREFIX} .. && make VERBOSE=1 -j 1 install) || exit 1
(cd /work/build && rm -rf poppler-0.* && wget https://poppler.freedesktop.org/poppler-0.68.0.tar.xz && tar xvf poppler-0.68.0.tar.xz && cd poppler-0.68.0 && mkdir -p build && cd  build && FREETYPE_DIR=/${AIPREFIX} cmake -DCMAKE_INSTALL_PREFIX=/${AIPREFIX} -DENABLE_LIBOPENJPEG=none .. && make VERBOSE=1 -j 1 install) || exit 1
#(cd /work/build/poppler-0.68.0 && rm -rf build && mkdir -p build && cd  build && FREETYPE_DIR=/${AIPREFIX} cmake -DCMAKE_INSTALL_PREFIX=/${AIPREFIX} -DENABLE_LIBOPENJPEG=none ..) || exit 1
fi


#pip install pygobject
#pip install pygtk
if [ ! -e /work/build/pygobject-2.28.7 ]; then
  (cd /work/build && rm -rf pygobject*  && wget https://ftp.acc.umu.se/pub/GNOME/sources/pygobject/2.28/pygobject-2.28.7.tar.xz && tar xvf pygobject-2.28.7.tar.xz && cd pygobject-2.28.7 && ./configure --prefix=/usr && make install) || exit 1
fi
if [ ! -e /work/build/pygtk-2.24.0 ]; then
  (cd /work/build && rm -rf pygtk* && wget https://ftp.acc.umu.se/pub/GNOME/sources/pygtk/2.24/pygtk-2.24.0.tar.bz2 && tar xvf pygtk-2.24.0.tar.bz2 && cd pygtk-2.24.0 && ./configure --prefix=/usr && make install) || exit 1
  #exit
fi

if [ ! -e /work/build/gexiv2-0.10.8 ]; then
  (cd /work/build && rm -rf gexiv2* && wget https://download.gnome.org/sources/gexiv2/0.10/gexiv2-0.10.8.tar.xz && tar xvf gexiv2-0.10.8.tar.xz && cd gexiv2-0.10.8 && ./configure --prefix=/${AIPREFIX} && make V=1 -j 2 install) || exit 1
fi


if [ ! -e /work/build/libcanberra-0.30 ]; then
(cd /work/build && rm -rf libcanberra* && wget http://0pointer.de/lennart/projects/libcanberra/libcanberra-0.30.tar.xz && tar xJvf libcanberra-0.30.tar.xz && cd libcanberra-0.30 && ./configure --prefix=/${AIPREFIX} --enable-gtk-doc=no --enable-gtk-doc-html=no --enable-gtk-doc-pdf=no && make -j 2 && make install && rm -rf libcanberra-0.30) || exit 1
fi


if [ ! -e /work/build/libmypaint-1.3.0 ]; then
  (cd /work/build && rm -rf libmypaint* && wget https://github.com/mypaint/libmypaint/releases/download/v1.3.0/libmypaint-1.3.0.tar.xz && tar xvf libmypaint-1.3.0.tar.xz && cd libmypaint-1.3.0 && ./configure --prefix=/${AIPREFIX} --disable-gegl && make -j 2 install) || exit 1
fi

if [ ! -e /work/build/mypaint-brushes ]; then
(cd /work/build && rm -rf mypaint-brushes && git clone -b v1.3.x https://github.com/Jehan/mypaint-brushes && cd mypaint-brushes && ./autogen.sh && ./configure --prefix=/${AIPREFIX} && make && make install && rm -rf mypaint-brushes) || exit 1
fi
