set nocompatible              " be iMproved, required
filetype off                  " required

" Set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Required Vundle plugin
Plugin 'VundleVim/Vundle.vim'	

" === Plugins ===

Plugin 'tpope/vim-fugitive'
Plugin 'vim-airline/vim-airline'
Plugin 'scrooloose/syntastic'

call vundle#end()            " required
filetype plugin indent on    " required

" === Other Settings ===

syntax on
set number
