#!/bin/bash

#SBATCH -p hsph
#SBATCH --mem=24g
#SBATCH --time=04:00:00
#SBATCH -c 4

#SBATCH --output=/n/holylabs/LABS/cgolden_lab/Lab/frontier/works/prospectors/prospectorMahery/slurm/launch/logs/launch_%j.out
#SBATCH --error=/n/holylabs/LABS/cgolden_lab/Lab/frontier/works/prospectors/prospectorMahery/slurm/launch/logs/launch_%j.err

set -o errexit -o nounset -o pipefail

PROJECT_DIR="${PROJECT_DIR:-$SLURM_SUBMIT_DIR}"
PROJECT_NAME="$(basename "$PROJECT_DIR")"
TUNNEL_NAME="${TUNNEL_NAME:-${PROJECT_NAME}-tunnel}"

SIF="${SIF:-/n/holylabs/LABS/cgolden_lab/Lab/containers/prospector-mahery_amd64.sif}"

DATA_DIR="${DATA_DIR:-$PROJECT_DIR/data}"
RV_CACHE_DIR="${RV_CACHE_DIR:-/n/holylabs/LABS/cgolden_lab/Lab/cache/rv}"
RENV_CACHE_DIR="${RENV_CACHE_DIR:-/n/holylabs/LABS/cgolden_lab/Lab/cache/renv}"
CONTAINER_HOME="${CONTAINER_HOME:-$PROJECT_DIR/.container-home}"
VSCODE_SERVER_DIR="${VSCODE_SERVER_DIR:-$PROJECT_DIR/.vscode-server}"

mkdir -p "$PROJECT_DIR/slurm/launch/logs"
mkdir -p "$RV_CACHE_DIR" "$RENV_CACHE_DIR" "$CONTAINER_HOME" "$VSCODE_SERVER_DIR"

cd "$PROJECT_DIR"

MY_SCRATCH=$(TMPDIR=/scratch mktemp -d)
trap 'rm -rf "$MY_SCRATCH"' EXIT

echo "================= Container VS Code Tunnel Launch ================="
echo "Date:          $(date)"
echo "Host:          $(hostname)"
echo "User:          $(whoami)"
echo "SLURM_JOB_ID:  ${SLURM_JOB_ID}"
echo "Project:       ${PROJECT_DIR}"
echo "SIF:           ${SIF}"
echo "Data:          ${DATA_DIR}"
echo "rv cache:      ${RV_CACHE_DIR}"
echo "renv cache:    ${RENV_CACHE_DIR}"
echo "Container home:${CONTAINER_HOME}"
echo "VS Code dir:   ${VSCODE_SERVER_DIR}"
echo "Tunnel:        ${TUNNEL_NAME}"
echo "Scratch:       ${MY_SCRATCH}"
echo "===================================================================="

module purge

BIND_ARGS=(
  --bind "$PROJECT_DIR:/work"
  --bind "$CONTAINER_HOME:/home/vscode"
  --bind "$RV_CACHE_DIR:/cache/rv"
  --bind "$RENV_CACHE_DIR:/cache/renv"
  --bind "$VSCODE_SERVER_DIR:/home/vscode/.vscode-server"
  --bind "$MY_SCRATCH:/scratch"
)

if [ -d "$DATA_DIR" ]; then
  BIND_ARGS+=(--bind "$DATA_DIR:/data:ro")
fi

singularity exec \
  --cleanenv \
  --home "$CONTAINER_HOME:/home/vscode" \
  "${BIND_ARGS[@]}" \
  --pwd /work \
  "$SIF" \
  env -i \
    HOME=/home/vscode \
    USER="$USER" \
    LOGNAME="$USER" \
    SHELL=/bin/bash \
    TMPDIR=/scratch \
    RV_HOME=/cache/rv \
    RENV_PATHS_CACHE=/cache/renv \
    RENV_CONFIG_AUTOLOADER_ENABLED=false \
    VSCODE_CLI_DISABLE_KEYCHAIN_ENCRYPT=1 \
    PATH=/home/vscode/.local/bin:/home/vscode/.cargo/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
    bash --noprofile --norc -c '
      set -o errexit -o nounset -o pipefail

      echo "================= Inside Container ================="
      echo "Date:        $(date)"
      echo "Host:        $(hostname)"
      echo "User:        $(whoami)"
      echo "PWD:         $(pwd)"
      echo "HOME:        $HOME"
      echo "PATH:        $PATH"
      echo "TMPDIR:      ${TMPDIR:-unset}"
      echo "RV_HOME:     ${RV_HOME:-unset}"
      echo "RENV cache:  ${RENV_PATHS_CACHE:-unset}"
      echo "===================================================="

      echo "================= Tool SitRep ======================"
      echo "R:       $(command -v R)"
      R --version | head -n 1

      echo "Rscript: $(command -v Rscript)"
      echo "rv:      $(command -v rv || true)"
      rv --version || true

      echo "arf:     $(command -v arf || true)"
      arf --version || true

      echo "code:    $(command -v code)"
      code --version

      echo "gcc:     $(command -v gcc || true)"
      gcc --version | head -n 1 || true
      echo "===================================================="

      echo "Starting VS Code tunnel: '"$TUNNEL_NAME"'"

      code tunnel user login --provider github || true

      exec code tunnel \
        --accept-server-license-terms \
        --name "'"$TUNNEL_NAME"'"
    '