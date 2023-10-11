# for i in $(seq 1 20); do time -p /bin/zsh --no-rcs -i -c exit; done
# for i in $(seq 1 20); do time /bin/zsh -i -c exit; done

zinit ice atinit'zmodload zsh/zprof' \
    atload'zprof | head -n 20; zmodload -u zsh/zprof'