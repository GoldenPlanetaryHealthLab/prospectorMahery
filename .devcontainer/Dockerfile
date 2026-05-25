FROM rocker/r-ver:4.5.1

# setup args
ARG DEBIAN_FRONTEND=noninteractive
ARG ARF_VERSION=0.3.0
ARG TARGETARCH

RUN echo " ============= Starting Container Setup ============= "
RUN echo " ===== Installing System Libraries and Tooling ====== "
RUN apt-get update && apt-get install -y --no-install-recommends \
    bash \
    zsh \
    curl \
    wget \
    ca-certificates \
    git \
    build-essential \
    pkg-config \
    cmake \
    ninja-build \
    cargo \
    tmux \
    ripgrep \
    fd-find \
    fzf \
    tree-sitter-cli \
    unzip \
    xz-utils \
    less \
    locales \
    libssl-dev \
    libcurl4-openssl-dev \
    libxml2-dev \
    libgit2-dev \
    libfontconfig1-dev \
    libfreetype6-dev \
    libpng-dev \
    libtiff5-dev \
    libjpeg-dev \
    libcairo2-dev \
    libxt-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    libglpk-dev \
    gdebi \
    && rm -rf /var/lib/apt/lists/*

RUN ln -sf "$(command -v fdfind)" /usr/local/bin/fd || true

RUN echo "======= Installing arf ========="
RUN set -eux; \
    case "${TARGETARCH:-amd64}" in \
      amd64) ARF_ARCH="x86_64-unknown-linux-gnu" ;; \
      arm64) ARF_ARCH="aarch64-unknown-linux-gnu" ;; \
      *) echo "Unsupported TARGETARCH: ${TARGETARCH}" >&2; exit 1 ;; \
    esac; \
    curl -fsSL \
      "https://github.com/eitsupi/arf/releases/download/v${ARF_VERSION}/arf-console-${ARF_ARCH}.tar.xz" \
      -o /tmp/arf.tar.xz; \
    mkdir -p /tmp/arf; \
    tar -xJf /tmp/arf.tar.xz -C /tmp/arf; \
    find /tmp/arf -type f -name 'arf' -exec install -m 0755 {} /usr/local/bin/arf \;; \
    rm -rf /tmp/arf /tmp/arf.tar.xz
RUN arf --version

# Debian names fd as fdfind; expose fd
RUN ln -sf "$(command -v fdfind)" /usr/local/bin/fd || true

# Quarto
# TODO this quarto is intended to run on FASRC linux Arch, so
# TODO for now it will be tested on Arm 
RUN echo "Installing Quarto..."
# RUN curl -LO https://quarto.org/download/latest/quarto-linux-amd64.deb
# RUN gdebi --non-interactive quarto-linux-amd64.deb
# RUN quarto check

# setup the vscode user and workspace
RUN id -u vscode >/dev/null 2>&1 || useradd -m -s /bin/bash vscode
USER vscode
WORKDIR /home/vscode

ENV PATH="/home/vscode/.local/bin:/home/vscode/.cargo/bin:${PATH}"
RUN command -v arf && arf --version

# One user-local tool prefix, like FASRC/local-machine practice
ENV PATH="/home/vscode/.local/bin:/home/vscode/.cargo/bin:${PATH}"
RUN mkdir -p ~/.local/bin ~/.cargo


# Neovim stable-ish binary
# RUN wget -q https://github.com/neovim/neovim/releases/download/v0.11.3/nvim-linux-x86_64.tar.gz \
#     && tar xzf nvim-linux-x86_64.tar.gz -C /opt \
#     && ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim \
#     && rm nvim-linux-x86_64.tar.gz


RUN echo "========= Project Package Managers ==========="
RUN curl -sSL https://raw.githubusercontent.com/A2-ai/rv/refs/heads/main/scripts/install.sh | bash
RUN rv --version

# # Development Environment packages

# # Core R packages for Quarto/R package development
# RUN rv init
# RUN rv sync

# health check
RUN echo "============= Running Health Check ============="
RUN echo "Checking Quarto installation..."
RUN echo "will run quarto check when we are on arm64"
RUN echo "=========== Container Setup Complete ==========="

RUN echo "============== Setting Up Project =============="
RUN echo "Installing project dependencies..."

RUN echo "will run quarto check when we are on arm64"
RUN echo "=========== Container Setup Complete ==========="