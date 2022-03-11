#!/bin/sh

CURRENT_CONTEXT="$(cat ~/.kube/config | grep 'current-context')"
USER="$(echo $CURRENT_CONTEXT | cut -d '/' -f 3)"
NS="$(echo $CURRENT_CONTEXT | cut -d ':' -f 2 | cut -d '/' -f 1)"
CLUSTER="$(echo $CURRENT_CONTEXT | cut -d '/' -f 2 | cut -d ':' -f 1)"

#echo $NS:$USER '('$CLUSTER')'

echo   $CLUSTER
