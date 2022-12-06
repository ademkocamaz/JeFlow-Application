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

int main(int argc, char** argv) {

	const char* folder = "JeFlow-win32-x64";
	struct stat sb;

	if (stat(folder, &sb) == 0) {
		launchDjangoServer();

	} else {
		extractElectronApp();
		launchDjangoServer();
	}




	return 0;
}