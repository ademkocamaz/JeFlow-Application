#include <iostream>
#include <sys/stat.h>
/* run this program using the console pauser or add your own getch, system("pause") or input loop */
using namespace std;

void launchDjangoServer() {
	char cmd[100];
	strcpy(cmd, "Python311\\python.exe manage.py runserver --noreload");
	system(cmd);
}

void extractElectronApp() {
	char cmd[100];
	strcpy(cmd, "7z.exe x JeFlow-win32-x64.zip");
	system(cmd);
}

void extractPython() {
	char cmd[100];
	strcpy(cmd, "7z.exe x Python311.zip");
	system(cmd);
}

int main(int argc, char** argv) {

	const char* jeflow = "JeFlow-win32-x64";
	const char* python = "Python311";
	struct stat sb;

	if (stat(jeflow, &sb) == 0) {
		printf("JeFlow-win32-x64 klasör mevcut.\n");
	} else {
		extractElectronApp();
	}
	
	if (stat(python, &sb) == 0) {
		printf("Python311 klasör mevcut.\n");
	} else {
		extractElectronApp();
	}
	
	printf("Django başlatılıyor.");
	launchDjangoServer();

	return 0;
}