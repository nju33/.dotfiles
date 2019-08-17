function remote-development
  argparse "u/user=" "o/org=" "r/repo=" -- $argv
    set -l namespace
    set -l repo

    if set -q _flag_user
      set namespace $_flag_user
    else if set -q _flag_org
      set namespace $_flag_org
    else
      set namespace nju33
    end

    if set -q _flag_repo
      set repo $_flag_repo
    else
      echo `--repo`を指定して
      return 1
    end

    set -l host $namespace.$repo.vscode
    set -l path $namespace/$repo

    if test "$namespace" = "nju33"
      set host $namespace.vscode
    end

    ssh $host -t "cd github/$path && fish"
  or return 1
end
