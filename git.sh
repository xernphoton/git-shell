#!/bin/sh

if ! command -v git &> /dev/null
then
    echo "git is not installed on your system"
    exit
fi

read -p "Action: " action

if [ "$action" = "init" ]; then
    git init
elif [ "$action" = "clone" ]; then
    read -p "Github? [Y/n]: " github
    if [ "$github" = "Y" ] || [ "$github" = "y" ]; then
        read -p "User: " user
        read -p "Repository: " repository
        git clone "https://github.com/$user/$repository.git"
    else
        read -p "Remote? [Y/n]: " remote
        if [ "$remote" = "Y" ] || [ "$remote" = "y" ]; then
            read -p "URL (no https:// or .git): " url
            git clone "https://$url.git"
        else
            read -p "Path: " path
            git clone "$path"
        fi
    fi
elif [ "$action" = "add" ]; then
    read -p "All files? [Y/n]: " all
    if [ "$all" = "Y" ] || [ "$all" = "y" ]; then
        git add *
    else
        read -p "File: " file
        git add "$file"
    fi
elif [ "$action" = "commit" ]; then
    read -p "Message? [Y/n]: " msg
    if [ "$msg" = "Y" ] || [ "$msg" = "y" ]; then
        read -p "Message: " message
        git commit -m '"$message"'
    else
        git commit
    fi
elif [ "$action" = "push" ]; then
    read -p "Branch: " branch
    git push origin "$branch"
elif [ "$action" = "remote" ]; then
    read -p "Subcommand: " subcommand
    if [ "$subcommand" = "add" ]; then
        read -p "URL (no https:// or .git): " url
        git remote origin "https://$url.git"
    elif [ "$subcommand" = "rename" ]; then
        read -p "Filename: " branch
        read -p "New Name for $branch: " new
        git remote rename "$filename" "$new"
    elif [ "$subcommand" = "remove" ]; then
        read -p "Filename: " filename
        git remote remove filename
    elif [ "$subcommand" = "set-head" ]; then
        read -p "Delete? [Y/n]: " delete
        read -p "Branch: " branch
        if [ "$delete" = "Y" ] || [ "$delete" = "y" ]; then
            git remote set-head "$branch" -d
        else
            git remote set-head "$branch"
        fi
    elif [ "$subcommand" = "set-branches" ]; then
        read -p "Add? [Y/n]: " add
        if [ "$add" = "Y" ] || [ "$add" = "y" ]; then
            read "Branches to add (separate with spaces): " branches
            git remote set-branches --add "$branches"
        else
            read -p "Branches to track (seperate with spaces, resets tracked branches): " branches
            git remote set-branches "$branches"
        fi 
    elif [ "$subcommand" = "get-url" ]; then
        read -p "Remote name: " name
        git remote get-url "$name"
    elif [ "$subcommand" = "set-url" ]; then
        read -p "Remote name: " name
        read -p "New URL: " url
        git remote set-url "$name" "$url"
    elif [ "$subcommand" = "show" ]; then
        read -p "Remote name: " name
        git remote show "$name"
    elif [ "$subcommand" = "prune" ]; then
        read -p "Remote name: " name
        git remote prune "$name"
    elif [ "$subcommand" = "update" ]; then
        git remote update
    else
        echo "Invalid Subcommand"
        exit 1
    fi
elif [ "$action" = "checkout" ]; then
    read -p "Action [ switch | new | revert ] : " subaction
    if [ "$subaction" = "switch" ]; then
        read -p "Branch: " branch
        git checkout "$branch"
    elif [ "$subaction" = "new" ]; then
        read -p "New branch name: " branch
        git checkout -b "$branch"
    elif [ "$subaction" = "revert" ]; then
        read -p "All files? [Y/n]: " all
        if [ "$all" = "Y" ] || [ "$all" = "y" ]; then
            git checkout .
        else
            read -p "File to revert: " file
            git checkout -- file
        fi
    else
        echo "Invalid Action"
        exit 1
    fi
elif [ "$action" = "branch" ]; then
    read -p "Action [ switch | new | delete ]: " subaction
    if [ "$action" = "switch" ]; then
        read -p "Branch: " branch
        git branch "$branch"
    elif [ "$action" = "new" ]; then
        read -p "New branch name: " branch
        git branch "$branch"
    elif [ "$action" = "delete" ]; then
        read -p "Branch: " branch
        git branch -d "$branch"
    else
        echo "Invalid Action"
        exit 1
    fi
elif [ "$action" = "pull" ]; then
    git pull
elif [ "$action" = "merge" ]; then
    read -p "Branch to merge: " merge_branch
    git merge "$merge_branch"
elif [ "$action" = "diff" ]; then
    read -p "File/branch 1: " one
    read -p "File/branch 2: " two
    git diff one two
elif [ "$action" = "tag" ]; then
    read -p "Action [ new | delete | list ] : " subaction
    if [ "$subaction" = "new" ]; then
        read -p "Version: " version
        read -p "Latest commit? [Y/n]: " latest
        if [ "$latest" = "Y" ] || [ "$latest" = "y" ]; then
            read -p "Message: " message
            git tag -a "$version" -m "$message"
        else
            read -p "Commit checksum: " checksum
            read -p "Message: " message
            git tag -a "$version" "$checksum" -m "$message"
        fi
    elif [ "$subaction" = "delete" ]; then
        read -p "Version: " version
        git tag -d "$version"
    elif [ "$subaction" = "list" ]; then
        git tag -l
    else
        echo "Invalid Action"
        exit 1
    fi
elif [ "$action" = "log" ]; then
    command=""
    read -p "View [ simple | one-line | graph | short ]: " view
    if [ "$view" = "simple" ]; then
        read -p "Filters [ amount | date | author | changed | message | range | file ]: " filters
        command="git log"
        if [[ "$filters" = *"amount"* ]]; then
            read -p "Amount of commits to display: " amount
            command="$command"" -$amount"
        fi
        if [[ "$filters" = *"date"* ]]; then
            echo "Format: YEAR-MONTH-DAY or relative references such as 'today', 'yesterday', and '1 week ago'"
            read -p "Before: " before
            read -p "After: " after
            command="$command"' --before="$before" --after="$after"'
        fi
        if [[ "$filters" = *"author"* ]]; then
            read -p "Author: " author
            command="$command"' --author="$author"'
        fi
        if [[ "$filters" = *"changed"* ]]; then
            command="$command"" --name-status"
        fi
        if [[ "$filters" = *"message"* ]]; then
            read -p "Message content to search for: " message
            command="$command"' --grep="$message"'
        fi
        if [[ "$filters" = *"range"* ]]; then
            read -p "Branch 1 (main): " one
            read -p "Branch 2: " two
            command="$command"" $one..$two"
        fi
        if [[ "$filters" = *"file"* ]]; then
            read -p "Files to look for (space seperated): " files
            command="$command"" -- $files"
        fi
        eval $command
    elif [ "$view" = "one-line" ]; then
        read -p "Filters [ amount | date | author | changed | message | file | range ]: " filters
        command="git log --pretty=oneline"
        if [ "$filters" = *"amount"* ]; then
            read -p "Amount of commits to display: " amount
            command="$command"" -$amount"
        elif [ "$filters" = *"date"* ]; then
            echo "Format: YEAR-MONTH-DAY or relative references such as 'today', 'yesterday', and '1 week ago'"
            read -p "Before: " before
            read -p "After: " after
            command="$command"' --before="$before" --after="$after"'
        elif [ "$filters" = *"author"* ]; then
            read -p "Author: " author
            command="$command"' --author="$author"'
        elif [ "$filters" = *"changed"* ]; then
            command="$command"" --name-status"
        elif [ "$filters" = *"message"* ]; then
            read -p "Message content to search for: " message
            command="$command"' --grep="$message"'
        elif [ "$filters" = *"range"* ]; then
            read -p "Branch 1 (main): " one
            read -p "Branch 2: " two
            command="$command"" $one..$two"
        elif [ "$filters" = *"file"* ]; then
            read -p "Files to look for (space seperated): " files
            command="$command"" -- $files"
        else
            echo "Invalid Filters"
            exit 1
        fi
        eval $command
    elif [ "$view" = "graph" ]; then
        read -p "Filters [ amount | date | author | changed | message | file | range ]: " filters
        command="git log --graph --oneline --decorate --all"
        if [ "$filters" = *"amount"* ]; then
            read -p "Amount of commits to display: " amount
            command="$command"" -$amount"
        elif [ "$filters" = *"date"* ]; then
            echo "Format: YEAR-MONTH-DAY or relative references such as 'today', 'yesterday', and '1 week ago'"
            read -p "Before: " before
            read -p "After: " after
            command="$command"' --before="$before" --after="$after"'
        elif [ "$filters" = *"author"* ]; then
            read -p "Author: " author
            command="$command"' --author="$author"'
        elif [ "$filters" = *"changed"* ]; then
            command="$command"" --name-status"
        elif [ "$filters" = *"message"* ]; then
            read -p "Message content to search for: " message
            command="$command"' --grep="$message"'
        elif [ "$filters" = *"range"* ]; then
            read -p "Branch 1 (main): " one
            read -p "Branch 2: " two
            command="$command"" $one..$two"
        elif [ "$filters" = *"file"* ]; then
            read -p "Files to look for (space seperated): " files
            command="$command"" -- $files"
        else
            echo "Invalid Filters"
            exit 1
        fi
        eval $command
    elif [ "$view" = "short" ]; then
        git shortlog
    else
        echo "Invalid View"
        exit 1
    fi
elif [ "$action" = "fetch" ]; then
    read -p "All? [Y/n]: " all
    if [ "$all" = "Y" ] || [ "$all" = "y" ]; then
        git fetch --all
    else
        read -p "Repository: " repository
        read -p "Branch: " branch
        git fetch "$repository" "$branch"
    fi
elif [ "$action" = "pull" ]; then
    read -p "Commit? [Y/n]: " commit
    if [ "$commit" = "Y" ] || [ "$commit" = "y" ]; then
        git pull
    else
        git pull --no-commit
    fi
elif [ "$action" = "reset" ]; then
    read -p "Hard? [Y/n]: " hard
    if [ "$hard" = "Y" ] || [ "$hard" = "y" ]; then
        git reset --hard
    else
        read -p "Soft? [Y/n]: " soft
        if [ "$soft" = "Y" ] || [ "$soft" = "y" ]; then
            git reset --soft
        else
            git reset
        fi
    fi
else
    echo "Invalid Action"
    exit 1
fi