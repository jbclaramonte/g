#!/usr/bin/env bash


function usage()
{
    echo "gcloud shortcuts"
    echo ""
    echo "    -h --help"
    echo "    as <config name>"
    echo "    set <property> <value>"
    echo "          properties available: project"
    echo "    currentConfig : return the currently active config name"
    echo "    list projects : list all projects"
    echo "    list projects containing <text> : list all projects containing <filter>"
    echo ""
}

while [ "$1" != "" ]; do
    PARAM=$1
    case $PARAM in
        -h | --help)
            usage
            exit
            ;;
        as)            
            gcloud config configurations activate  $2
            exit
            ;;
        currentConfig)            
            gcloud config configurations list --format=json | jq '.[] | select(.is_active==true).name' -r
            exit
            ;;            
        list)
            shift
            LIST_CMD=$1
            case $LIST_CMD in
                projects)
                    shift
                    LIST_PROJECT_CMD=$1
                    case $LIST_PROJECT_CMD in
                        containing)
                            gcloud projects list --filter="name:*$2*"
                        ;;
                        *)
                            gcloud projects list
                        ;;
                    esac
                ;;
                *)
                    gcloud config configurations list
                ;;
            esac
            exit
            ;;
        set)
            shift
            SET_TYPE=$1
            case $SET_TYPE in
                project)
                    gcloud config set project $2
                ;;
            esac
            exit
            ;;    
        *)
            echo "ERROR: unknown parameter \"$PARAM\""
            usage
            exit 1
            ;;
    esac
    shift
done



gcloud config list --format=json