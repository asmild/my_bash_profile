#!/usr/bin/env bash

# ── Pre-flight checks ────────────────────────────────────────────────────────

if [ -z "${BASH_VERSION:-}" ]; then
  echo "error: this script requires bash" >&2
  echo "       run: bash <(curl -fsSL https://raw.githubusercontent.com/asmild/my_bash_profile/main/install.sh)" >&2
  exit 1
fi

bash_major="${BASH_VERSION%%.*}"
if [ "$bash_major" -lt 4 ]; then
  echo "error: bash 4.0+ required, you have $BASH_VERSION" >&2
  echo "" >&2
  case "$(uname -s)" in
    Darwin)
      echo "  macOS ships bash 3.2 due to licensing. To install a modern version:" >&2
      echo "" >&2
      echo "    1. Install Homebrew (if not already):" >&2
      echo "       /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\"" >&2
      echo "" >&2
      echo "    2. Install bash:" >&2
      echo "       brew install bash" >&2
      echo "" >&2
      echo "    3. Re-run the installer:" >&2
      echo "       /opt/homebrew/bin/bash <(curl -fsSL https://raw.githubusercontent.com/asmild/my_bash_profile/main/install.sh)" >&2
      ;;
    Linux)
      echo "  Install bash 4.0+ via your package manager:" >&2
      echo "" >&2
      echo "    Debian/Ubuntu:  sudo apt-get install bash" >&2
      echo "    Fedora/RHEL:    sudo dnf install bash" >&2
      echo "    Arch:           sudo pacman -S bash" >&2
      echo "" >&2
      echo "  Then re-run:" >&2
      echo "    bash <(curl -fsSL https://raw.githubusercontent.com/asmild/my_bash_profile/main/install.sh)" >&2
      ;;
    *)
      echo "  Please install bash 4.0+ and re-run:" >&2
      echo "    bash <(curl -fsSL https://raw.githubusercontent.com/asmild/my_bash_profile/main/install.sh)" >&2
      ;;
  esac
  echo "" >&2
  exit 1
fi

set -euo pipefail

REPO="asmild/my_bash_profile"
CORE_FILES=(.my_aliases .my_bash_profile)
BACKUP_SUFFIX=".bak_installing"

declare -A MODULES=(
  [git]="Git shortcuts (gs, gd, glog, gco...)"
  [docker]="Docker/Podman (dps, dcu, dcd, dreb...)"
  [k8s]="Kubernetes (k, kgp, kl, kex, kctx...)"
  [python]="Python (py, venv, activate, pipi...)"
  [node]="Node.js — npm/yarn/pnpm (ni, nr, yi, pi...)"
  [maven]="Maven (mvnci, mvncis, mvnt, mvncp...)"
  [network]="Network utils (ports, myip, headers...)"
  [process]="Process management (psg, topcpu, k9...)"
  [disk]="Disk usage (df, du1, biggest...)"
)
MODULE_ORDER=(git docker k8s python node maven network process disk)

# ── Environment detection ────────────────────────────────────────────────────

detect_profile() {
  if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "$HOME/.bash_profile"
  elif [ -f "$HOME/.bashrc" ]; then
    echo "$HOME/.bashrc"
  elif [ -f "$HOME/.bash_profile" ]; then
    echo "$HOME/.bash_profile"
  else
    echo "$HOME/.profile"
  fi
}

PROFILE=$(detect_profile)

echo "==> Detected environment"
echo "    bash:    $BASH_VERSION"
echo "    os:      $(uname -s)"
echo "    profile: $PROFILE"

# ── Version resolution ───────────────────────────────────────────────────────

echo "==> Fetching latest version"
latest_tag=$(curl -fsSL --connect-timeout 5 \
  "https://api.github.com/repos/${REPO}/tags" 2>/dev/null \
  | grep -o '"name": "[^"]*"' | head -1 | cut -d'"' -f4 || true)

if [ -n "$latest_tag" ]; then
  ref="$latest_tag"
  echo "    version: $ref"
else
  ref="main"
  echo "    no tags found, using main"
fi

installed=$(cat "$HOME/.mybash_version" 2>/dev/null || true)
skip_download=false
if [ -n "$installed" ] && [ "$installed" = "$ref" ] && [ "$ref" != "main" ]; then
  echo "    already up to date ($ref)"
  skip_download=true
fi

RAW="https://raw.githubusercontent.com/${REPO}/${ref}"

# ── Module selection ─────────────────────────────────────────────────────────

echo ""
echo "==> Select optional modules"
echo "    Core (always installed): navigation, safety nets, misc aliases"
echo ""

i=1
for module in "${MODULE_ORDER[@]}"; do
  printf "    [%d] %-10s %s\n" "$i" "$module" "${MODULES[$module]}"
  i=$((i + 1))
done

echo ""
printf "    Select modules (e.g. 1 2 3) or press Enter to skip all: "
read -r selection </dev/tty

SELECTED_MODULES=()
if [ -n "$selection" ]; then
  for num in $selection; do
    if [[ "$num" =~ ^[0-9]+$ ]] && [ "$num" -ge 1 ] && [ "$num" -le "${#MODULE_ORDER[@]}" ]; then
      SELECTED_MODULES+=("${MODULE_ORDER[$((num - 1))]}")
    fi
  done
fi

if [ ${#SELECTED_MODULES[@]} -gt 0 ]; then
  echo ""
  echo "    Installing modules: ${SELECTED_MODULES[*]}"
else
  echo ""
  echo "    No optional modules selected"
fi

# ── Backup & restore ─────────────────────────────────────────────────────────

ALL_FILES=("${CORE_FILES[@]}")
for module in "${SELECTED_MODULES[@]}"; do
  ALL_FILES+=(".my_aliases_${module}")
done

restore_backups() {
  echo "" >&2
  echo "error: install failed — restoring your files" >&2
  for f in "${ALL_FILES[@]}"; do
    local bak="$HOME/$f$BACKUP_SUFFIX"
    if [ -f "$bak" ]; then
      mv "$bak" "$HOME/$f"
      echo "  restored ~/$f" >&2
    fi
  done
}
trap restore_backups ERR

backup() {
  local src="$1"
  mv "$src" "${src}${BACKUP_SUFFIX}"
}

# ── Download ─────────────────────────────────────────────────────────────────

if [ "$skip_download" = false ]; then
  echo ""
  echo "==> Downloading dotfiles"
  for file in "${ALL_FILES[@]}"; do
    dst="$HOME/$file"
    [ -f "$dst" ] && backup "$dst"
    curl -fsSL "$RAW/$file" -o "$dst"
    if [ ! -s "$dst" ]; then
      echo "error: downloaded $file is empty" >&2
      exit 1
    fi
    echo "  $file"
  done

  # Success — rename temp backups to dated ones
  for f in "${ALL_FILES[@]}"; do
    bak="$HOME/$f$BACKUP_SUFFIX"
    [ -f "$bak" ] && mv "$bak" "$HOME/$f.bak.$(date +%Y%m%d%H%M%S)"
  done
  trap - ERR

  echo "$ref" > "$HOME/.mybash_version"
  rm -f "$HOME/.mybash_update_available"
fi

# ── Wire module sources into .my_bash_profile ────────────────────────────────

for module in "${SELECTED_MODULES[@]}"; do
  alias_file="$HOME/.my_aliases_${module}"
  source_line="[ -f ~/.my_aliases_${module} ] && source ~/.my_aliases_${module}"
  if grep -qF ".my_aliases_${module}" "$HOME/.my_bash_profile" 2>/dev/null; then
    echo "  .my_aliases_${module} — already wired, skipping"
  else
    echo "" >> "$HOME/.my_bash_profile"
    echo "$source_line" >> "$HOME/.my_bash_profile"
    echo "  .my_aliases_${module} — wired"
  fi
done

# ── Wire profile ─────────────────────────────────────────────────────────────

echo "==> Wiring $PROFILE"
if grep -qF "my_bash_profile" "$PROFILE" 2>/dev/null; then
  echo "  already wired, skipping"
else
  cat >> "$PROFILE" << 'EOF'

if [ -f ~/.my_bash_profile ]; then
    source ~/.my_bash_profile
fi
EOF
  echo "  done"
fi

echo ""
echo "Done ($ref)."
echo ""
echo "  Start a new terminal session — bash will be automatically configured."
echo "  Or reload the current session:  source $PROFILE"
