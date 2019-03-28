#!/bin/bash
# Entry script that does the following:
# - Start Xvfb with the appropriate display indo
# - clone the robot tests git repo
# - checkout the correct branch and hash
# - run the robot tests

# stop the script on errors
set -e

# Set the defaults
DEFAULT_LOG_LEVEL="TRACE" # Available levels: TRACE (default), DEBUG, INFO, WARN, NONE (no logging)
DEFAULT_RES="1280x1024x24"
DEFAULT_OUTPUT_FOLDER=/opt/robot/reports
DEFAULT_ROBOT_TESTS=/opt/robot/tests
DEFAULT_GIT_BRANCH=master
DEFAULT_PROCESS_COUNT=1

# Use defaults for following if none specified as env var
LOG_LEVEL=${LOG_LEVEL:-$DEFAULT_LOG_LEVEL}
RES=${RES:-$DEFAULT_RES}
PROCESS_COUNT=${PROCESS_COUNT:-$DEFAULT_PROCESS_COUNT}
# OUTPUT_FOLDER env variable can also be overridden by -d command line argument.
OUTPUT_FOLDER=${OUTPUT_FOLDER:-$DEFAULT_OUTPUT_FOLDER}
ROBOT_TESTS=${ROBOT_TESTS:-$DEFAULT_ROBOT_TESTS}
GIT_BRANCH=${GIT_BRANCH:-$DEFAULT_GIT_BRANCH}

#No defaults for these
VARIABLEFILES=
LISTENERS=
ROBOT_TAGS=
COMMIT_HASH=
TEST_RUNNER=

# get parameters for running the robot scripts
while [ $# -gt 1 ]
do
	key="$1"

	case $key in
    	-i|--include)
    		ROBOT_TAGS="${ROBOT_TAGS} --include $2"
    		shift
    		;;
    	-e|--exclude)
    		ROBOT_TAGS="${ROBOT_TAGS} --exclude $2"
    		shift
    		;;
    	-d|--outputdir)
    		OUTPUT_FOLDER=$2
    		shift
    		;;
  		--listener)
    		LISTENERS="${LISTENER} --listener $2 "
    		shift
    		;;
   		-V|--variablefile)
    		VARIABLEFILES="${VARIABLEFILES} --variablefile $2 "
    		shift
    		;;
   		-v|--variable)
    		VARIABLES="${VARIABLES} --variable $2 "
    		shift
    		;;
   		--git-hash)
    		COMMIT_HASH=$2
    		shift
    		;;
   		--git-branch)
    		GIT_BRANCH=$2
    		shift
    		;;
   		--processes)
    		PROCESS_COUNT=$2
    		shift
    		;;
	esac
	shift
done

# Update the robot code by cloning the git repo. note this will be updated to the branch you specify.
cd $ROBOT_TESTS
git reset --hard HEAD
git clean -f -d
git pull

#if commit hash specified checkout that
#commit hash looks like this "45ef55ac20ce2389c9180658fdba35f4a663d204"
if [ "${COMMIT_HASH}" != "" ];then
  echo "checking out commit hash ${COMMIT_HASH}"
  git checkout ${COMMIT_HASH}
else
  echo "checking out branch ${GIT_BRANCH}"
  git checkout ${GIT_BRANCH}
fi

# Print some info
echo -e "Executing robot tests at log level ${LOG_LEVEL}"
echo -e "Putting robot tests output in ${OUTPUT_FOLDER}"
if [ "${VARIABLEFILES}" != "" ];then
	echo -e "Added these variable files ${VARIABLEFILES}"
fi
if [ "${VARIABLES}" != "" ];then
	echo -e "Added these variables ${VARIABLES}" 
fi

#quick note in case you meant to have tags
if [ "${ROBOT_TAGS}" = "" ];then
  echo "ROBOT_TAGS empty, running all tests"
else
  echo -e "Running just these robot tags ${ROBOT_TAGS}"
fi

# Pick out pabot vs robot depending on number of processes.
if [ $PROCESS_COUNT -gt 1 ];then
  TEST_RUNNER="pabot --processes ${PROCESS_COUNT}"
else
  TEST_RUNNER="robot"
fi

# Start Xvfb and run robot in it
echo -e "Starting xvfb-run on display 0 with resolution ${RES}"
xvfb-run --server-args="-ac -screen 0 ${RES} +extension RANDR" ${TEST_RUNNER} --loglevel ${LOG_LEVEL} --outputdir ${OUTPUT_FOLDER} ${VARIABLEFILES} ${VARIABLES} ${LISTENERS} ${ROBOT_TAGS} ${ROBOT_TESTS}
