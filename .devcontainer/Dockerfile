# OxCaml development image
#
# Built and published to GHCR by .github/workflows/build-image.yml.
# Codespaces and VS Code pull the published image via devcontainer.json,
# so nobody has to compile OxCaml on first open.
#
# To bump OxCaml, change OXCAML_COMPILER to another version from
# https://github.com/oxcaml/opam-repository/tree/main/packages/oxcaml-compiler
# (5.2.0minusNN releases report themselves as 5.2.0+ox; 5.4.0-oxN as 5.4.0+ox).

FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04

ARG OXCAML_COMPILER=5.2.0minus39
ARG OXCAML_SWITCH=oxcaml

LABEL org.opencontainers.image.description="OxCaml ${OXCAML_COMPILER} devcontainer"
LABEL org.opencontainers.image.licenses="MIT"

ENV DEBIAN_FRONTEND=noninteractive

# Build prerequisites for the OxCaml compiler (autoconf is required by the
# oxcaml-compiler package) plus the usual C libraries opam packages want.
RUN apt-get update && apt-get install -y --no-install-recommends \
      build-essential m4 autoconf automake libtool pkg-config \
      libunwind-dev libgmp-dev libffi-dev libssl-dev zlib1g-dev \
      git curl wget unzip rsync bubblewrap \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# opam 2.x from the official installer script
RUN curl -fsSL https://raw.githubusercontent.com/ocaml/opam/master/shell/install.sh \
    | bash -s -- --no-backup

USER vscode
WORKDIR /home/vscode

# --bare: no default switch; --disable-sandboxing: bwrap does not work in containers
RUN opam init --disable-sandboxing --bare --yes

# The OxCaml compiler and its tooling live in the oxcaml opam repository,
# layered on top of the default repository.
RUN opam switch create "${OXCAML_SWITCH}" \
      --repos "ox=git+https://github.com/oxcaml/opam-repository.git,default" \
      "oxcaml-compiler.${OXCAML_COMPILER}" --yes

RUN opam install -y dune ocaml-lsp-server merlin \
    && opam clean -a --yes

RUN echo 'eval $(opam env)' >> /home/vscode/.bashrc \
    && if [ -f /home/vscode/.zshrc ]; then echo 'eval $(opam env)' >> /home/vscode/.zshrc; fi

CMD ["/bin/bash"]
