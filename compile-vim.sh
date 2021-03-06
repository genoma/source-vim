#!/bin/bash

cp brew-python.patch ~/vim
cd ~/vim

echo ""
echo -n "$(tput setaf 1)Update Vim sources? $(tput bold)[Y/n] $(tput sgr 0)"
read update

if [ "$update" != "n" ]; then
  hg up -C
  hg pull
  hg update
  make clean
  make distclean
fi

echo ""
echo -n "$(tput setaf 1)Apply patch for Homebrew Python? $(tput bold)[Y/n] $(tput sgr 0)"
read python

if [ "$python" != "n" ]; then
  patch ~/vim/src/auto/configure < brew-python.patch
  rm brew-python.patch
else
  rm brew-python.patch
fi

echo ""
echo "$(tput setaf 1) $(tput bold)There are 4 possible Vim compile configuration: $(tput sgr 0)"
echo "$(tput setaf 1) $(tput bold) - *1) Complete -> Python/Ruby/Lua $(tput sgr 0)"
echo "$(tput setaf 1) $(tput bold) - *2) Essential -> Python $(tput sgr 0)"
echo "$(tput setaf 1) $(tput bold) - *3) Lua $(tput sgr 0)"
echo "$(tput setaf 1) $(tput bold) - *4) Minimal $(tput sgr 0)"
echo ""
echo -n "$(tput setaf 1)What version would you like to compile? $(tput bold)[1/$(tput setaf 4)2$(tput setaf 1)/3/4] $(tput sgr 0)"
read compile


echo ""
if [ "$compile" == "1" ]; then
  # complete compilation with lua/ruby/python
  ./configure --enable-multibyte\
              --with-tlib=ncurses\
              --with-features=huge\
              --enable-rubyinterp\
              --enable-luainterp\
              --with-lua-prefix=/usr/local\
              --enable-pythoninterp\
              --enable-gui=no\
              --without-x\
              --disable-netbeans\
              --disable-nls\
              --with-compiledby=jenoma@gmail.com\
              --enable-fail-if-missing
elif [ "$compile" == "3" ]; then
  # Lua compilation
  ./configure --enable-multibyte\
              --with-tlib=ncurses\
              --with-features=huge\
              --enable-luainterp\
              --with-lua-prefix=/usr/local\
              --enable-gui=no\
              --without-x\
              --disable-netbeans\
              --disable-nls\
              --with-compiledby=jenoma@gmail.com\
              --enable-fail-if-missing
elif [ "$compile" == "4" ]; then
  # minimal compilation with huge no lua/ruby/python
  ./configure --enable-multibyte\
              --with-tlib=ncurses\
              --with-features=huge\
              --enable-gui=no\
              --without-x\
              --disable-netbeans\
              --with-compiledby=jenoma@gmail.com\
              --enable-fail-if-missing
else
  # essential compilation whith just Homebrew Python 2.7.X
  ./configure --enable-multibyte\
              --with-tlib=ncurses\
              --with-features=huge\
              --enable-pythoninterp\
              --enable-gui=no\
              --without-x\
              --disable-netbeans\
              --disable-nls\
              --with-compiledby=jenoma@gmail.com\
              --enable-fail-if-missing
fi

echo ""
echo -n "$(tput setaf 1)Shall we proceed with compiling Vim? $(tput bold)[Y/n] $(tput sgr 0)"
read compile

if [ "$compile" != "n" ]; then
  echo ""
  echo "$(tput setaf 1)$(tput bold)COMPILING AND INSTALLING VIM$(tput sgr 0)"
  echo ""
  make
  make install
else
  echo ""
  echo "$(tput setaf 1)$(tput bold)ABORTED!$(tput sgr 0)"
  echo ""
fi
