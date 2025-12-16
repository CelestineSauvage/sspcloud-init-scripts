#!/bin/sh

# This init script clones a Git repository that contains a RStudio project (*.Rproj)
# and opens it in RStudio at startup
# Expected parameters : None

# Clone repository and give permissions to the onyxia user
# Clone repository and give permissions to the onyxia user
if command -v rstudio-server &>/dev/null; then 
    if [[ -n "$GIT_REPOSITORY" ]]; then
        REPO_DIR=$(basename "$GIT_REPOSITORY" .git)
        echo "Checking for .Rproj file in repository..."
        if compgen -G "${WORKSPACE_DIR}/${REPO_DIR}/*.Rproj" > /dev/null; then
            echo ".Rproj file found, configuring RStudio hook to activate RStudio project"
            echo "setHook('rstudio.sessionInit', function(newSession) { if (newSession && identical(getwd(), '${WORKSPACE_DIR}')) { message('Activate RStudio project'); rstudioapi::openProject('${REPO_DIR}'); } }, action = 'append')" >> ${HOME}/.Rprofile
        fi
    fi
fi
