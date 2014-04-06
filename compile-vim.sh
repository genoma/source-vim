#!/bin/bash

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
  patch ~/vim/src/auto/configure < ~/.vim/brew-python.patch
fi

echo ""
echo "$(tput setaf 1) $(tput bold)There are 3 possible Vim compile configuration: $(tput sgr 0)"
echo "$(tput setaf 1) $(tput bold) - *1) Complete -> Python/Ruby/Lua/Perl $(tput sgr 0)"
echo "$(tput setaf 1) $(tput bold) - *2) Essential -> Python $(tput sgr 0)"
echo "$(tput setaf 1) $(tput bold) - *3) Minimal $(tput sgr 0)"
echo ""
echo -n "$(tput setaf 1)What version would you like to compile? $(tput bold)[1/$(tput setaf 4)2$(tput setaf 1)/3] $(tput sgr 0)"
read compile


echo ""
if [ "$compile" == 1 ]; then
  # complete compilation with lua/ruby/python/perl
  ./configure --enable-multibyte\
              --with-tlib=ncurses\
              --with-features=huge\
              --enable-rubyinterp\
              --enable-luainterp\
              --with-lua-prefix=/opt/local\
              --enable-perlinterp\
              --enable-pythoninterp\
              --enable-gui=no\
              --without-x\
              --disable-netbeans\
              --disable-nls\
              --with-compiledby=jenoma@gmail.com\
              --enable-fail-if-missing
elif [ "$compile" == 3 ]; then
  # minimal compilation with huge no lua/ruby/python
  ./configure --enable-multibyte --with-tlib=ncurses --with-features=huge --enable-gui=no --without-x --disable-netbeans --with-compiledby=jenoma@gmail.com --enable-fail-if-missing
else
  # essential compilation whith everything needed for the used plugins
  ./configure --enable-multibyte\
              --with-tlib=ncurses\
              --with-features=huge\
              --with-lua-prefix=/opt/local\
              --enable-pythoninterp\
              --enable-gui=no\
              --without-x\
              --disable-netbeans\
              --disable-nls\
              --with-compiledby=jenoma@gmail.com\
              --enable-fail-if-missing
fi

echo ""
echo "$(tput setaf 1)$(tput bold)COMPILING AND INSTALLING VIM$(tput sgr 0)"
echo ""

make && make install
