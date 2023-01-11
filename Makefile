PREFIX ?= /usr
SNAKE_SCRIPT ?= snake.sh

install:
	@printf "\e[0;34m>>>\e[0m wick3dr0se's snake project - A super minimal TUI snake game written in pure BASH v5.1+\n"
	@read -p ">>> Press ENTER to install snake. "
	@install -Dm755 -v $(SNAKE_SCRIPT) $(PREFIX)/local/bin/snake 
	@printf ">>> snake has been installed, you can execute it by typing snake."

uninstall:
	@printf "\e[0;34m>>>\e[0m wick3dr0se's snake project - A super minimal TUI snake game written in pure BASH v5.1+\n"
	@read -p ">>> Press ENTER to uninstall snake. "
	@rm -f $(PREFIX)/local/bin/snake
	@printf ">>> Snake has been uninstalled, thanks for using snake."

reinstall:
	@printf "\e[0;34m>>>\e[0m wick3dr0se's snake project - A super minimal TUI snake game written in pure BASH v5.1+\n"
	@read -p ">>> Press ENTER to reinstall snake. "
	@rm -f $(PREFIX)/local/bin/snake
	@install -Dm755 -v $(SNAKE_SCRIPT) $(PREFIX)/local/bin/snake
	@printf ">>> Snake has been reinstalled."



