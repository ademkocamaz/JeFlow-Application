#include <iostream>
#include <sys/stat.h>
#include <windows.h>

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

void createDB(){
	char cmd[100];
	
	strcpy(cmd, "Python311\\python.exe manage.py makemigrations");
	system(cmd);
	
	strcpy(cmd, "Python311\\python.exe manage.py migrate");
	system(cmd);
	
	strcpy(cmd, "Python311\\python.exe manage.py loaddata State");
	system(cmd);
	
	printf("superuser (jeflow) Enter Password: \n");
	strcpy(cmd, "Python311\\python.exe manage.py createsuperuser --username jeflow --email kocamazadem@gmail.com");
	system(cmd);
}

int main(int argc, char** argv) {
	
	HANDLE hMutexHandle = CreateMutex(NULL, TRUE, "JeFlow_Server");
    if (GetLastError() == ERROR_ALREADY_EXISTS)
    {
        return 0;
    }

	char cmd[100];
	strcpy(cmd,"title JeFlow - Server");
	system(cmd);

	const char* jeflow = "JeFlow-win32-x64";
	const char* python = "Python311";
	const char* db = "db.sqlite3";
	struct stat sb;

	if (stat(jeflow, &sb) == 0) {
		printf("JeFlow-win32-x64 exists.\n");
	} else {
		extractElectronApp();
	}

	if (stat(python, &sb) == 0) {
		printf("Python311 exists.\n");
	} else {
		extractPython();
	}
	
	if(stat(db, &sb)==0){
		printf("db.sqlite3 exists.\n");
	} else {
		createDB();
	}

	printf("Django is starting...\n");
	launchDjangoServer();
	
	ReleaseMutex(hMutexHandle);
    CloseHandle(hMutexHandle);
    
	return 0;
}