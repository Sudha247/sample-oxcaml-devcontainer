# sample-oxcaml-devcontainer

A minimal repository showing how to develop [OxCaml](https://oxcaml.org/)
in a [devcontainer](https://containers.dev/), on GitHub Codespaces or
locally, without compiling the compiler yourself.


## Introduction

[OxCaml](https://oxcaml.org/) is a compiler branch developed at [Jane
Street](https://www.janestreet.com/). It contains, along with traditional OCaml
features a set of fast moving extensions for performance critical aspects of
programming.

## Option 1: Install locally

To install and run OxCaml locally on your machine, follow the instructions
below. This will work on MacOS and Linux systems.

```bash
# 1. Install OPAM - OCaml's package manager

bash -c "sh <(curl -fsSL https://opam.ocaml.org/install.sh)"
opam init --yes

# 2. Create an OxCaml "switch". A compiler build of the OxCaml compiler.

opam switch create oxcaml \
  --repos "ox=git+https://github.com/oxcaml/opam-repository.git,default" \
  oxcaml-compiler.5.2.0minus39 --yes

# 3. Activate the compiler switch (run this again in every new shell)

eval $(opam env)

# 4. Install tools

opam install dune ocaml-lsp-server merlin utop

# 5. Test your installation

ocaml --version

# 6. Get this repository

git clone https://github.com/Sudha247/sample-oxcaml-devcontainer
cd sample-oxcaml-devcontainer

```

## Option 2: Run it on GitHub Codespaces (easiest)

Codespaces runs the container on GitHub's servers and gives you VS Code in
your browser. Nothing to install locally.

1. On the repository page, click **Code → Codespaces → Create codespace on
   main**.
2. Wait a minute or two. When the editor appears, a setup step
   (`postCreateCommand`) runs `dune build` automatically.
3. Open the terminal (**Terminal → New Terminal**) and run:

   ```bash
   $ ocaml --version
   ```

### When you're done

Personal GitHub accounts include 120 core-hours of Codespaces per month for
free, which is 60 hours on the default 2-core machine, plus 15 GB of storage.
That's plenty for trying OxCaml. A stopped Codespace doesn't use compute
hours, but it does keep using storage, so delete it once you're finished:

```bash
gh codespace delete
```

or on the repository page, **Code → Codespaces → ⋯ → Delete**. You can
always create a fresh one later; it takes a minute or two.

See [About billing for GitHub Codespaces](https://docs.github.com/en/billing/managing-billing-for-your-products/managing-billing-for-github-codespaces/about-billing-for-github-codespaces)
for the details.

## What we installed

- **OxCaml version:** `oxcaml-compiler.5.2.0minus39` from the
  [oxcaml opam repository](https://github.com/oxcaml/opam-repository).
- **Image:** `ghcr.io/sudha247/sample-oxcaml-devcontainer:latest`
  (linux/amd64 and linux/arm64), built from
  [`.devcontainer/Dockerfile`](.devcontainer/Dockerfile) by
  [`.github/workflows/build-image.yml`](.github/workflows/build-image.yml)
- **Tools in the image:** dune, ocaml-lsp-server, merlin (the `+ox` builds
  from the oxcaml repository), in an opam switch named `oxcaml`

## Hello world

[`bin/hello.ml`](bin/hello.ml) uses `stack_` and `exclave_`, two keywords
that only exist in OxCaml, so if it runs you know you're on the right
compiler.

```bash
dune build
dune exec bin/hello.exe
# Hello from OxCaml 5.2.0+ox! 20 + 22 = 42
```

## Credits

The Dockerfile and devcontainer layout follow
[tarides/ocaml-devcontainer](https://github.com/tarides/ocaml-devcontainer),
whose published `cuihtlauac/oxcaml-devcontainer` image is an alternative if
you do not want to build your own. The official
[oxcaml/playground](https://github.com/oxcaml/playground) Codespace is the
other reference setup.
