################ super project management library
# some environment variables
if [[ _SP_INTER_PRJ_PAUSE = "" ]]; then
    export _SP_INTER_PRJ_PAUSE=0
fi

# default to ANDROID_BUILD_TOP for backward compatibility
# TODO remove this default and require the spm config script to set SP_ROOT
if [[ -z $SP_ROOT ]]; then
    export SP_ROOT=${ANDROID_BUILD_TOP}
fi

# sanity check
if [ -z "$SP_PRJ_LIST" ]; then
    echo "SP_PRJ_LIST undefined."
    exit -1
fi

# list all projects currently under management
function _sp_listprojs(){
    local p
    local index=1
    for p in ${SP_PRJ_LIST[@]}
    do
        echo "     $index. $p"
        let "index = $index + 1"
    done
}

# list all projects' status
function _sp_projs_status(){
    local p
    local index=1
    local old_cwd
    for p in ${SP_PRJ_LIST[@]}
    do
        echo "---- $index: $p "
        let "index = $index + 1"

        old_cwd=`pwd`
        cd "${SP_ROOT}/$p"
        git status -s
        cd $old_cwd

        echo "--------------------------------------------------------"
    done

    return 0
}

# build projects
# (NOTE: this is the Android build method)
# DELAYED: as this requires some serious changes
function _sp_build(){
    return 0
}

# matching, on success will set $SP_CURRENT_PROJS
# the caller should check the return value before carrying out other options
function _sp_matchproj() {
    if [ -z $* ]; then
        echo "** invalid invokation of '_sp_matchproj'"
        return
    fi
    local pat=$(echo -n $*)
    local p
    local count=0
    local match
    local is_match
    for p in ${SP_PRJ_LIST[@]}
    do
        is_match=$(echo -n "$p" | grep "$pat");
        if [[ $is_match != "" ]]; then
            let "count = $count + 1"
            match="$p $match"
        fi
    done
    
    if [[ $count > 1 ]]; then
        SP_CURRENT_PROJS=$match
        echo "** Multiple matches: $answer"
        echo $SP_CURRENT_PROJS | xargs -n1
        return 2
    elif [[ $count = 0 ]]; then
        echo "** Can't match any project: $answer"
        return 0
    else
        SP_CURRENT_PROJS=$match
        echo "** Single Match: " $SP_CURRENT_PROJS
        return 1
    fi    
}

# interative choosing function
# only single selection is allowed
# input and output are env variables
# input: SP_PRJ_LIST, per super project list
# output: SP_CURRENT_PROJS
function _sp_chooseproj() {
    local index=1
    local p
    echo "Project choices are:"
    _sp_listprojs

    # for multiple choices last time, only pick the first
    local default_value=`echo $SP_CURRENT_PROJS | cut -d' ' -f1`
    local answer

    export SP_CURRENT_PROJS=
    while [ -z "$SP_CURRENT_PROJS" ]
    do
        echo "You can also type grep pattern for you project."
        echo -n "Which project would you like? [$default_value] "
        read answer

        if [ -z "$answer" ] ; then
            export SP_CURRENT_PROJS=$default_value
        elif (echo -n $answer | grep -q -e "^[0-9][0-9]*$") ; then
            local poo=`echo -n $answer`
            if [ $poo -le ${#SP_PRJ_LIST[@]} ] ; then
                export SP_CURRENT_PROJS=${SP_PRJ_LIST[$(($answer - 1))]}
            else
                echo "** Bad project selection: $answer"
            fi
        else
            _sp_matchproj $answer
            local match_result=$?
            if [[ $match_result = 2 ]];then
                echo "** Interactive mode only supports single choice."
                SP_CURRENT_PROJS=
            elif [[ $match_result = 1 ]]; then
                break
            fi
        fi
    done
}

# main function
# usage: spm [-s <pattern or No.>]+ <command>
# usage: spm [-a] <command>
# -s: selection
function spm(){
    local params=($*)
    local num_params=$#

    local is_all=0
    local interactive=1
    local is_selection=0
    local selections=

    local is_cmds=0
    local commands=

    if [[ $# = 0 ]]; then
        echo "...You forgets the options and commands. (No help for my laziness, sorry ;)"
        return 0
    fi

    # parse parameters
    local p=
    for p in ${params[@]}
    do
        # commands for all
        if [[ $is_cmds = 0 ]]; then
            if [[ $p = "-a" ]]; then
                is_all=1
                interactive=0
                is_cmds=1
                
                selections=${SP_PRJ_LIST[@]}
                continue
            elif [[ $p = "status" ]] || [[ $p = "reload" ]] || [[ $p = "list" ]] ; then
                interactive=0
                commands=$p

                break
            fi
        fi

        # commands for some projects
        if [[ $is_all = 0 ]]; then
            if [[ $is_selection = 1 ]]; then
                is_selection=0
            # support number and pattern
                if (echo -n $p | grep -q -e "^[0-9][0-9]*$"); then
                    selections="${SP_PRJ_LIST[$(($p - 1))]} $selections"
                else
                    _sp_matchproj $p
                    local match_res=$?
                    if [[ $match_res = 0 ]]; then
                        echo "** Some selections are NOT valid, aborting"
                        exit -2
                    else
                        selections="$SP_CURRENT_PROJS $selections"
                    fi
                fi
            else
                if [[ $p = "-s" ]]; then
                    interactive=0
                    is_selection=1
                    continue
                else
                    is_cmds=1
                fi
            fi
        fi

        # assembling commands
        if [[ $is_cmds = 1 ]]; then
            commands="$commands $p"
        fi
    done
    
    if [[ $interactive = 1 ]]; then
        _sp_chooseproj
        selections=$SP_CURRENT_PROJS
     fi

    # refine commands
    local cmd_name=`echo $commands | cut -d' ' -f1`
    if [[ $cmd_name = "cd" ]]; then
        if [[ $(echo $selections | wc -w) > 1 ]]; then
            echo "** 'cd' takes only one project...aborting"
            return 2
        else
            local prj_dir=`echo -n ${SP_ROOT}/$selections`
            cd $prj_dir
            return 0
        fi
    elif [[ $cmd_name = "list" ]]; then
        echo "++ Curren Super Project: ${SP_PRJ_NAME}."
        echo "++ SP List:"
        _sp_listprojs
        return 0
    elif [[ $cmd_name = "status" ]]; then
        _sp_projs_status

        return 0
    elif [[ $cmd_name = "reload" ]]; then
        # reload current project's configuration file
        # this will also reload this library
        echo "** Reload super porject's configuration file."

        . $SP_PRJ_CONF_PATH
        _sp_listprojs

        return 0
    fi

    # apply commands
    selections=("$selections")
    local pause=$_SP_INTER_PRJ_PAUSE
    for p in ${selections[@]}
    do
        local old_cwd=`pwd`
        echo "** On $p"
        cd "${SP_ROOT}/$p"
        $commands 
        cd $old_cwd
        if [[ $pause = 1 ]]; then
            echo -n "-- Enter to continue or 'N/n' to no pause? [Enter/N]"
            local answer='a'
            read answer
            if [[ $answer = "n" ]] || [[ $answer = "N" ]]; then
                pause=0
            fi
        fi
    done
    
}

function sp_reload(){
    . ~/bin/sp_prj_lib.sh
}

function sp_pause_off(){
    echo "turning OFF inter-project pause"
    _SP_INTER_PRJ_PAUSE=0
    echo "DONE."
}
function sp_pause_on(){
    echo "turning ON inter-project pause"
    _SP_INTER_PRJ_PAUSE=1
    echo "DONE."
}
################ library ends
