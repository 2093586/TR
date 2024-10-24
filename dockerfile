# Use a Windows base image with .NET framework for general-purpose use
FROM mcr.microsoft.com/windows/servercore:ltsc2022

# Step 5: Download and configure GitHub runner
RUN powershell -Command \
    Invoke-WebRequest -Uri https://github.com/actions/runner/releases/download/v2.320.0/actions-runner-win-x64-2.320.0.zip  -OutFile C:\Installers\runner.zip; \
    Expand-Archive -Path C:\Installers\runner.zip -DestinationPath C:\actions-runner; \
    Remove-Item C:\Installers\runner.zip

# Set up the GitHub runner (install and configure)
RUN powershell -Command \
    Set-Location -Path C:\actions-runner; \
    .\config.cmd --url https://github.com/2093586/TR --token BL2IIEOUP77MKMGJBJPSZEDHDJWKW --unattended
