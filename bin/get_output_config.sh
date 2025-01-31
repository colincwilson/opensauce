#!/bin/bash
# This returns a property value from the config file.
# A default argument may be given for the case the property is not specified
# in the config file.
# Shell variables in the property value ARE EXPANDED.
# Only the first white-space separated token of the property is taken.
# Usage:
# get_expand_config.sh <property_key> [<default_value>]

PROPKEY=$1
DEFAULT_VALUE=$2

if [ -z "$SAUCE_OUTPUT" ]
then
  SAUCE_OUTPUT=$SAUCE_ROOT/config/output.config
fi

conf=`cat $SAUCE_OUTPUT \
| awk -v pk=$PROPKEY '$1 == pk { print $2 }'`

if [ -z "$conf" ]
then
  conf=$DEFAULT_VALUE
fi

eval echo $conf
