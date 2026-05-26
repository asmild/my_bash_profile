# mybash
Personal bash configuration — prompt, aliases, history, tab completion, and shell options.

## Requirements

- **bash 4.0+** — the installer will tell you if your version is too old.

macOS ships bash 3.2 by default. Install a modern version first:

```bash
# Install Homebrew if you don't have it
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install bash
brew install bash
```

Then open a new terminal session before running the installer.

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/asmild/my_bash_profile/main/install.sh | bash
```

The installer will ask which optional modules you want. Core aliases are always included.

Run the same command again to update. Any pre-existing files are backed up before being overwritten.

After installing, start a new terminal session — bash will be automatically configured with the correct PATH and settings. Or reload the current session manually:

```bash
source ~/.bash_profile
```

## Modules

During installation you'll see a menu like this:

```
==> Select optional modules
    Core (always installed): navigation, safety nets, misc aliases

    [1] git        Git shortcuts (gs, gd, glog, gco...)
    [2] docker     Docker/Podman (dps, dcu, dcd, dreb...)
    [3] k8s        Kubernetes (k, kgp, kl, kex, kctx...)
    [4] python     Python (py, venv, activate, pipi...)
    [5] node       Node.js — npm/yarn/pnpm (ni, nr, yi, pi...)
    [6] maven      Maven (mvnci, mvncis, mvnt, mvncp...)
    [7] network    Network utils (ports, myip, headers...)
    [8] process    Process management (psg, topcpu, k9...)
    [9] disk       Disk usage (df, du1, biggest...)
    [10] claude    Claude Code (cl, cc, clr, clp, cldsp...)

    Select modules (e.g. 1 2 3) or press Enter to skip all:
```

## Files

| File | Purpose |
|---|---|
| `.my_bash_profile` | Prompt, shell options, history, tab completion, colorized man pages |
| `.my_aliases` | Core aliases: navigation, safety nets, misc |
| `.my_aliases_git` | Git shortcuts |
| `.my_aliases_docker` | Docker/Podman shortcuts |
| `.my_aliases_k8s` | Kubernetes shortcuts |
| `.my_aliases_python` | Python/pip/venv shortcuts |
| `.my_aliases_node` | npm/yarn/pnpm shortcuts |
| `.my_aliases_maven` | Maven shortcuts |
| `.my_aliases_network` | Network utilities |
| `.my_aliases_process` | Process management |
| `.my_aliases_disk` | Disk usage utilities |
| `.my_aliases_claude` | Claude Code shortcuts |

## What's included

**Prompt**
- Shows `[HH:MM:SS] user working/dir [git-branch]` across two lines
- Git branch highlighted in green
- Exit code shown in red on failure: `[1] $`

**Tab completion**
- Show matches on first `Tab` (no double-tap needed)
- Case-insensitive, color-coded by file type

**Shell options**
- `autocd` — type a directory name to enter it
- `cdspell` / `dirspell` — typo correction for `cd`
- `globstar` — `**` for recursive globs
- `nocaseglob` — case-insensitive globbing

**History**
- 10 000 entries in memory, 20 000 on disk
- Timestamps stored with each entry
- No duplicates, commands with a leading space are excluded

**Aliases — core**

| Alias | Expands to |
|---|---|
| `ll` | `ls -lAFh` |
| `la` | `ls -A` |
| `..` / `...` / `....` | cd up 1/2/3 levels |
| `h` | `history` |
| `grep` | `grep --color=auto` |
| `reload` | `source ~/.bash_profile` |
| `aliases` | list all active aliases |

**Aliases — git**

| Alias | Expands to |
|---|---|
| `gs` | `git status` |
| `ga` | `git add` |
| `gc` / `gcam` | `git commit` / `git commit -am` |
| `gp` / `gl` | `git push` / `git pull` |
| `gd` | `git diff` |
| `gco` / `gswitch` | `git checkout` / `git switch` |
| `gb` | `git branch` |
| `glog` | `git log --oneline --graph --decorate -20` |

**Aliases — docker**

| Alias | Expands to |
|---|---|
| `docker` | `podman` |
| `dps` / `dpsa` | `docker ps` / `docker ps -a` |
| `dimg` | `docker images` |
| `dcu` / `dcd` | `docker compose up -d` / `docker compose down` |
| `dcl` | `docker compose logs -f` |
| `dreb` | `docker run -ti --rm --entrypoint=bash` |

**Aliases — k8s**

| Alias | Expands to |
|---|---|
| `k` | `kubectl` |
| `kgp` / `kgpa` | `kubectl get pods` / `--all-namespaces` |
| `kl` / `klf` | `kubectl logs` / `kubectl logs -f` |
| `kex` | `kubectl exec -it` |
| `kctx` | `kubectl config use-context` |
| `kaf` / `kdf` | `kubectl apply -f` / `kubectl delete -f` |

**Aliases — python**

| Alias | Expands to |
|---|---|
| `py` | `python3` |
| `venv` | `python3 -m venv .venv` |
| `activate` | `source .venv/bin/activate` |
| `pipi` / `pipr` | `pip install` / `pip install -r requirements.txt` |
| `pipf` | `pip freeze > requirements.txt` |

**Aliases — node**

| Alias | Expands to |
|---|---|
| `ni` / `nid` | `npm install` / `--save-dev` |
| `nr` / `nrs` / `nrb` / `nrt` | `npm run` + start/build/test |
| `yi` / `yr` | `yarn install` / `yarn run` |
| `pi` / `pr` | `pnpm install` / `pnpm run` |

**Aliases — maven**

| Alias | Expands to |
|---|---|
| `mvnc` | `mvn clean` |
| `mvni` | `mvn install` |
| `mvnci` | `mvn clean install` |
| `mvncis` | `mvn clean install -DskipTests` |
| `mvnt` | `mvn test` |
| `mvnp` / `mvncp` | `mvn package` / `mvn clean package` |
| `mvncps` | `mvn clean package -DskipTests` |
| `mvnver` | `mvn versions:display-dependency-updates` |

**Aliases — claude**

| Alias | Expands to |
|---|---|
| `cl` | `claude` |
| `cc` | `claude --continue` |
| `clr` | `claude --resume` |
| `clp` | `claude --print` |
| `cldsp` | `claude --dangerously-skip-permissions` |
| `clf` | `claude --print --dangerously-skip-permissions` |

**Aliases — network**

| Alias | Expands to |
|---|---|
| `ports` | show listening TCP ports |
| `myip` | your external IP |
| `localip` | your local IP |
| `ping` | `ping -c 5` |
| `headers` | `curl -sI` |
| `wget` | `curl -O` |

**Aliases — process**

| Alias | Expands to |
|---|---|
| `psa` | `ps aux` |
| `psg` | `ps aux \| grep` |
| `topcpu` / `topmem` | top 10 by CPU / memory |
| `k9` | `kill -9` |
| `ka` | `killall` |

**Aliases — disk**

| Alias | Expands to |
|---|---|
| `df` | `df -h` |
| `du` / `du1` | `du -h` / max depth 1 |
| `biggest` | top 20 largest items in current dir |
| `usage` | disk usage excluding tmpfs |

## Not tracked (sourced if present)

- `~/.my_credentials` — tokens and passwords
- `~/.my_variables` — machine-specific env vars and CDPATH

## For contributors

Use `setup.sh` to symlink all dotfiles from the repo into `~`:

```bash
bash setup.sh
```

Changes in the repo are reflected immediately without re-running setup.
