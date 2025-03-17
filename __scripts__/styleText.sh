# Color name to code mapping
# Using function-based approach for macOS compatibility
function color_code() {
  case "$1" in
  "black") echo "30" ;;
  "red") echo "31" ;;
  "green") echo "32" ;;
  "yellow") echo "33" ;;
  "blue") echo "34" ;;
  "magenta") echo "35" ;;
  "cyan") echo "36" ;;
  "white") echo "37" ;;
  "gray") echo "90" ;;
  *) echo "" ;;
  esac
}

# Get available colors
function available_colors() {
  echo "black red green yellow blue magenta cyan white gray"
}

# Modifiers
BOLD=1
ITALIC=3
UNDERLINE=4
REVERSE=7
STRIKETHROUGH=9

styleText() {
  local MODIFIERS=""
  while [[ $# -gt 0 ]]; do
    if [[ "$1" != -* ]]; then
      break
    fi
    case "$1" in
    -b | --bold)
      MODIFIERS="${MODIFIERS};$BOLD"
      shift
      ;;
    -i | --italic)
      MODIFIERS="${MODIFIERS};$ITALIC"
      shift
      ;;
    -u | --underline)
      MODIFIERS="${MODIFIERS};$UNDERLINE"
      shift
      ;;
    -s | --strikethrough)
      MODIFIERS="${MODIFIERS};$STRIKETHROUGH"
      shift
      ;;
    -r | --reverse)
      MODIFIERS="${MODIFIERS};$REVERSE"
      shift
      ;;
    -c | --color)
      local COLOR_CODE=$(color_code "$2")
      if [[ -n "$2" && -n "$COLOR_CODE" ]]; then
        MODIFIERS="${MODIFIERS};$COLOR_CODE"
        shift 2
      else
        echo "Invalid color name: $2"
        echo "Available colors: $(available_colors)"
        return 1
      fi
      ;;
    --)
      shift
      break
      ;;
    *)
      echo
      echo
      printError "Unknown option: $0 '$(printCyan -i -- "$1")'"
      local help=""
      help+="Usage: styleText [OPTIONS] TEXT\n"
      help+="Options:\n"
      printf "$help"
      {
        echo "  $(printYellow -- -b), $(printYellow -- --bold)|$(printGray "Bold text")"
        echo "  $(printYellow -- -i), $(printYellow -- --italic)|$(printGray "Italic text")"
        echo "  $(printYellow -- -u), $(printYellow -- --underline)|$(printGray "Underline text")"
        echo "  $(printYellow -- -s), $(printYellow -- --strikethrough)|$(printGray "Strikethrough text")"
        echo "  $(printYellow -- -r), $(printYellow -- --reverse)|$(printGray "Reverse colors")"
        echo "  $(printYellow -- -c), $(printYellow -- --color)|$(printGray "Text color name ($(available_colors))")"
      } | column -t -s '|'
      echo $FORCE_NEW_LINE
      echo $FORCE_NEW_LINE
      exit 1
      ;;
    esac
  done
  local ANSI_ESCAPE=$(printf "\033[${MODIFIERS}m")
  local ANSI_END=$(printf "\033[m")
  printf "$ANSI_ESCAPE%s$ANSI_END" "$@"
}

printWhite() {
  styleText -c white "$@"
}

printCyan() {
  styleText -c cyan "$@"
}

printMagenta() {
  styleText -c magenta "$@"
}

printBlue() {
  styleText -c blue "$@"
}

printYellow() {
  styleText -c yellow "$@"
}

printGreen() {
  styleText -c green "$@"
}

printRed() {
  styleText -c red "$@"
}

printGray() {
  styleText -c gray "$@"
}

printInfo() {
  printf "[ $(printBlue "INFO") ] $@\n"
}

printWarn() {
  printf "[ $(printYellow "WARN") ] $@\n"
}

printError() {
  printf "[ $(printRed "ERROR") ] $@\n"
}

# Function that formats command output with a colored prompt
# Usage examples:
#   printCommand "git status"   => $ git status   # git is green, status is normal
#   printCommand ls -la         => $ ls -la       # ls is green, -la is normal
# The command name is displayed in green, the rest in normal text,
# with a bold green "$" prompt at the beginning
printCommand() {
  local command
  local rest
  if [[ "$1" == *" "* ]]; then
    # If $1 contains spaces, split it and capture the first part
    command="${1%% *}"
    # The rest becomes part of the arguments
    rest="${1#* }"
    shift
    rest="$rest $@"
  else
    # If $1 doesn't have spaces, capture it normally
    command=$1
    shift
    rest="$@"
  fi
  printf "$(printGreen -b "$") $(printGreen -- $command) $rest\n"
}

printCommandOutput() {
  printf "$(printGreen -b "$") $@\n"
  eval "$@" | while read -r line; do
    printf "  $line\n"
  done
}

log() {
  echo "$LOG_PREFIX $1"
}

logHeader() {
  echo "$LOG_PREFIX $(printMagenta -b -- "====== $1 ======")"
}

logInfo() {
  echo "$LOG_PREFIX [ $(printBlue -b INFO) ] $1"
}

logWarn() {
  echo "$LOG_PREFIX [ $(printYellow -b WARN) ] $1"
}

logSuccess() {
  echo "$LOG_PREFIX [ $(printGreen -b SUCCESS) ] $1"
}

logError() {
  echo "$LOG_PREFIX [ $(printRed -b ERROR) ] $1"
}
