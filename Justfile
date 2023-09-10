install:
	#!/usr/bin/env bash
	stow --verbose --target=$HOME --restow */

remove:
	#!/usr/bin/env bash
	stow --verbose --target=$HOME --delete */
