# Use a Windows base image with .NET framework for general-purpose use
FROM mcr.microsoft.com/windows/servercore:ltsc2022

# Create a directory for installation files using PowerShell
RUN powershell -Command \
    New-Item -Path 'C:\Installers' -ItemType Directory

# Step 1: Install Google Chrome
RUN powershell -Command \
    Invoke-WebRequest -Uri https://dl.google.com/chrome/install/GoogleChromeStandaloneEnterprise64.msi -OutFile C:\Installers\chrome_installer.msi; \
    Start-Process msiexec.exe -ArgumentList '/i C:\Installers\chrome_installer.msi /quiet /norestart' -NoNewWindow -Wait

# Step 2: Download and install JMeter
RUN powershell -Command \
    Invoke-WebRequest -Uri https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-5.6.3.zip -OutFile C:\Installers\jmeter.zip; \
    Expand-Archive -Path C:\Installers\jmeter.zip -DestinationPath C:\jmeter; \
    Remove-Item C:\Installers\jmeter.zip

# Step 3: Download ChromeDriver and place it in a folder
RUN powershell -Command \
    Invoke-WebRequest -Uri https://storage.googleapis.com/chrome-for-testing-public/130.0.6723.69/win64/chromedriver-win64.zip -OutFile C:\Installers\chromedriver.zip; \
    Expand-Archive -Path C:\Installers\chromedriver.zip -DestinationPath C:\chromedriver; \
    Remove-Item C:\Installers\chromedriver.zip

# Step 4: download Selenium JAR
RUN powershell -Command \
    Invoke-WebRequest -Uri https://github.com/SeleniumHQ/selenium/releases/download/selenium-4.24.0/selenium-java-4.24.0.zip -OutFile C:\Installers\selenium.zip; \
	Expand-Archive -Path C:\Installers\selenium.zip -DestinationPath C:\selenium; \
    Remove-Item C:\Installers\selenium.zip

# Step 5: Download and configure GitHub runner
RUN powershell -Command \
    Invoke-WebRequest -Uri https://github.com/actions/runner/releases/download/v2.320.0/actions-runner-win-x64-2.320.0.zip  -OutFile C:\Installers\runner.zip; \
    Expand-Archive -Path C:\Installers\runner.zip -DestinationPath C:\actions-runner; \
    Remove-Item C:\Installers\runner.zip

# Set up the GitHub runner (install and configure)
RUN powershell -Command \
    Set-Location -Path C:\actions-runner; \
    .\config.cmd --url https://github.com/2093586/TR --token BL2IIEOUP77MKMGJBJPSZEDHDJWKW --unattended

# Expose ports if needed for JMeter
EXPOSE 1099

# Set the default command to open JMeter
CMD ["cmd", "/c", "C:\\jmeter\\apache-jmeter-5.6.3\\bin\\jmeter.bat"]
