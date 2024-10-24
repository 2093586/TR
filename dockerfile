# Use a Windows base image with .NET framework for general-purpose use
FROM mcr.microsoft.com/windows/servercore:ltsc2022

# Set environment variables for JMeter, Selenium, and Chrome versions
ENV JMETER_VERSION=5.6.3
ENV SELENIUM_VERSION=4.24.0
ENV CHROME_VERSION=130.0.6723.69


# Create a directory for installation files using PowerShell
RUN powershell -Command \
    New-Item -Path 'C:\Installers' -ItemType Directory

# Step 1: Install Google Chrome
RUN powershell -Command \
    Invoke-WebRequest -Uri https://dl.google.com/chrome/install/GoogleChromeStandaloneEnterprise64.msi -OutFile C:\Installers\chrome_installer.msi; \
    Start-Process msiexec.exe -ArgumentList '/i C:\Installers\chrome_installer.msi /quiet /norestart' -NoNewWindow -Wait

# Step 2: Download and install JMeter
RUN powershell -Command \
    Invoke-WebRequest -Uri https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-$env:JMETER_VERSION.zip -OutFile C:\Installers\jmeter.zip; \
    Expand-Archive -Path C:\Installers\jmeter.zip -DestinationPath C:\JMeter; \
    Remove-Item C:\Installers\jmeter.zip

# Step 3: Download ChromeDriver and place it in a folder
RUN powershell -Command \
    Invoke-WebRequest -Uri https://storage.googleapis.com/chrome-for-testing-public/$env:CHROME_VERSION/win64/chromedriver-win64.zip -OutFile C:\Installers\chromedriver.zip; \
    Expand-Archive -Path C:\Installers\chromedriver.zip -DestinationPath C:\ChromeDriver; \
    Remove-Item C:\Installers\chromedriver.zip

# Step 4: download Selenium JAR
RUN powershell -Command \
    Invoke-WebRequest -Uri https://github.com/SeleniumHQ/selenium/releases/download/selenium-$env:SELENIUM_VERSION/selenium-java-$env:SELENIUM_VERSION.zip -OutFile C:\Installers\selenium.zip; \
    Remove-Item C:\Installers\selenium.zip

COPY C:\Installers\selenium/ C:\Installers\jmeter\apache-jmeter-5.6.3\lib

# Expose ports if needed for JMeter
EXPOSE 1099

# Set the default command to open JMeter
CMD ["cmd", "/c", "C:\\Installers\\jmeter\\apache-jmeter-5.6.3\\binjmeter.bat"]
