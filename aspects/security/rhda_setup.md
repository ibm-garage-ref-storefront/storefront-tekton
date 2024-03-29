# Setting up Red Hat Dependency Analytics
This README details how to install Red Hat Dependency Analytics (based on Snyk) in VS Code.

## Maven
If you don't have Maven installed and setup in the OS that will be used to host VS Code, ensure to do so.

### Windows
[Download](https://maven.apache.org/download.cgi) Maven’s **binary zip archive** and extract it to the desired location (e.g., C:\Program Files\apache-maven-3.8.3).

Open Environment Variables:
 - Windows key + R (to open run window)
 - Paste in `rundll32.exe sysdm.cpl,EditEnvironmentVariables` and press "OK"

Create new System Variable:
  - Variable: `MAVEN_HOME`
  - Value: Maven installation path, e.g., `C:\Program Files\apache-maven-3.8.3`

Update "Path" variable:
  - Click on "Path"
  - Select "Edit"
  - On the new window, click on "Edit" and add the New entry: `%MAVEN_HOME%\bin`
  - Click "OK" on each Envrionment Variables window to close them all

Verify the installation and path setting:
 - Press Win + R, type `powershell` (or `cmd`) and press Enter to start a new prompt
 - Run `mvn -version` and check for confirmation response

### Linux
[Download](https://maven.apache.org/download.cgi) the **binary tar.gz archive** and then follow the instructions to extract it to the desired location
```
cd ~
mv <download-location>/apache-maven-3.8.3-bin.tar.gz .
tar xvf apache-maven-3.8.3-bin.tar.gz 
cd bin
ln -sf /home/<user-name>/apache-maven-3.8.3/bin/mvn mvn
mvn -version
```

### Mac
Install Homebrew package manager
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Install openjdk

```
brew install openjdk
```

Install Maven

```
brew install maven
```

## VS Code
Install via [this webpage](https://code.visualstudio.com/download).

## Red Hat Dependency Analytics
Install the [Red Hat Dependency Analytics plugin](https://marketplace.visualstudio.com/items?itemName=redhat.fabric8-analytics) in VS Code.

### Extension Pack for Java
After having installed Red Hat Dependency Analytics, it may suggest you need the [Extension Pack for Java](https://marketplace.visualstudio.com/items?itemName=vscjava.vscode-java-pack). If so, follow the instructions from within VS Code. Ensure to restart VS Code post install.
