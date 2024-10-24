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

# Expose ports if needed for JMeter
EXPOSE 1099

RUN mkdir .\actions-runner
# Download the GitHub Actions runner package
RUN powershell -Command \
    Invoke-WebRequest -Uri https://github.com/actions/runner/releases/download/v2.320.0/actions-runner-win-x64-2.320.0.zip -OutFile runner.zip; \
    Expand-Archive -Path runner.zip -DestinationPath .; \
    Remove-Item -Force runner.zip

# Configure the GitHub Actions runner
RUN .\config.cmd --url https://github.com/sgullluu/DevOps-Files --token AKKVT2CLUSZI5CTPL65R6GLHDKUBG --unattended 

# Start the GitHub Actions runner
CMD ["cmd", "/c", ".\\run.cmd"]

