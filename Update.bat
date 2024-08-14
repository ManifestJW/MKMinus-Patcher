cd %~dp0%

set GIT_PATH="%~dp0Prereqs\Git\bin\git.exe"

%GIT_PATH% init %~dp0\.git

%GIT_PATH% pull https://github.com/ManifestJW/MKMinus-Patcher.git