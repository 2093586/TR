# Use a Windows base image with .NET framework for general-purpose use
FROM mcr.microsoft.com/windows/servercore:ltsc2022

# Set environment variables for JMeter, Selenium, and Chrome versions
ENV JMETER_VERSION=5.6.3
ENV SELENIUM_VERSION=4.24.0
ENV CHROME_VERSION=130.0.6723.69

# Step 4: download Selenium JAR
RUN powershell -Command \
    New-Item -Path 'C:\jmeter\apache-jmeter-5.6.3\lib' -ItemType Directory
    Invoke-WebRequest -Uri https://github.com/SeleniumHQ/selenium/releases/download/selenium-$env:SELENIUM_VERSION/selenium-java-$env:SELENIUM_VERSION.zip -OutFile C:\Installers\selenium.zip; \
    Expand-Archive -Path C:\Installers\selenium.zip -DestinationPath C:\selenium; \
    Copy-Item -Path C:\selenium\* -Destination C:\jmeter\apache-jmeter-5.6.3\lib -Recurse; \
    Remove-Item C:\Installers\selenium.zip

