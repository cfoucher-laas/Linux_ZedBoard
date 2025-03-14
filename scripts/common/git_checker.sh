#! /bin/bash

#
# File:      git_checker.sh
#
# Author:    Clément Foucher <Clement.Foucher@laas.fr>
#            2015; 2017 - Laboratoire d'analyse et d'architecture des systèmes (LAAS-CNRS)
#
# Copyright: Copyright 2015; 2017 CNRS
#
#            This program is free software: you can redistribute it and/or modify
#            it under the terms of the GNU General Public License as published by
#            the Free Software Foundation, either version 2 of the License, or
#            (at your option) any later version.
#
#            This program is distributed in the hope that it will be useful,
#            but WITHOUT ANY WARRANTY; without even the implied warranty of
#            MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#            GNU General Public License for more details.
#
#            You should have received a copy of the GNU General Public License
#            along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
#
# Version:   1.2
#
# Date:      2017-05-17
#
# Description:
#
#            This script provides a check for required sources
#            coming from a remote git repository.
#            It can trigger download if source is missing (user will
#            be prompted). It will pull the git when sources are present
#            and a newer version is available.
#            When sources have been downloaded/updated, it will checkout
#            to the required git tag.
#
#            Prerequisites:
#              Function $echoandlog must be defined prior to calling this script.
#            Parameters:
#              1 => Source folder
#              2 => Git tag to checkout
#              3 => Name to display to user
#              4 => Internal name for sources to download
#            Returns:
#              - 0: Everything went well
#              - 1: Error downloading files
#              - 2: User refused to download files
#              - 9: Script internal error (e.g. script was launched with wrong parameters)
#
# Release notes:
#
#            Version  Who              Date        Changes
#            -------  ---------------  ----------  -------------------------------------------------------
#            1.0      Clément Foucher  2015-09-21  First release.
#            1.1      Clément Foucher  2017-02-10  Use new log functions.
#            1.2      Clément Foucher  2017-05-17  Now in charge of git checking out + fetch latest version;
#                                                  Removed source compression support; Enhanced read prompt.
#



#########
# Begin #
#########

# Check parameter count
if [ $# -ne 4 ]; then
  echo
  echo "Error! Incorrect number of parameters provided ($#)."
  echo "Plase consult $SCRIPTSDIR/common/git_checker.sh for information on parameters."
  echo

  exit 9
fi

source_folder=$1
current_git_tag=$2
sources_name=$3
internal_name=$4

# Go

if [ -d $source_folder ]; then
  missing_sources=0
else
  missing_sources=1
fi

if [ $missing_sources -eq 1 ]; then

  echoandlog
  echoandlog "$sources_name can't be found."
  writetolog "User is being prompted whether he/she want to download missing sources."
  echo "Do you want to download $sources_name now?"
  echo "This can take some time depending on your connection."
  read -p "(y/N): " -n 1 dl_ans

  if [ -z $dl_ans ]; then
    # No is default answer
    do_download=0
  elif [ $dl_ans == "y" ]; then
    do_download=1
  elif [ $dl_ans == "Y" ]; then
    do_download=1
  else
    do_download=0
  fi

  if [ $do_download -eq 1 ]; then

    writetolog "User choose to download source"

    $SCRIPTSDIR/common/source_downloader.sh $internal_name

    if [ $? -ne 0 ]; then
      echoandlog ""
      echoandlog "Error! An error occured while downloading $sources_name."
      echoandlog ""
      echoandlog "Exiting."
      echoandlog ""

      exit 1
    fi

  else
    echoandlog
    echoandlog "Error! Download cancelled by user."
    echoandlog
    echoandlog "Exiting."

    exit 2
  fi


else
  echoandlog "$sources_name was found."
  echoandlog "Making sure the git is up to date."

  git -C $source_folder fetch
fi

echoandlog
echoandlog "Checking out to version $current_git_tag..."

writetolog "Command line: \`git -C $source_folder checkout $current_git_tag\`"
writetolog "### Begin git output ###"
writetolog ""

git -C $source_folder checkout $current_git_tag &>> $LOGFILE
result=$?

writetolog ""
writetolog "### End git output ###"

if [ $result -ne 0 ]; then
  echoandlog
  echoandlog "Error! Git checkout failed."
  echoandlog "You may want to delete folder $current_source_folder/"
  echoandlog "if it exists."
  echoandlog
  echoandlog "Exiting."
  echoandlog
  exit 1
fi

