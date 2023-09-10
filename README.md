# dotfiles
These are my dotfiles. This repo uses [stow][] to manage symlinks. To use stow, git clone this repo and do:

Install with [just][]

```sh
cd dotfiles
just install 
```

If you do not have [just][] installed. You can manually run the command with:

```sh
cd dotfiles
stow --target=$HOME --restow */
```

You can also prune all of the symlinks with:

```sh
cd dotfiles
just remove
```

or without [just][]:

```sh
cd dotfiles
stow --target=$HOME --delete */
```

[stow]: https://www.gnu.org/software/stow/
[just]: https://just.systems/
