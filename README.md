# solnix-cli

A command-line toolkit for building and managing **Solnix language projects** — from creation to compilation and deployment into eBPF targets.

---

## Features

- Create new Solnix projects
- Compile Solnix code to eBPF bytecode
- Manage build targets and configurations
- Interactive help and autocompletion
- Cross-platform support via Zig

---

## Installation

```sh
# Clone
git clone https://github.com/solnix-lang/solnix-cli.git
cd solnix-cli

# Build
zig build install

# Check version
solnix-cli --version
