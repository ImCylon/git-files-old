#!/usr/bin/env bash
# File              : ginit.sh
# Author            : ImCylon <imcylonrs@gmail.com>
# Date              : 04.08.2023
# Last Modified Date: 01.12.2023
# Last Modified By  : ImCylon <imcylonrs@gmail.com>
#!/bin/sh

cd .

# ┌──────────────────────────────────────────────┐
# │░█▀▀░▀█▀░█▀█░█▀▄░▀█▀░░░█▀▀░█▀█░█▀█░█▀▀░▀█▀░█▀▀│
# │░▀▀█░░█░░█▀█░█▀▄░░█░░░░█░░░█░█░█░█░█▀▀░░█░░█░█│
# │░▀▀▀░░▀░░▀░▀░▀░▀░░▀░░░░▀▀▀░▀▀▀░▀░▀░▀░░░▀▀▀░▀▀▀│
# └──────────────────────────────────────────────┘
read -r -p "Set/Install: GIT, COMMITLINT, HUSKY, COMMITIZEN-CLI?  [Y/n]: " \
    GIT_INIT
if [ "$GIT_INIT" = "" ] || [ "$GIT_INIT" == "y" ] || [ "$GIT_INIT" == "Y" ] || \
    [ "$GIT_INIT" == "yes" ] || [ "$GIT_INIT" == "YES" ]
then
    #### Check if GIT is installed
    if ! command -v git 1>/dev/null 2>&1; then
        echo "Installing git..."
        if command -v emerge 1>/dev/null 2>&1; then
            sudo emerge dev-vcs/git 1>/dev/null 2>&1
        elif command -v pacman 1>/dev/null 2>&1; then
            sudo pacman -S git 1>/dev/null 2>&1
        else
            echo ""
            echo "The git program was not found, please install it according to your Linux distribution."
        fi
    else
        echo -e "$(git --version)"
    fi

#### Check if there is a local git repository
    if [ ! -d .git ]; then
        git init 1>/dev/null 2>&1
    else
        echo "Git repository already exist."
        echo "Update or Reset repository? [U/r]: "
        read -rsn1 GIT_CONT
        if [ "$GIT_CONT" = "" ] || [ "$GIT_CONT" == "U" ] || [ "$GIT_CONT" == "u" ]
        then
            echo ""
            echo "Updating..."
        else
            echo "you want to modify this repository, follow:"
            echo "- Delete .git/"
            echo "- run ginit(again)"
            exit
        fi
    fi
fi

#### Check if NodeJS is installed
if ! command -v node 1>/dev/null 2>&1; then
    echo "Installing nodejs..."
    if command -v emerge 1>/dev/null 2>&1; then
        sudo emerge net-libs/nodejs 1>/dev/null 2>&1
        echo ""
        echo "node version $(node -v)"
    elif command -v pacman 1>/dev/null 2>&1; then
        sudo pacman -S nodejs 1>/dev/null 2>&1
        echo ""
        echo "node version $(node -v)"
    else
        echo ""
        echo "The nodejs program was not found, please install it according to your Linux distribution."
        exit
    fi
else
    echo -e "NodeJS version $(node --version)"
fi

#### Check if npm is installed
if ! command -v npm 1>/dev/null 2>&1; then
    echo "Installing npm..."
    if command -v emerge 1>/dev/null 2>&1; then
        sudo emerge net-libs/nodejs 1>/dev/null 2>&1
        echo ""
        echo "npm version $(node -v)"
    elif command -v pacman 1>/dev/null 2>&1; then
        sudo pacman -S npm
        echo ""
        echo "npm version $(node -v)"
    else
        echo ""
        echo "The npm program was not found, please install it according to your Linux distribution."
        exit
    fi
else
    echo -e "npm version $(npm --version)"
    npm init -y 1>/dev/null 2>&1
    if [ -f package.json ]; then
        echo "npm init -y : Started"
    else
        echo "npm init -y : failed"
        exit
    fi
fi

#### Check if commitlint is installed
if ! command -v commitlint 1>/dev/null 2>&1; then
    echo "Installing commitlint..."
    if command -v npm 1>/dev/null 2>&1; then
        npm install --save-dev @commitlint/{cli,config-conventional} 1>/dev/null 2>&1
        echo "module.exports = {extends: ['@commitlint/config-conventional']}" > commitlint.config.js
        # echo "export default { extends: ['@commitlint/config-conventional'] };" > commitlint.config.js
        # echo "module.exports = {extends: ['@commitlint/config-conventional']}" > commitlint.config.js
        echo -e "Commitlint Version $(npx commitlint --version | sed 's/.*\(commitlint\).*@\(.*\)/\2/')"
        # sudo npm install --global @commitlint/{config-conventional,cli}>/dev/null
        # echo ""
        # echo -e "Commitlint Version eelse $(npx commitlint --version | sed 's/.*\(commitlint\).*@\(.*\)/\2/')"
    else
        echo ""
        echo -e "Commitlint Version $(npx commitlint --version | sed 's/.*\(commitlint\).*@\(.*\)/\2/')"
        echo "module.exports = {extends: ['@commitlint/config-conventional']}" > commitlint.config.js
    fi
else
    # echo "module.exports = {extends: ['@commitlint/config-conventional']}" > commitlint.config.js
    echo "module.exports = {extends: ['@commitlint/config-conventional']}" > commitlint.config.js
    # echo "export default { extends: ['@commitlint/config-conventional'] };" > commitlint.config.js
    echo -e "Commitlint Version $(npx commitlint --version | sed 's/.*\(commitlint\).*@\(.*\)/\2/')"
fi

#### Check if husky is installed
if ! command -v husky 1>/dev/null 2>&1; then
    echo "Installing husky..."
    if command -v npm 1>/dev/null 2>&1; then
        npm install husky --save-dev 1>/dev/null 2>&1
        rm -rfv ./.husky 1>/dev/null 2>&1
        npx husky init 1>/dev/null 2>&1
        # npx husky add .husky/commit-msg  'npx --no -- commitlint --edit ${1}' 1>/dev/null 2>&1
        # npx husky add .husky/commit-msg 'npx --no-install commitlint -g -x $(npm root -g)/@commitlint/config-conventional --edit "${1}"'>/dev/null
        # npx husky add .husky/prepare-commit-msg \
        echo 'npx --no -- commitlint --edit $''{1}' > .husky/commit-msg
        # echo "exec < /dev/tty && node_modules/.bin/cz --hook || true" > .husky/prepare-commit-msg
        echo "exec < /dev/tty && node_modules/.bin/cz --hook || true" > .husky/prepare-commit-msg
        # npx husky add .husky/prepare-commit-msg \
            #     'exec < /dev/tty && npx cz --hook || true'
        # 'exec < /dev/tty && /usr/lib64/node_modules/commitizen/bin/git-cz --hook || true'
        # npx husky add .husky/commit-msg 'npx --no-install commitint --edit "$1"'
        # echo -e "husky version $(husky -v)"
        # sudo npm install --global husky
        # echo ""
        # echo -e "husky version $(husky -v)"
    else
        echo ""
        echo "The husky program was not found, please install it according to your Linux distribution."
    fi
else
    if [ -d .husky ]; then
        rm -rfv ./.husky 1>/dev/null 2>&1
        npx husky install 1>/dev/null 2>&1
        echo 'npx --no -- commitlint --edit $''{1}' > .husky/commit-msg
        echo "exec < /dev/tty && node_modules/.bin/cz --hook || true" > .husky/prepare-commit-msg
        # npx husky add .husky/commit-msg  'npx --no -- commitlint --edit ${1}'
        # npx husky add .husky/commit-msg 'npx --no-install commitlint -g -x $(npm root -g)/@commitlint/config-conventional --edit "${1}"'>/dev/null
        # npx husky add .husky/prepare-commit-msg \
            # exec < /dev/tty && node_modules/.bin/cz --hook || true
        ###    # 'exec < /dev/tty && /usr/lib64/node_modules/commitizen/bin/git-cz || true'>/dev/null
        # npx husky add .husky/prepare-commit-msg \
            #     'exec < /dev/tty && npx cz --hook || true'
        # 'exec < /dev/tty && /usr/lib64/node_modules/commitizen/bin/git-cz --hook || true'
        # npx husky add .husky/commit-msg 'npx --no-install commitint --edit "$1"'
        # echo -e "husky version $(husky -v)"
    fi
fi

### Check if commitizen is installed
if ! command -v commitizen 1>/dev/null 2>&1; then
    echo "Installing commitizen..."
    if command -v npm>/dev/null; then
        npm install --save-dev commitizen 1>/dev/null 2>&1
        # sudo npm install --global commitizen
        echo ""
        npx commitizen init cz-conventional-changelog --save-dev --save-exact --force 1>/dev/null 2>&1

        echo "$(npm list --global|rg commitizen|head -1|sed 's/.*\(commitizen\)@\(.*\)/commitizen version \2/'
        )"
    else
        echo ""
        echo "The commitizen program was not found, please install it according to your Linux distribution."
    fi
else
    npx commitizen init cz-conventional-changelog --save-dev --save-exact --force 1>/dev/null 2>&1
    echo "$(npm list --global|rg commitizen|head -1|sed 's/.*\(commitizen\)@\(.*\)/commitizen version \2/'
    )"
fi

sed -i '/\(.*\)\"scripts\":\s{/ i\  "type": "module",' package.json
echo "" > .husky/pre-commit
chmod ug+x .husky/*
cp ~/.dotfiles/.gitignore .
