#!/bin/bash

echo "start setup project development"
clang-format -version
if [ $? != 0 ]; then
    echo "start install clang-format"
    brew install clang-format
fi

cp ./pre-commit-hooks ../.git/hooks/pre-commit
chmod +x ../.git/hooks/pre-commit
echo "setup project succeed"
