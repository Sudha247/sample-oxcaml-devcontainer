# sample-oxcaml-devcontainer

A minimal repository showing how to develop [OxCaml](https://oxcaml.org/)
in a [devcontainer](https://containers.dev/), on GitHub Codespaces or
locally, without compiling the compiler yourself.

- **OxCaml version:** `5.4.0+ox` (compiler release `5.4.0-ox7`, from the
  [oxcaml opam repository](https://github.com/oxcaml/opam-repository))
- **Image:** `ghcr.io/sudha247/sample-oxcaml-devcontainer:latest`
  (linux/amd64 and linux/arm64), built from
  [`.devcontainer/Dockerfile`](.devcontainer/Dockerfile) by
  [`.github/workflows/build-image.yml`](.github/workflows/build-image.yml)
- **Tools in the image:** dune, ocaml-lsp-server, merlin
  (all the `+ox` builds from the oxcaml repository), in an opam switch
  named `oxcaml`

## Hello world

[`bin/hello.ml`](bin/hello.ml) uses `stack_` and `exclave_`, two OxCaml-only
keywords for stack allocation, so it only builds on OxCaml.

```bash
dune build
dune exec bin/hello.exe
# Hello from OxCaml 5.4.0+ox! 20 + 22 = 42
```

## Run it on GitHub Codespaces

1. Push this repository to GitHub. The image name in
   `.devcontainer/devcontainer.json` assumes `github.com/Sudha247/sample-oxcaml-devcontainer`;
   change it if the repository lives somewhere else.
2. Wait for the **Build devcontainer image** workflow to finish (around
   30 to 45 minutes the first time, since it compiles OxCaml from source for
   both architectures). It runs on every push that touches the Dockerfile,
   weekly, and on demand from the Actions tab.
3. Make the package visible to Codespaces. The simplest option is to set it
   to **Public** under *Packages → sample-oxcaml-devcontainer → Package
   settings*. (A package pushed by this repository's own workflow is also
   linked to the repository, which is enough for Codespaces on a private
   package.)
4. On the repository page click **Code → Codespaces → Create codespace on
   main**. The container starts in a minute or two and `postCreateCommand`
   runs `dune build`.
5. In the Codespace terminal:

   ```bash
   dune exec bin/hello.exe
   ```

## Run it locally

With VS Code and the Dev Containers extension: open the folder and choose
**Reopen in Container**.

With the [devcontainer CLI](https://github.com/devcontainers/cli):

```bash
devcontainer up --workspace-folder .
devcontainer exec --workspace-folder . dune exec bin/hello.exe
```

Or with plain Docker:

```bash
docker run --rm -it -v "$PWD:/work" -w /work \
  ghcr.io/sudha247/sample-oxcaml-devcontainer:latest \
  bash -lc 'dune build && dune exec bin/hello.exe'
```

## Updating OxCaml

Change `OXCAML_VARIANT` in `.devcontainer/Dockerfile` to a newer
`ocaml-variants` version from the oxcaml opam repository and push. The
workflow rebuilds and republishes the image.

To build the image locally instead of pulling it:

```bash
docker build -t sample-oxcaml-devcontainer .devcontainer
```

## Credits

The Dockerfile and devcontainer layout follow
[tarides/ocaml-devcontainer](https://github.com/tarides/ocaml-devcontainer),
whose published `cuihtlauac/oxcaml-devcontainer` image is a good choice if
OxCaml `5.2.0+ox` is enough for you. The official
[oxcaml/playground](https://github.com/oxcaml/playground) Codespace is the
other reference setup.
