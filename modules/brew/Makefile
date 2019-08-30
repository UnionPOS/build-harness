BREW_APPNAME = $(notdir $(shell pwd))
BREW_TAPNAME ?= tap

ifeq '$(findstring ;,$(PATH))' ';'
	detected_OS := Windows
else
	detected_OS := $(shell uname 2>/dev/null || echo Unknown)
	detected_OS := $(patsubst CYGWIN%,Cygwin,$(detected_OS))
	detected_OS := $(patsubst MSYS%,MSYS,$(detected_OS))
	detected_OS := $(patsubst MINGW%,MSYS,$(detected_OS))
endif

# OSX Specific targets
ifeq ($(detected_OS),Darwin)

/usr/local/bin/brew:
	ruby -e "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	brew analytics off

.PHONY: brew
brew: /usr/local/bin/brew \
	brew/bundle

brew/bundle:
	brew bundle --file=Brewfile.osx

endif

# Linux specific targets
ifeq ($(detected_OS),Linux)

/usr/local/bin/brew:
	echo "linux implementation not finished"
	# sh -c "$$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
	# TODO: shits all broke camp - fix this
	# test -d ~/.linuxbrew && PATH="$$HOME/.linuxbrew/bin:$$HOME/.linuxbrew/sbin:$$PATH"
	# test -d /home/linuxbrew/.linuxbrew && PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:$$PATH"
	# test -r ~/.bash_profile && echo "export PATH='$$(brew --prefix)/bin:$$(brew --prefix)/sbin'":'"$$PATH"' >>~/.bash_profile
	# echo "export PATH='$$(brew --prefix)/bin:$$(brew --prefix)/sbin'":'"$$PATH"' >>~/.profile

.PHONY: brew
brew: /usr/local/bin/brew \
	brew/bundle

brew/bundle:
	echo "linux implementation not finished"
	# brew bundle --file=Brewfile.lin

endif

## brew install $(PROJNAME)
brew/install:
	brew install $(BUILD_HARNESS_ORG)/$(BREW_TAPNAME)/$(BREW_APPNAME)

## brew remove $(PROJNAME)
brew/remove:
	brew remove $(BUILD_HARNESS_ORG)/$(BREW_TAPNAME)/$(BREW_APPNAME)

brew/update:
	brew cask upgrade; brew upgrade
