# My dotfiles

To store my dotfiles I create a Git bare repository in `$HOME/.dotfiles/`. Then create an alias so that the commands are run against
that repository.

Create Git bare repository:
```
git init --bare $HOME/.dotfiles/
```
Create alias (you can add this to your `$HOME/.bashrc`):
```
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
```
Hide files I'm not tracking:
```
dotfiles config --local status.showUntrackedFiles no
```
Now I can manage my dotfiles with:

**Note:** if you have sensitive data in any file you are going to store please read [Filters](#filters) section.
```
dotfiles status
dotfiles add .bashrc
dotfiles commit -m "Add bashrc."
dotfiles push
```

## Filters

Some files contain sensitive data so you can use git filters to change it.

The irssi configuration file saves the password in plain text, so I created, with the help of `#awk`, a git filter to change
the `password` field. I have created filters to also change the `real_name`, `user_name` and `nick` fields. These changes are
made in the `config` file and `config.autosave`.

In `$GIT_DIR/info/attributes`:
```
config filter=irssi
config.autosave filter=irssi
```
In `$GIT_DIR/config`:
```
[filter "irssi"]
        clean = "awk '(/password = \"[^\"]*\";/ && sub(/password = \"[^\"]*\";/, \"password = \\\"<PASSWORD>\\\";\")) { p++ } (/real_name = \"[^\"]*\";/ && sub(/real_name = \"[^\"]*\";/, \"real_name = \\\"<REALNAME>\\\";\")) { r++ } (/user_name = \"[^\"]*\";/ && sub(/user_name = \"[^\"]*\";/, \"user_name = \\\"<USERNAME>\\\";\")) { u++ } (/nick = \"[^\"]*\";/ && sub(/nick = \"[^\"]*\";/, \"nick = \\\"<NICK>\\\";\")) { n++ } {print} END { exit(!(p && r && u && n)) }'"
```

## Add your dotfiles onto a new system

Script `clonedotfiles.sh` that automates this proccess:
```bash
#!/bin/bash

git_dir_name=".dotfiles"
work_tree="$HOME"
git_dir="$work_tree/$git_dir_name"
dotfiles_backup="$work_tree/.dotfiles_backup"
repo="https://github.com/NCSantos/dotfiles.git"

function dotfiles {
    /usr/bin/git --git-dir="$git_dir" --work-tree="$work_tree" $@
}

mkdir -p "$git_dir"

# Ignore git dir where repo is cloned.
echo "$git_dir_name" >> "$work_tree/.gitignore"

git clone --bare "$repo" "$git_dir"

mkdir -p "$dotfiles_backup"

# Get output from stderr.
cout=$(dotfiles checkout 2>&1)

# Checkout failed, assuming it's because some dotfiles already exist in the
# working dir.
if [ ! $? = 0 ]; then
    echo -e "\nCheckout error:"
    echo "$cout"

    # Get file names from checkout error.
    # Someone pointed out that I should use git plumbing commands and not
    # "git checkout" to get file names. Tried some plumbing commands, like
    # "git checkout-index" without success.
    files_str=$(echo "$cout" | awk '/^[ \t]+/ {print $1;}')
    echo -e "\nMoving files:"
    echo "$files_str"

    files_arr=($files_str)
    len=${#files_arr[@]}

    # Checkout failed because of another error?
    if [ $len = 0 ]; then
        echo -e "\nCheckout gave error but couldn't find files to move."
        exit 1
    fi

    for (( i=0;i<$len;i++)); do
        file=${files_arr[${i}]}
        path="${file%/*}"
        if [ -d "$path" ] ; then
            mkdir -p "$dotfiles_backup/$path"
        fi
        mv "$file" "$dotfiles_backup/$file"
    done

    dotfiles checkout
fi

echo -e "\nCheckout successfully."

dotfiles config status.showUntrackedFiles no
```
This script creates the necessary folders, clones my dotfiles repository and adds with `config checkout` the dotfiles to the
working tree `$HOME`. If my working tree already has dotfiles that are going to be added git fails with a message like:
```
error: The following untracked working tree files would be overwritten by checkout:
    .bashrc
Please move or remove them before you can switch branches.
Aborting
```
In this case the script moves this dotfiles to a backup folder `.dotfiles_backup`.

## Manage Vim plugins

To manage Vim plugins I use Git subtrees.

Add the subtree as a remote:
```
dotfiles remote add -f vim-repeat https://github.com/tpope/vim-repeat.git
```
Add the subtree referring to the remote in its short form:
```
dotfiles subtree add --prefix .vim/pack/plugins/start/vim-repeat vim-repeat master --squash
```
To not store the entire history of the subproject in your main repository use the `--squash`flag.

Later to update sub-project do:
```
dotfiles fetch vim-repeat master
dotfiles subtree pull --prefix .vim/pack/plugins/start/vim-repeat vim-repeat master --squash
```
To remove a Git subtree use `git rm`:
```
dotfiles rm -r .vim/pack/plugins/start/vim-repeat
```
