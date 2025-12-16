#!/bin/sh

# This init script clones a Git repository that contains a RStudio project (*.Rproj)
# and opens it in RStudio at startup
# Expected parameters : None

# Clone repository and give permissions to the onyxia user
# Clone repository and give permissions to the onyxia user
echo "[INFO] Checking if rstudio-server is available..."
if command -v rstudio-server &>/dev/null; then 
    echo "[OK] rstudio-server found"

    echo "[INFO] Checking if GIT_REPOSITORY is defined..."
    if [[ -n "$GIT_REPOSITORY" ]]; then
        echo "[OK] GIT_REPOSITORY is set: $GIT_REPOSITORY"

        REPO_DIR=$(basename "$GIT_REPOSITORY" .git)
        PROJECT_PATH="${WORKSPACE_DIR}/${REPO_DIR}"
        echo "[INFO] Repository directory resolved to: ${PROJECT_PATH}"

        echo "[INFO] Checking for .rproj file in repository..."
        if compgen -G "${PROJECT_PATH}/*.rproj" > /dev/null; then
            echo "[OK] .rproj file found, configuring RStudio hook"

            echo "setHook('rstudio.sessionInit', function(newSession) { \
if (newSession && identical(getwd(), '${WORKSPACE_DIR}')) { \
message('Activate RStudio project'); \
rstudioapi::openProject('${PROJECT_PATH}'); \
} }, action = 'append')" >> "${HOME}/.Rprofile"

            echo "[OK] RStudio hook successfully added to ${HOME}/.Rprofile"
        else
            echo "[INFO] No .rproj file found in ${PROJECT_PATH}, skipping RStudio hook"
        fi
    else
        echo "[INFO] GIT_REPOSITORY is not set, skipping repository-related configuration"
    fi
else
    echo "[INFO] rstudio-server not found, skipping RStudio configuration"
fi
