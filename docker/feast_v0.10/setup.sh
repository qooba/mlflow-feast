#!/usr/bin/env bash
wrapper() {
  # Colors
  RED="\033[0;31m"
  GREEN="\033[0;32m"
  YELLOW="\033[0;33m"
  BLUE="\033[0;36m"
  NORMAL="\033[0m"

  # Links
  REPO_HTTPS="https://github.com/qooba/vim-python-ide.git"
  VUNDLE_HTTPS="https://github.com/VundleVim/Vundle.vim.git"
  PYTHON_INSTALL="https://realpython.com/installing-python/"
  GIT_INSTALL="https://git-scm.com/book/en/v2/Getting-Started-Installing-Git"
  CMAKE_INSTALL="https://cmake.org/install/"
  GIT_TS="https://www.codementor.io/@citizen428/git-tutorial-10-common-git-problems-and-how-to-fix-them-aajv0katd"
  YCM_COMPILE="https://github.com/ycm-core/YouCompleteMe#installation"
  YCM_INSTALL="https://vimawesome.com/plugin/youcompleteme#installation"

  echo "${NORMAL}"

  # Determine System Type 
  unameOut="$(uname -s)"
  case "${unameOut}" in
      Linux*)     machine=LINUX;;
      Darwin*)    machine=MAC;;
      CYGWIN*)    machine=CYGWIN;;
      MINGW*)     machine=MINGW;;
      *)          machine=UNKNOWN;;
  esac
  SYS_TYPE=${machine}

  # Run System Requirement Checks
  printf "${BLUE}%s${NORMAL}\n" "Checking for system requirements."

  # System Requirement Helper Function
  open_info() {
    case $SYS_TYPE in
        LINUX)  xdg-open $1;;
        MAC)    open $1;;
        CYGWIN) cygstart $1;;
        *)      echo "For More Information: $1";;
    esac
  }

  # Git is required
  hash git >/dev/null 2>&1 || {
    printf "${RED}%s${NORMAL}\n" "Error: git is not installed."
    open_info $GIT_INSTALL
    exit 1
  }

  # Cmake is required
  hash cmake >/dev/null 2>&1 || {
    printf "${RED}%s${NORMAL}\n" "Error: cmake is not installed."
    open_info $CMAKE_INSTALL
    exit 1
  }

  # Python >= 3 is required
  hash python3 >/dev/null 2>&1 || {
    printf "${RED}%s${NORMAL}\n" "Error: python3 is not installed"
    open_info $PYTHON_INSTALL
    exit 1
  }

  if [ ! -n "$VIM" ]; then
    VIM=~/.vim
  fi

  # Check for existing .vim directory
  # Installation connot continue until this directory is removed
  if [ -d "$VIM" ]; then
    VIM_OLD=~/.vim-backup
    printf "${YELLOW}%s${NORMAL}\n" "You already have a $VIM config directory."
    printf "${YELLOW}%s${NORMAL}\n" "You must move/delete this directory in order to install."
    printf "${YELLOW}%s${NORMAL}\n" "Automatically move $VIM directory to $VIM_OLD?: <y/n>"
    # Ask for input
    while true; do
        read yn
        case $yn in
            # Continue: User has entered Yes
            [Yy]* ) # Check for existing ~/.vim-backup
                    if [ -d "$VIM_OLD" ]; then
                        printf "${YELLOW}%s${NORMAL}\n" "You already have a $VIM_OLD config directory."
                        printf "${YELLOW}%s${NORMAL}\n" "You must remove this directory in order to install."
                        printf "${YELLOW}%s${NORMAL}\n" "Automatically delete $VIM_OLD directory: <y/n>"
                        
                        # Ask for input to delete ~/.vim-backup
                        while true; do
                            read ny
                            case $ny in
                                # Continue: User has entered Yes
                                [Yy]* ) rm -rf $VIM_OLD && mkdir $VIM_OLD && mv $VIM $VIM_OLD || {
                                            printf "${RED}%s${NORMAL}\n" "Error: Failed to delete $VIM_OLD directory."
                                            printf "${RED}%s${NORMAL}\n" "Installation cannot continue until this is done."
                                        };
                                        break;;
                                # Exit: User has entered No
                                [Nn]* )
                                    printf "${RED}%s${NORMAL}\n" "Please manually delete the $VIM_OLD directory"
                                    printf "${RED}%s${NORMAL}\n" "After doing so, run the script again."
                                    exit;;
                                # Invalid Input
                                * )     echo "Please answer yes or no: <y/n>";;
                            esac
                        done
                    
                    # Continue: There is no ~/.vim-backup
                    else
                        mkdir $VIM_OLD && mv $VIM $VIM_OLD  || {
                            printf "${RED}%s${NORMAL}\n" "Error: Failed to move $VIM directory."
                            printf "${RED}%s${NORMAL}\n" "Installation cannot continue until this is done."
                        }; 
                    fi
                    break;;

            # Exit: User has entered No
            [Nn]* )
                    printf "${RED}%s${NORMAL}\n" "Please manually delete/move the $VIM directory"
                    printf "${RED}%s${NORMAL}\n" "After doing so, run the script again."
                    exit;;
            # Invalid Input
            * )     echo "Please answer yes or no: <y/n>";;
        esac
    done
  fi 

  # Prevent the cloned repository from having insecure permissions. Failing to do
  # so causes compinit() calls to fail with "command not found: compdef" errors
  # for users with insecure umasks (e.g., "002", allowing group writability). Note
  # that this will be ignored under Cygwin by default, as Windows ACLs take
  # precedence over umasks except for filesystems mounted with option "noacl".
  umask g-w,o-w

  # Clone VIMRC
  printf "${BLUE}%s${NORMAL}\n" "Cloning vimrc from ${REPO_HTTPS}"
  env git clone --depth=1 $REPO_HTTPS $VIM || {
    printf "${RED}%s${NORMAL}\n" "Error: git clone of vimrc repo failed."
    open_info $GIT_TS
    exit 1
  }

  # Check for an existing vimrc config
  printf "${BLUE}%s${NORMAL}\n" "Looking for an existing vim config..."
  if [ -f ~/.vimrc ] || [ -h ~/.vimrc ]; then
    printf "${YELLOW}%s${NORMAL}\n" "Found ~/.vimrc."
    printf "${BLUE}%s${NORMAL}\n" "You will see your old ~/.vimrc as $VIM/vimrc.bak"
    mv ~/.vimrc $VIM/vimrc.bak
  fi

  # Symlink vimrc files
  printf "${BLUE}%s${NORMAL}\n" "Symlinking $VIM/vimrc with ~/.vimrc..."
  ln -fs $VIM/vimrc ~/.vimrc

  # Symlink tmux.conf files
  printf "${BLUE}%s${NORMAL}\n" "Symlinking $VIM/tmux.conf with ~/.tmux.conf..."
  ln -fs $VIM/tmux.conf ~/.tmux.conf

  # Install Bundle
  if [ ! -d "$VIM/bundle/Vundle.vim" ]; then
      printf "${BLUE}%s${NORMAL}\n" "Installing Vundle..."
      env git clone --depth=1 $VUNDLE_HTTPS "$VIM/bundle/Vundle.vim"
  fi

  # Install colorscheme
  if [ ! -f $VIM/colors/wombat256mod.vim ]; then
      if [ ! -d $VIM/colors/ ]; then
          mkdir -p $VIM/colors
      fi
      curl -L 'http://www.vim.org/scripts/download_script.php?src_id=13400' -o $VIM/colors/wombat256mod.vim
  fi
}

wrapper

# Automated PluginInstall and YouCompleteMe Compile
vim +PluginInstall +quitall
#if [ -d "$VIM/bundle/YouCompleteMe" ]; then
#    cd $VIM/bundle/YouCompleteMe && git checkout d98f896 && python3 install.py --clang-completer || {
#        echo "Failed to compile YouCompleteMe."
#        echo "You must compile it yourself in order to use its completion service."
#        open_info $YCM_COMPILE
#    }
#else
#    echo "YouCompleteMe was not found in your $VIM bundle directory."
#    echo "Install this plugin and then compile it in order to use its completion service."
#    open_info $YCM_INSTALL
#fi
# vim
