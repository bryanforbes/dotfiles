export DISPLAY=":0.0"

# Add sensitive information to ~/.zshlocalrc
if [ -e "$HOME/.zshlocalrc" ]; then
	source "$HOME/.zshlocalrc"
fi
