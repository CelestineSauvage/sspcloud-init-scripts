#!/bin/sh

# This init script clones a Git repository that contains a RStudio project (*.Rproj)
# and opens it in RStudio at startup
# Expected parameters : None

# Clone repository and give permissions to the onyxia user
# Clone repository and give permissions to the onyxia user
if command -v rstudio-server &>/dev/null; then 
    if [[ -n "$GIT_REPOSITORY" ]]; then
        REPO_DIR=$(basename "$GIT_REPOSITORY" .git)
        PROJECT_PATH="${WORKSPACE_DIR}/${REPO_DIR}"

        if compgen -G "${PROJECT_PATH}/*.Rproj" > /dev/null; then
            echo "setHook('rstudio.sessionInit', function(newSession) { \
if (newSession && identical(getwd(), '${WORKSPACE_DIR}')) { \
message('Activate RStudio project'); \
rstudioapi::openProject('${PROJECT_PATH}'); \
} }, action = 'append')" >> "${HOME}/.Rprofile"
        fi
    fi
fi
