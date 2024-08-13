set GIT_PATH="%~dp0Prereqs\Git\bin\git.exe"

%GIT_PATH% init %~dp0%

%GIT_PATH% pull https://github.com/ManifestJW/MKMinus-Patcher.git

pause